package chinsoft.business;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import centling.dto.CashDto;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Cash;
import chinsoft.entity.Member;

public class CashManager {

	DataAccessObject dao = new DataAccessObject();

	// 构造
	public CashManager() {
	}

	// 添加&修改现金
	public void saveCash(Cash cash) {
		dao.saveOrUpdate(cash);
	}

	// 根据ID查询
	public Cash getCashByID(String strCashID) {
		Cash cash=(Cash)dao.getEntityByID(Cash.class, strCashID);
		Member member = new MemberManager().getMemberByID(cash.getPubMemberID());
		if(member != null){
			cash.setMember(member);
		}
		return cash;
	}

	@SuppressWarnings("unchecked")
	public List<CashDto> getCashs(int nPageIndex, int nPageSize,String strKeyword,Date fromDate, Date toDate)
    {
		List<CashDto> list= new ArrayList<CashDto>();
    	try {
	    	String strChange = "c.ID as cID," +
	    			"m1.ID as mID," +
	    			"m1.CompanyName," +
	    			"m1.CompanyShortName," +
	    			"m2.Name as member_parentName," +
	    			"c.Num as cash_num," +
	    			"d1.Name as member_moneySignName," +
	    			"c.Memo," +
	    			"d2.Name as isReconciliationName," +
	    			"to_char(c.PubDate,'yyyy-mm-dd') as cash_pubDate," + 
	    			"m1.Name as member_name, m1.userName";
			Query query = getCashsQuery(strChange, strKeyword, fromDate, toDate);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			List<Object[]> listO = query.list();
			for (Object[] o:listO){
				CashDto dto = new CashDto(
						o[0].toString().trim(),
						o[1]==null?"":o[1].toString().trim(),
						o[2]==null?"":o[2].toString().trim(),
						o[3]==null?"":o[3].toString().trim(),
						o[4]==null?"":o[4].toString().trim(),
						o[5]==null?"":o[5].toString().trim(),
						o[6]==null?"":o[6].toString().trim(),
						o[7]==null?"":o[7].toString().trim(),
						o[8]==null?"":o[8].toString().trim(),
						o[9]==null?"":o[9].toString().trim(),
						o[10]==null?"":o[10].toString().trim(),
						o[11]==null?"":o[11].toString().trim());
				list.add(dto);
			}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}

    	return list;
    }

    public List<Cash> extendCashs(List<Cash> list) {
		for(Cash cash: list){
			try{
				cash.setIsReconciliationName(DictManager.getDictNameByID(cash.getIsReconciliation()));
				Member member = new MemberManager().getMemberByID(cash.getPubMemberID());
				if(member != null){
					cash.setMember(member);
				}
			}
			catch(Exception e){
				LogPrinter.debug(e.getMessage());
			}
		}
		return list;
	}


	public long getCashsCount(String strKeyword,Date fromDate, Date toDate)
    {
		long count = 0;
    	try {
    		String strChange = "COUNT(c.ID)";
    		Query query = getCashsQuery(strChange, strKeyword, fromDate, toDate);
			count=Utility.toSafeLong(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return count;
    }
	
	private Query getCashsQuery(String strChange, String strKeyword,Date fromDate, Date toDate) {
		StringBuffer sb = new StringBuffer();
		sb.append("select " + strChange + " ");
		sb.append("FROM Cash c left join Member m1 ");
		sb.append("            on c.PubMemberID=m1.ID ");
		sb.append("            left join Member m2 ");
		sb.append("            on m1.ParentID=m2.ID ");
		sb.append("            left join Dict d1 ");
		sb.append("            on m1.MoneySignID=d1.ID ");
		sb.append("            left join Dict d2 ");
		sb.append("            on c.IsReconciliation=d2.ID ");
		sb.append("where 1=1 ");
		if (strKeyword!=null && !"".equals(strKeyword.trim())){
			sb.append("  AND (upper(m1.CompanyName) LIKE upper(:Keyword) ");           // 客户公司名
			sb.append("       OR upper(m1.Username) LIKE upper(:Keyword) ");   // 用户名称
			sb.append("       OR upper(m1.Name) LIKE upper(:Keyword) ");       // 客户姓名
			sb.append("       OR upper(m2.Name) LIKE upper(:Keyword) ");               // 业务员名称
			sb.append("       OR upper(c.Num) LIKE upper(:Keyword) ");                 // 剩余金额
			sb.append("       OR upper(c.Memo) LIKE upper(:Keyword) ");                // 备注
			sb.append("       OR upper(d2.Name) LIKE upper(:Keyword)) ");               // 是否对账
		}
		if (fromDate!=null && !"".equals(fromDate)) {
			sb.append(" AND to_char(c.PubDate,'yyyy-MM-dd') >= to_char(:FromDate,'yyyy-MM-dd')");
		}
		if (toDate!=null&&!"".equals(toDate)) {
			sb.append(" AND to_char(c.PubDate,'yyyy-MM-dd')<=to_char(:ToDate,'yyyy-MM-dd') ");
		}
		sb.append("ORDER BY c.PubDate DESC ");
		Query query = DataAccessObject.openSession().createSQLQuery(sb.toString());
		if (strKeyword!=null && !"".equals(strKeyword.trim())){
			query.setString("Keyword", "%" + strKeyword + "%");
		}
		if (fromDate!=null && !"".equals(fromDate)) {
			query.setDate("FromDate", fromDate);
		}
		if (toDate!=null && !"".equals(toDate)) {
			query.setDate("ToDate", toDate);
		}
		return query;
	}
	
	@SuppressWarnings("rawtypes")
	public double getTotal(String strPubMemberID)
    {
		double total = 0;
    	try {
    		String hql = "SELECT SUM(c.Num) FROM Cash c WHERE c.PubMemberID = ?" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, strPubMemberID);
			List list = query.list(); 
	        total = Utility.toSafeDouble(list.get(0)); 
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return total;
    }

	// 删除
	public void removeCashByID(String strCashID) {
		dao.remove(Cash.class, strCashID);
	}
	
	public String removeCashs(String removeIDs)
    {
		if (removeIDs.equals("")) {
			return "请选择待删除项";
		}
		
    	Transaction transaction=null;
    	Session session=null;
    	try {
	    	session= DataAccessObject.openSession();
	    	transaction=session.beginTransaction();
	    	
	    	String[] arrCashIDs = Utility.getStrArray(removeIDs);
	    	for (Object cashID : arrCashIDs) {
	    		if(cashID != null && cashID != "")
	            {
	                this.removeCashByID(session, Utility.toSafeString(cashID));
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
	
	// 根据MemberID查询
	@SuppressWarnings("unchecked")
	public Cash getCashByMemberID(String strMemberID) {
		Cash cash = null;
    	try {
    		String hql = "FROM Cash c WHERE c.PubMemberID = ?" ;
    		Query query = DataAccessObject.openSession().createQuery(hql);
    		query.setString(0, strMemberID);
    		List<Cash>   list   =query.list(); 
    		if (list!=null && list.size()==1){
    			cash = list.get(0);
    		}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return cash;
	}
	
	private void removeCashByID(Session session ,String strCashID) {
		dao.remove(session, Cash.class, strCashID);
	}
}