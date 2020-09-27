package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.RealmName;

public class RealmNameManager{

	DataAccessObject dao = new DataAccessObject();
	
	@SuppressWarnings("unchecked")
	public RealmName getRealmName(String strHref){
		List<RealmName> realms = new ArrayList<RealmName>();
		try {
			String hql = "SELECT rn FROM RealmName rn order by ID";
			Query query = DataAccessObject.openSession().createQuery(hql);
			realms = (List<RealmName>) query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		for(RealmName realm :realms){
			if(strHref.indexOf(realm.getRealmName())>-1){
				return realm;
			}
		}
		return null;
		
	}
	
	@SuppressWarnings("unchecked")
	public List<RealmName> getRealmNames(int nPageIndex, int nPageSize, String strKeyword)
    {
		List<RealmName> realmnames= new ArrayList<RealmName>();
    	try {
	    	String hql = "FROM RealmName r WHERE r.CustomerName LIKE ?  ORDER BY ID DESC" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, "%" + strKeyword + "%");

			int nFirstResult = Utility.toSafeInt(nPageIndex * nPageSize);
			query.setFirstResult(nFirstResult);
			query.setMaxResults(nPageSize);
			realmnames=query.list();
			
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return realmnames;
    }
	
	public long getRealmNamesCount(String strKeyword)
    {
		long count = 0;
    	try {
    		String hql = "SELECT COUNT(*) FROM RealmName r WHERE r.CustomerName LIKE ? " ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, "%" + strKeyword + "%");
			count=Utility.toSafeLong(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return count;
    }
	
	public String removeRealmNames(String removeIDs)
    {
		if (removeIDs.equals("")) {
			return "请选择待删除项";
		}
		
    	Transaction transaction=null;
    	Session session=null;
    	try {
	    	session= DataAccessObject.openSession();
	    	transaction=session.beginTransaction();
	    	
	    	String[] arrRealmNameIDs = Utility.getStrArray(removeIDs);
	    	LogPrinter.debug("length_arr" + arrRealmNameIDs.length);
	    	for (Object realmNameID : arrRealmNameIDs) {
	    		if(realmNameID != null && realmNameID != "")
	            {
	                this.removeRealmNameByID(session, Utility.toSafeString(realmNameID));
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
	
	private void removeRealmNameByID(Session session ,String strRealmNameID) {
		dao.remove(session, RealmName.class, strRealmNameID);
	}
	
	public RealmName getRealmNameByID(String strID) {
		RealmName realmName = (RealmName) dao.getEntityByID(RealmName.class, strID);
		return realmName;
	}
	
	public void saveRealmName(RealmName realmName) {
		dao.saveOrUpdate(realmName);
	}
	
}