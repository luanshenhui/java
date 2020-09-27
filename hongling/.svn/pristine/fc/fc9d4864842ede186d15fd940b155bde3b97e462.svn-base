package chinsoft.service.member;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CashManager;
import chinsoft.business.DictManager;
import chinsoft.business.GroupMenuManager;
import chinsoft.business.MemberManager;
import chinsoft.core.DEncrypt;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Cash;
import chinsoft.entity.Dict;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class SaveMember extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015724L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strFormData = getParameter("formData");
			String isDiscount = getParameter("isDiscount");
			String strMemberID = EntityHelper.getValueByParamID(strFormData);
			Member parentMember = new MemberManager().getMemberByID(EntityHelper.getValueByKey(strFormData, "parentID").toString());
			Cash cash = null;
			
			Member member = null;
			String strOldPassword = "";
			if(!"".equals(strMemberID)){
				member = new MemberManager().getMemberByID(strMemberID);
				strOldPassword = member.getPassword();
				//用户更改权限组，同步更新用户权限
				String strGroupID = EntityHelper.getValueByKey(strFormData, "groupID").toString();
				Dict oldDict = DictManager.getDictByID(Utility.toSafeInt(strGroupID)); 
				Dict newDict = DictManager.getDictByID(member.getGroupID()); 
				if(!strGroupID.equals(Utility.toSafeString(member.getGroupID()))){
					if(Utility.toSafeInt(strGroupID)< Utility.toSafeInt(member.getGroupID()) 
							&& "10250".equals(Utility.toSafeString(oldDict.getStatusID())) 
							&& "10250".equals(Utility.toSafeString(newDict.getStatusID()))){//升级C-->AA,非管理用户
						String[] strMenuID = member.getMenuIDs().split(",");
						String strNewMenuIDs = new GroupMenuManager().getGroupFunctions(Utility.toSafeInt(strGroupID));
						String strID = "";
						for(String strMenu : strMenuID){
							if(!Utility.contains(strNewMenuIDs, strMenu)){
								strID += strMenu+",";
							}
						}
						member.setMenuIDs(strNewMenuIDs+strID);
						
						// 新系统对应： 快速下单权限
						String[] qstrMenuID = member.getQordermenuids()==null ? new String[]{} : member.getQordermenuids().split(",");
						String qstrNewMenuIDs = new GroupMenuManager().getQGroupFunctions(Utility.toSafeInt(strGroupID));
						String qstrID = "";
						for(String qstrMenu : qstrMenuID){
							if(!Utility.contains(qstrNewMenuIDs, qstrMenu)){
								qstrID += qstrMenu+",";
							}
						}
						member.setQordermenuids(qstrNewMenuIDs+qstrID);
						
					}else{//降级AA-->C或管理用户
						String strNewMenuIDs = new GroupMenuManager().getGroupFunctions(Utility.toSafeInt(strGroupID));
						member.setMenuIDs(strNewMenuIDs);
						
						// 新系统对应： 快速下单权限
						String qstrNewMenuIDs = new GroupMenuManager().getQGroupFunctions(Utility.toSafeInt(strGroupID));
						member.setQordermenuids(qstrNewMenuIDs);
					}
				}
			}
			
			if(member == null){
				member = new Member();
			}
			member = (Member)EntityHelper.updateEntityFromFormData(member, strFormData);
			
			String isCameoLogo = Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "isCameoLogo"));
			if (isCameoLogo!=null && "on".equals(isCameoLogo)){
				member.setLogo(20138);
			}else{
				member.setLogo(null);
			}
			
			if (isDiscount!=null && "on".equals(isDiscount)){
				member.setIsDiscount(CDict.YES.getID());
			} else {
				member.setIsDiscount(CDict.NO.getID());
			}
			String isUserNo = Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "isUserNo"));
			if ("on".equals(isUserNo)){
				member.setIsUserNo(CDict.YES.getID());
			} else {
				member.setIsUserNo(CDict.NO.getID());
			}
			String semiFinished = Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "semiFinished"));
			if ("on".equals(semiFinished)){
				member.setSemiFinished(CDict.YES.getID());
			} else {
				member.setSemiFinished(CDict.NO.getID());
			}
			if(!strOldPassword.equals(member.getPassword())){
				member.setPassword(DEncrypt.md5(member.getPassword()));
			}
			
			// 当客户的上级用户的角色组是“MTM管理用户”的时候，是大B客户 为其创建账户。
			if (member!=null && parentMember!=null 
					&& (member.getGroupID().equals(CDict.AA_CUSTOMERACCOUNT.getID())
					|| member.getGroupID().equals(CDict.A_CUSTOMERACCOUNT.getID())
					|| member.getGroupID().equals(CDict.B_CUSTOMERACCOUNT.getID())
					|| member.getGroupID().equals(CDict.C_CUSTOMERACCOUNT.getID())) 
					&& parentMember.getGroupID().equals(CDict.MTM_MANAGEMENTACCOUNT.getID())
					|| parentMember.getGroupID().equals(CDict.ZMD_MANAGEMENTACCOUNT.getID())
					|| parentMember.getGroupID().equals(CDict.RP_MANAGEMENTACCOUNT.getID())
					|| parentMember.getGroupID().equals(CDict.KM_MANAGEMENTACCOUNT.getID())
					|| parentMember.getGroupID().equals(CDict.ADMIN_MANAGERMENTACCOUNT.getID())){
				new MemberManager().saveMember(member);
				cash = new CashManager().getCashByMemberID(member.getID());
				if (cash == null){
					cash = new Cash();
					cash.setPubMemberID(member.getID());
					cash.setNum(Double.valueOf(0));
					cash.setIsReconciliation(CDict.NO.getID());
				} 
				Integer noticeNum = Utility.toSafeInt((EntityHelper.getValueByKey(strFormData, "noticeNum")));
				Integer stopNum = Utility.toSafeInt(EntityHelper.getValueByKey(strFormData, "stopNum"));
				cash.setNoticeNum(noticeNum);
				cash.setStopNum(stopNum);
				cash.setPubDate(new Date());
				new CashManager().saveCash(cash);
				if (member.getIsDiscount().equals(CDict.YES.getID())){
					output(member.getID());
				} else {
					output(Utility.RESULT_VALUE_OK);
				}
			} else {
				member.setIsDiscount(CDict.NO.getID());
				new MemberManager().saveMember(member);
				output(Utility.RESULT_VALUE_OK);
			}
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}