package chinsoft.service.member;

import hongling.business.StyleProcessManager;
import hongling.entity.StyleProcess;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import chinsoft.bean.SingleSingOnBean;
import chinsoft.business.CDict;
import chinsoft.business.CashManager;
import chinsoft.business.CompanysManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.business.MemberManager;
import chinsoft.business.MessageManager;
import chinsoft.core.HttpContext;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Cash;
import chinsoft.entity.Companys;
import chinsoft.entity.Dict;
import chinsoft.entity.Member;
import chinsoft.entity.Message;
import chinsoft.service.core.BaseServlet;
import chinsoft.service.core.ChangeVersion;
import chinsoft.service.core.Encryption;

public class SingleSignOn extends BaseServlet {

	/**
	 * 单点登录
	 */
	private static final long serialVersionUID = 7391945794655889435L;
	@Override
	public void service(HttpServletRequest request,HttpServletResponse response) {
		// TODO Auto-generated method stub
		String strResult="未找到合法参数";
		String strParam = Utility.toSafeString(request.getParameter("param"));
		if (strParam.length()<0||strParam.length()<0) {
			output("字符串长度错误");
			return;
		}
		try {
			String json=Encryption.decrypt(strParam, CDict.DES_KEY);  //desCrypt.getDesString(strParam);
//			String json= "{\"company\":\"RC000001\",\"customerID\":\"1\",\"customerName\":\"1f2de15d680024fca36c47e16f5c95d2\",\"language\":\"1\",\"password\":\"123456\",\"status\":null,\"username\":\"TESTAA\",\"categoryID\":\"1\",\"fabricNo\":\"DSA001A\",\"processCode\":\"KSZ000002,FSZ000001\"}";
			JSONObject  js=JSONObject.fromObject(json);
			SingleSingOnBean bean=(SingleSingOnBean) JSONObject.toBean(js,SingleSingOnBean.class);
			//查询合作者档案
			CompanysManager companysManager=new CompanysManager();
			Companys company=companysManager.getCompanyByCode(bean.getCompany());
			if (company==null) {
				output("合作平台代码不正确");
				return;
			}
			company.setSingOnBean(bean);
			request.getSession().setAttribute("company", company);
			
			strResult =new MemberManager().login(bean.getUsername(), bean.getPassword());
			if (strResult == Utility.RESULT_VALUE_OK) {
				Member member = new MemberManager().getMemberByUsername(bean.getUsername());
				member.setClientIP(request.getRemoteAddr());
				member.setLastLoginDate(new Date());
				new MemberManager().saveMember(member);
				CurrentInfo.setCurrentMember(member);
				String strVersionID =bean.getLanguage();
				
				ChangeVersion changeVersion=new ChangeVersion();
				changeVersion.setStrVersionID(strVersionID);
				changeVersion.service(request, response);
				HttpContext.setSessionValue(Utility.SessionKey_Version, strVersionID);
				
				// 判断是否是前台用户
				if (!CurrentInfo.isAdmin()) {
					// 判断用户金额是否已经小于提醒金额，如果小于提醒金额，在消息表中插入记录
					// 查询用户金额
					Cash cash = new CashManager().getCashByMemberID(member.getID());
					
					if (cash != null) {
						// 用户金额
						double currentNum = 0;
						
						// 用户提醒金额
						double noticeNum = 0;
						
						if (null != cash.getNum() && !"".equals(cash.getNum())) {
							currentNum = cash.getNum();
						}
						
						if (null != cash.getNoticeNum() && !"".equals(cash.getNoticeNum())) {
							noticeNum = cash.getNoticeNum();
						}
						
						// 判断是否需要插入提示信息
						// 如果金额已经小于提示金额
						if (currentNum < noticeNum) {
							Message message = new Message();
							message.setTitle(ResourceHelper.getValue("Cash_MoneyNotice"));
							message.setContent(ResourceHelper.getValue("Cash_MoneyNoticePre")+"("+currentNum+")"+ResourceHelper.getValue("Cash_MoneyNoticeMid")+"("+noticeNum+")，"+ResourceHelper.getValue("Cash_MoneyNoticeEnd"));
							message.setPubDate(new Date());
							// 查询总管理用户
							Member adminMember = new MemberManager().getMemberListByGroupId(CDict.GROUPID_ZONGGUANLI).get(0);
							message.setPubMemberID(adminMember.getID());
							message.setReceiverID(member.getID());
							message.setIsRead(CDict.NO.getID());
							new MessageManager().saveMessage(message);
						}
					}
				}
				if(bean.getCategoryID() != null && !"".equals(bean.getCategoryID())
						&& bean.getFabricNo() != null && !"".equals(bean.getFabricNo()) 
						&& bean.getProcessCode() != null && !"".equals(bean.getProcessCode())){//电商
					this.putProcessByCode(bean.getCategoryID(), bean.getFabricNo(), bean.getProcessCode());
				}
				String strMyPlatformUrl = "/hongling/pages/common/orden.jsp";
				if(CurrentInfo.isAdmin()){
					strMyPlatformUrl = "/hongling/pages/common/backend.jsp";
				}
				if(member.getHomePage() == 20118){
					strMyPlatformUrl = "/hongling/pages/fix/fix.jsp";
				}else if(member.getHomePage() == 20121){
//					strMyPlatformUrl = "/hongling/pages/common/orden_page.jsp";
					strMyPlatformUrl = "/hongling/orden/dordenPage.do";//快速下单
				}
				response.sendRedirect(strMyPlatformUrl);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			strResult="数据解密错误或者加密数据格式不对";
		}
		output(strResult);
	}
	
	public void putProcessByCode(String strCategoryID, String strFabricNo, String strProcessCode){
		
		this.setTempClothingID(Utility.toSafeInt(strCategoryID));//服装分类
//		this.setTempFabricCode("MTDshirt");//面料
//		this.setTempFabricCode("MTDsuit");//面料
		this.setTempFabricCode(strFabricNo);//面料
		
		String[] strAllProcessCode =strProcessCode.split(",");
		for(String code : strAllProcessCode){
			//根据
			StyleProcess sp = new StyleProcessManager().getStyleProcessByCode(code,strFabricNo);
			String strProcessID = sp.getProcess();
			String strProcessContent = sp.getSpecialProcess();
			
			//普通工艺
			if(!"".equals(strProcessID) && strProcessID != null){
				String strProcess[] = strProcessID.split(",");
				for(String str : strProcess){
					Dict dict = DictManager.getDictByID(Utility.toSafeInt(str));
					Dict dictParent = DictManager.getDictByID(Utility.toSafeInt(dict.getID()));
					if("10001".equals(Utility.toSafeString(dict.getStatusID())) //单选工艺
							|| "10050".equals(Utility.toSafeString(dictParent.getIsSingleCheck()))){
						this.setTempComponentID(Utility.toSafeInt(str));
					}else if("10002".equals(Utility.toSafeString(dict.getStatusID()))
							|| "10008".equals(Utility.toSafeString(dict.getStatusID()))){//多选工艺
						this.setTempParameterID(Utility.toSafeInt(str));
					}
				}
			}
			
			//指定工艺
			if(!"".equals(strProcessContent) && strProcessContent != null){
				String strSpecials[] = strProcessContent.split(",");
				for(String str : strSpecials){
					if(!"".equals(str)){
						this.setTempComponentText(str);
					}
				}
			}
		}
	}

}
