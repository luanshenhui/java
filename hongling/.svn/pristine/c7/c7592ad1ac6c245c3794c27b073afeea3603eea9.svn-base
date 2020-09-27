package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Receiving;

public class ReceivingManager {
	DataAccessObject dao = new DataAccessObject();
	public void saveReceiving(Receiving receiving){
		Transaction transaction=null;
		Session session=null;
		try {
			session=DataAccessObject.openSessionFactory().openSession();
			transaction=session.beginTransaction();
			dao.save(session, receiving);
			transaction.commit();
		} catch (Exception e) {
			// TODO: handle exception
			transaction.rollback();
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		}finally {
			DataAccessObject.closeSession();
		}
	}
	public String removeReceivings(String removeIDs){
		Transaction transaction=null;
		Session session=null;
		try {
			session=DataAccessObject.openSessionFactory().openSession();
			transaction=session.beginTransaction();
			String[] arrReceivings=Utility.getStrArray(removeIDs);
			for (String id : arrReceivings) {
				if (id!=null&&id!="") {
					this.removeReceivingByID(session, Utility.toSafeInt(id));
				}
			}
			transaction.commit();
			return Utility.RESULT_VALUE_OK;
		} catch (Exception e) {
			// TODO: handle exception
			transaction.rollback();
			LogPrinter.error(e.getMessage());
			return e.getMessage();
		}finally {
			DataAccessObject.closeSession();
		}
	}
	public void removeReceivingByID(Session session,int nId){
		dao.remove(Receiving.class, nId);
	}
	@SuppressWarnings("unchecked")
	public List<Receiving> getReceivings(int nPageIndex, int nPageSize,
			String strMemberCode,String strOwnedStore, int nClothingID, String fromDate, String toDate) {
		List<Receiving> receivings = new ArrayList<Receiving>();
		try {
			Query query = this.getReceivingQuery("r",strMemberCode,strOwnedStore,nClothingID,fromDate,toDate);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			receivings=(List<Receiving>)query.list();
			int i=0;
			for (Receiving receiving : receivings) {
				receiving.setNumber(++i);
				receiving.setSortName(DictManager.getDictNameByID(receiving.getSort()));
			}
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return receivings;
	}
	public long getReceivingsCount(String strMemberCode,String strOwnedStore,int nClothingID, String fromDate, String toDate) {
		long count = 0;
		try {
			Query query = this.getReceivingQuery("COUNT(*)", strMemberCode,strOwnedStore,nClothingID,  fromDate,toDate);
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}

	private Query getReceivingQuery(String strChange,String strMemberCode,String strOwnedStore, int nClothingID,
			String fromDate, String toDate) {
//		String hql = "SELECT "+strChange+" FROM Receiving r WHERE r.ownedstore like :MemberCode ";
//		String hql = "SELECT "+strChange+" FROM Receiving r left join Orden t on t.OrdenID = r.ordenid left join Member m on m.ID = t.PubMemberID WHERE r.ownedstore like :OwnedStore and m.Code like :MemberCode ";//hql 必须建立表关系 才能使用 left join on 
		String hql = "SELECT "+strChange+" FROM Receiving r,Orden t,Member m "+
					" WHERE t.OrdenID = r.ordenid and m.ID = t.PubMemberID " +
					" and m.Code like :MemberCode and r.ownedstore like :OwnedStore ";
		
		if (nClothingID != -1) {
			hql += " AND r.sort = :ClothingID ";
		}
		if (fromDate != null && !"".equals(fromDate)) {
			hql += " AND r.createtime>= :FromDate";
		}
		if (toDate != null && !"".equals(toDate)) {
			hql += " AND r.createtime<= :ToDate";
		}
		hql += " ORDER BY r.ordenid  ";
		Query query = DataAccessObject.openSession().createQuery(hql);
//		query.setString("MemberCode", "%"+strMemberCode + "%");
		query.setString("OwnedStore", "%"+strOwnedStore + "%");//门店
		query.setString("MemberCode", strMemberCode + "%");//当前用户code

		if (fromDate != null && !"".equals(fromDate)) {
			query.setString("FromDate", fromDate);
		}
		if (toDate != null && !"".equals(toDate)) {
			query.setString("ToDate", toDate+" 23:59:59");
		}
		if (nClothingID != -1) {
			query.setInteger("ClothingID", nClothingID);
		}
		return query;
	}
}
