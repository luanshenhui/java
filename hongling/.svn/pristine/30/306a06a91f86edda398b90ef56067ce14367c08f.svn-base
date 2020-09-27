package chinsoft.business;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;

import centling.business.BlDiscountManager;
import centling.business.BlExpressComManager;
import centling.entity.Discount;
import centling.entity.ExpressCom;
import chinsoft.core.DEncrypt;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Fabricconsume;
import chinsoft.entity.InterfaceOperateInfo;
import chinsoft.entity.Member;

public class MemberManager {

	DataAccessObject dao = new DataAccessObject();

	// 构造
	public MemberManager() {
	}

	// 添加&修改会员
	public void saveMember(Member member) {
		Transaction transaction = null;
		Session session = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			if(StringUtils.isEmpty(member.getID())){
				setCode(member, session);
				member.setRegistDate(new Date());
				String menuIDs = new GroupMenuManager().getGroupFunctions(member.getGroupID(), session);
				String qordermenuids = new GroupMenuManager().getQGroupFunctions(member.getGroupID());
				member.setMenuIDs(menuIDs);
				member.setQordermenuids(qordermenuids);
				session.save(member);
			} else {
				String oldParentID = getMemberParentID(member.getID(), session);
				if(!oldParentID.equals(member.getParentID())){
					setCode(member, session);
				}
				session.update(member);
			}
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			if (session != null){
				session.close();
			}
		}
	}
	
	private String getMemberParentID(String strMemberID, Session session){
		String hql = " SELECT ParentID FROM Member  WHERE ID = ? ";
		SQLQuery query = session.createSQLQuery(hql);
		query.setString(0, strMemberID);
		return Utility.toSafeString(query.uniqueResult());
	}
	
	//设置编码
	private Member setCode(Member member, Session session) {
		// 根据ParentID和CategoryID取得当前级别最大的编码
		String hql = " SELECT MAX(Code) FROM Member  WHERE ParentID = ? ";
		SQLQuery query = session.createSQLQuery(hql);
		query.setString(0, member.getParentID());
		String MAXcode = (String) query.uniqueResult();
		String strCode = "";
		// 如果当前级别最大编码不存在,则设置为ParentCode + 0001
		if (MAXcode == null || MAXcode.length() < 4) {
			Member parentMember = (Member) (session.get(Member.class, (Serializable) member.getParentID()));
			if (parentMember != null) {
				strCode = parentMember.getCode()  + "0001";
			}
		} 
		else {
			// 原来的Code+1
			String strTemp = Utility.toSafeString(Integer.parseInt(MAXcode.substring(MAXcode.length() - 4,MAXcode.length())) + 1);
			strCode =MAXcode.substring(0, MAXcode.length()-4) + Utility.padLeft(strTemp,4,'0');
		}
		member.setCode(strCode);
		return member;	
	}

	// 根据ID查询
	public Member getMemberByID(String strMemberID) {
		Member member=(Member)dao.getEntityByID(Member.class, strMemberID);
		if(member!=null){
			extendMember(member);
		}
		return member;
	}

	// 根据用户名查询
	public Member getMemberByUsername(String strUsername) {
		return this.extendMember((Member)dao.getEntityByDual(Member.class, "Username", strUsername));
	}
	
	@SuppressWarnings("unchecked")
	public List<Member> getMemberByKeyword(String strKeyword)
    {
		List<Member> list= new ArrayList<Member>();
    	try {
	    	String hql = "FROM Member m WHERE m.Name LIKE :Keyword OR m.Username LIKE :Keyword OR m.Name LIKE :UpperCaseKeyword OR m.Username LIKE :UpperCaseKeyword ORDER BY m.Username" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("Keyword", "%" + strKeyword + "%");
			query.setString("UpperCaseKeyword", "%" + Utility.toSafeString(strKeyword).toUpperCase() + "%");
			list=query.list();
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return list;
    }

	// / <summary>
	// / 查询全部会员
	// / </summary>
	// / <returns></returns>
	@SuppressWarnings("unchecked")
	public List<Member> getAllMember() {
		return (List<Member>) dao.getAll(Member.class);
	}
	/**
	 * 得到权限组里的用户
	 */
	@SuppressWarnings("unchecked")
	public List<Member> getMembersByGroupID(String value){
		List<Member> list= new ArrayList<Member>();
    	try {
	    	String hql = "FROM Member WHERE groupID like :value" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("value",Utility.toSafeString(value));
			list=query.list();
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return list;
	}
	// 分页
	public List<?> getMembers(int nPageIndex, int nPageSize) {

		return dao.getList(Member.class, nPageIndex, nPageSize);
	}
	
	public long getMembersCount(){
		return dao.getListCount(Member.class);
	}
	
	@SuppressWarnings("unchecked")
	public List<Member> getSubMembers(String strMemberCode,int moneySignID)
    {
		List<Member> list= new ArrayList<Member>();
    	try {
	    	String hql = "FROM Member m WHERE m.Code LIKE ? " ;
	    	if(moneySignID > -1){
	    		hql += "and m.MoneySignID = ?" ;
	    	}
	    	hql += " order by m.Code " ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, strMemberCode + "%");
			if(moneySignID > -1){
				query.setInteger(1, moneySignID);
			}
			list=query.list();
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return list;
    }
	
	public int getSubMembersCount(String strMemberCode)
    {
		int count= 0;
    	try {
	    	String hql = "SELECT COUNT(*) FROM Member m WHERE m.Code LIKE :MemberCode";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("MemberCode", strMemberCode + "%");
			count=Utility.toSafeInt(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return count;
    }
	
	@SuppressWarnings("unchecked")
	public List<Member> getPickMembers(String strKeyword,int searchGroupIDs)
    {
		List<Member> members= new ArrayList<Member>();
    	try {
    		String hql = "SELECT m FROM Member m WHERE (m.Username LIKE :Keyword OR m.Name LIKE :Keyword OR m.ContractNo LIKE :Keyword) AND m.Code LIKE :Code ";

    		if (searchGroupIDs!=-1) {
    			hql+=" AND m.GroupID= :searchGroupIDs";
    		}

    		hql += " ORDER BY m.Username" ;
    		
    		Query query = DataAccessObject.openSession().createQuery(hql);

    		if (searchGroupIDs!=-1) {
    			query.setInteger("searchGroupIDs", searchGroupIDs);
    		}

    		query.setString("Keyword", "%" + strKeyword + "%");
    		String code = CurrentInfo.getCurrentMember().getCode();
    		if("rcmtm".equals(CurrentInfo.getCurrentMember().getUsername())){
    			code = "0001";
    		}
    		query.setString("Code", code + "%");
    		
    		members=query.list();
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return members;
    }
	
	@SuppressWarnings("unchecked")
	public List<Member> getMembers(int nPageIndex, int nPageSize, String strKeyword, String strParentUsername,int searchGroupIDs,int searchStatusID, String from)
    {
		List<Member> list= new ArrayList<Member>();
    	try {
	    	Query query = getMembersQuery("m" ,strKeyword, strParentUsername,searchGroupIDs,searchStatusID, from);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			list=query.list();
			for(Member member: list){
				extendMember(member);
			}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return list;
    }
	
	public long getMembersCount(String strKeyword, String strParentUsername,int searchGroupIDs,int searchStatusID, String from)
    {
		long count = 0;
    	try {
    		Query query = this.getMembersQuery(" COUNT(*) ", strKeyword, strParentUsername,searchGroupIDs,searchStatusID, from);
			count=Utility.toSafeLong(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return count;
    }

	private Query getMembersQuery(String strChange, String strKeyword, String strParentUsername,int searchGroupIDs,int searchStatusID, String from) {
		String hql = "";
		// 财务账户中的“客户单价”模块要搜索username,name,cmtPrice
		Integer groupID = CurrentInfo.getCurrentMember().getGroupID();
		if (groupID!=null && (groupID==CDict.GROUPID_CAIWU || groupID==CDict.GROUPID_ZONGGUANLI)){
			hql = "SELECT "+strChange+" FROM Member m WHERE (m.Username LIKE :Keyword OR m.Name LIKE :Keyword ) ";
		} else {
			hql = "SELECT "+strChange+" FROM Member m WHERE (m.Username LIKE :Keyword OR m.Name LIKE :Keyword ) ";
		}
		if(!"".equals(strParentUsername)){
			hql += " AND m.Code LIKE :ParentUsername ";	
		}
		if (searchGroupIDs!=-1) {
			hql+=" AND m.GroupID= :searchGroupIDs";
		}
		if (searchStatusID!=-1) {
			hql+=" AND m.StatusID= :searchStatusID";
		}
		if ("caiwu".equals(from)) {
			hql += " AND m.GroupID NOT IN(:MTM_MANAGEMENTACCOUNT, :RP_MANAGEMENTACCOUNT, :KM_MANAGEMENTACCOUNT, :CW_MANAGEMENTACCOUNT, :ADMIN_MANAGERMENTACCOUNT)";
		}
		hql += " ORDER BY m.RegistDate DESC" ;
		
		Query query = DataAccessObject.openSession().createQuery(hql);
		if(!"".equals(strParentUsername)){
			query.setString("ParentUsername",  strParentUsername + "%" );
		}
		if (searchGroupIDs!=-1) {
			query.setInteger("searchGroupIDs", searchGroupIDs);
		}
		if (searchStatusID!=-1) {
			query.setInteger("searchStatusID", searchStatusID);
		}
		if ("caiwu".equals(from)) {
			query.setInteger("MTM_MANAGEMENTACCOUNT", CDict.MTM_MANAGEMENTACCOUNT.getID());
			query.setInteger("RP_MANAGEMENTACCOUNT", CDict.RP_MANAGEMENTACCOUNT.getID());
			query.setInteger("KM_MANAGEMENTACCOUNT", CDict.KM_MANAGEMENTACCOUNT.getID());
			query.setInteger("CW_MANAGEMENTACCOUNT", CDict.CW_MANAGEMENTACCOUNT.getID());
			query.setInteger("ADMIN_MANAGERMENTACCOUNT", CDict.ADMIN_MANAGERMENTACCOUNT.getID());
		}
		query.setString("Keyword", "%" + strKeyword + "%");
		return query;
	}

	private Member extendMember(Member member) {
		try{
			if(member != null){
				member.setGroupName(DictManager.getDictNameByID(member.getGroupID()));
				member.setStatusName(DictManager.getDictNameByID(member.getStatusID()));
				member.setPayTypeName(DictManager.getDictNameByID(member.getPayTypeID()));
				member.setMoneySignName(DictManager.getDictNameByID(member.getMoneySignID()));
				member.setIsMTOName(DictManager.getDictNameByID(member.getIsMTO()));
				member.setHomePageName(DictManager.getDictNameByID(member.getHomePage()));
				if (member.getExpressComId() != null && !"".equals(member.getExpressComId())) {
					ExpressCom expressCom = new BlExpressComManager().getExpressComById(member.getExpressComId());
					if (expressCom != null && !"".equals(expressCom)) {
						member.setExpressComName(expressCom.getName());
					}
				}
				Member memberParent=getMemberByID(member.getParentID());
				if(memberParent!=null){
					member.setParentName(memberParent.getName());	
				}
				member.setSubs(this.getSubMembersCount(member.getCode()));
				if(StringUtils.isNotEmpty(member.getCmtPrice())){
					
					member.setCmtPriceName(member.getCmtPrice());
				}
				member.setIsUserNoName(DictManager.getDictNameByID(member.getIsUserNo()));
				member.setSemiFinishedName(DictManager.getDictNameByID(member.getSemiFinished()));
				member.setBusinessUnitName(DictManager.getDictNameByID(member.getBusinessUnit()));
				member.setFabricTypeName(member.getFabricType()==1?DictManager.getDictNameByID(10321):DictManager.getDictNameByID(10320));
			}
			
		}
		catch(Exception e){
			LogPrinter.error(e.getMessage());
		}
		return member;
	}

	public String login(String strUsername, String strPassword){
		try {
			
			if (strUsername == null) {
				return "用户名为空";
			}
			if (strPassword == null) {
				return "密码为空";
			}
//			Member member = getMemberByUsername(strUsername);
			Member member = null;
			try{
				String hql = "FROM Member m WHERE m.Username =:Keyword";
				Query query = DataAccessObject.openSession().createQuery(hql);
				query.setString("Keyword", strUsername);
				member=(Member) query.uniqueResult();
				member = this.extendMember(member);
				if (member == null) {
					return ResourceHelper.getValue("Common_UserNotExist");
				}
				if (!member.getPassword().equals(DEncrypt.md5(strPassword))) {
					return ResourceHelper.getValue("Member_PasswordNotMatch");
				}
				return Utility.RESULT_VALUE_OK;
			}catch (Exception e) {
				LogPrinter.error(e.getMessage());
				return ResourceHelper.getValue("Bl_Error_152");
			}finally{
				DataAccessObject.closeSession();
			}
			
		} catch (Exception err) {
			return err.getMessage();
		}
	}

	// 删除
	public void removeMemberByID(String strMemberID) {
		dao.remove(Member.class, strMemberID);
	}
	
	/*
	 * 更新操作
	 */
	public void update(Member ioi) {
		Session session= DataAccessObject.openSessionFactory().openSession();
		Transaction transaction=session.beginTransaction();
		try {
			session.update(ioi);
			transaction.commit();
		} catch (Exception e) {
			e.printStackTrace();
			transaction.rollback();
		}finally{
			session.close();
		}

	}
	
	public String removeMembers(String removeIDs)
    {
		if (removeIDs.equals("")) {
			return "请选择待删除项";
		}
		
    	Transaction transaction=null;
    	Session session=null;
    	try {
	    	session= DataAccessObject.openSession();
	    	transaction=session.beginTransaction();
	    	
	    	String[] arrMemberIDs = Utility.getStrArray(removeIDs);
	    	for (Object memberID : arrMemberIDs) {
	    		if(memberID != null && memberID != "")
	            {
	    			String strMemberId = Utility.toSafeString(memberID);
	                this.removeMemberByID(session, strMemberId);
	                List<Discount> discounts = new BlDiscountManager().getDiscountsByMemberID(strMemberId);
	                for (Discount d:discounts){
	                	new BlDiscountManager().removeDiscountByID(session, d.getID());
	                }
	            }
	    	}
	    	
	    	transaction.commit();
	    	return Utility.RESULT_VALUE_OK;
    	} catch (Exception e) {
	    	transaction.rollback();
			LogPrinter.error(e.getMessage());
			return e.getMessage();
		}finally{
			DataAccessObject.closeSession();
		}
    }
	
	private void removeMemberByID(Session session ,String strMemberID) {
		dao.remove(session, Member.class, strMemberID);
	}
	
	/**
	 * 根据发货周期（周）得到用户列表
	 * @param deliveryWeekDay 发货周期
	 * @return 查询到的用户列表
	 */
	@SuppressWarnings("unchecked")
	public List<Member> getMemberListByApplyDeliveryDay(int deliveryWeekDay) {
		List<Member> list = new ArrayList<Member>();
		String hql = "FROM Member m WHERE ApplyDeliveryTypeID = :ApplyDeliveryTypeID AND ApplyDeliveryDays LIKE :ApplyDeliveryDays ";
		
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setInteger("ApplyDeliveryTypeID", CDict.AutoDeliveryType.getID());
			query.setString("ApplyDeliveryDays","%"+deliveryWeekDay+"%");
			list = query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}
	
	/**
	 * 根据角色编号查找用户
	 * @param groupId 角色ID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Member> getMemberListByGroupId(int groupId) {
		List<Member> list = new ArrayList<Member>();
		String hql = "FROM Member m WHERE m.GroupID=:GroupID";
		
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setInteger("GroupID", groupId);
			list = query.list();
		} catch(Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}
	
	//单耗列表
	public List<Fabricconsume> GetFabricConsume(int nPageIndex, int pageSize, String strMemberName){
		List<Fabricconsume> list=new ArrayList<Fabricconsume>();
		StringBuffer hql=new StringBuffer();
		hql.append(" FROM Fabricconsume fc where fc.username=:strMemberName");
		try {
			Query query = DataAccessObject.openSession().createQuery(hql.toString());
			query.setString("strMemberName", strMemberName);
			list = query.list();
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}
	//单耗分页
	public long getDictPriceCount(String strMemberName){
		long count=0;
		StringBuffer hql=new StringBuffer();
		hql.append("SELECT COUNT(*)  FROM Fabricconsume up where up.username=:strMemberName");
		try {
			Query query = DataAccessObject.openSession().createQuery(hql.toString());
			query.setString("strMemberName", strMemberName);
			count=Utility.toSafeLong(query.uniqueResult());
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}
	//单耗删除
	public void removeFabricconsume(String removeID)
    {
		dao.remove(Fabricconsume.class, removeID);
    	/*Transaction transaction=null;
    	Session session=null;
    	try {
	    	session= DataAccessObject.openSession();
	    	transaction=session.beginTransaction();
	    	dao.remove(session, Fabricconsume.class, removeID);
	    	transaction.commit();
	    	return Utility.RESULT_VALUE_OK;
    	} catch (Exception e) {
	    	transaction.rollback();
			LogPrinter.error(e.getMessage());
			return e.getMessage();
		}finally{
			DataAccessObject.closeSession();
		}*/
    }
	
	// 添加单耗
	public void saveFabricconsume(Fabricconsume fabricconsume) {
		dao.saveOrUpdate(fabricconsume);
	}
	//根据善融id和企业代码(1002)查找用户
	public Member getBindingMember(String srUserID,int nCompanyID)
    {
		List<Member> list= new ArrayList<Member>();
		Member member = null;
    	try {
	    	String hql = "FROM Member m WHERE m.srUserID = ? and m.companyID = ?" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, srUserID);
			query.setInteger(1, nCompanyID);
			list=query.list();
			if(list.size()>0){
				member = list.get(0);
			}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return member;
    }
}