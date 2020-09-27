package hongling.business;


import hongling.entity.KitStyle;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
@SuppressWarnings("unchecked")
public class KitStyleManager {
	
	DataAccessObject dao = new DataAccessObject();
	public List<KitStyle> getKitStyles(int pageNo, int pageSize,String keyword,String code,int clothingId,String category,Date fromDate, Date toDate,String strStyleID) {
		List<KitStyle> kitStyles = new ArrayList<KitStyle>();
		try {
			Query query = getKitStylesQuery("k",keyword, code, clothingId, category,fromDate,toDate,strStyleID);
			query.setFirstResult(pageNo * pageSize);
			query.setMaxResults(pageSize);
			kitStyles = (List<KitStyle>) query.list();
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return kitStyles;
	}
	
	private Query getKitStylesQuery(String strChange,String keyword,String code,int clothingId,String category,Date fromDate, Date toDate,String strStyleID) {
			Query query=null;
		if(clothingId==0){
			String hql = "SELECT "+ strChange+ " FROM KitStyle k WHERE k.status =1 and k.code LIKE :code and k.categoryID like :category";
			if (!"-1".equals(strStyleID)) {
				hql += " AND k.styleID =:styleID";
			} 
			if (fromDate != null && !"".equals(fromDate)) {
				hql += " AND TO_CHAR(k.createTime,'yyyy-MM-dd')>= TO_CHAR(:FromDate,'yyyy-MM-dd')";
			} 
			if (toDate != null && !"".equals(toDate)) {
				hql += " AND TO_CHAR(k.createTime,'yyyy-MM-dd')<=TO_CHAR(:ToDate,'yyyy-MM-dd')";
			}
			if(keyword!=null&&!"".equals(keyword)){
				hql+="AND (k.title_Cn LIKE upper(:Keyword) OR upper(k.title_En) LIKE upper(:Keyword) OR upper(k.categoryID) LIKE upper(:Keyword) OR k.defaultFabric LIKE :Keyword OR k.fabrics LIKE :Keyword ) ";
				
			}
			query = DataAccessObject.openSession().createQuery(hql);
			query.setString("code", "%" + code + "%");
			query.setString("category","%" + category + "%");
			if(keyword!=null&&!"".equals(keyword)){
				query.setString("Keyword", "%" + keyword + "%");	
			}
			if (!"-1".equals(strStyleID)) {
				query.setInteger("styleID", Utility.toSafeInt(strStyleID));
			} 
			if (fromDate !=null && !"".equals(fromDate)) {
				query.setDate("FromDate", fromDate);
			}
			if (toDate != null && !"".equals(toDate)) {
				query.setDate("ToDate", toDate);
			}
		}
		else
		{
			String hql = "SELECT "+ strChange+ " FROM KitStyle k WHERE k.status =1 and k.clothingID=:clothingId and k.code LIKE :code and k.categoryID like :category";
			query = DataAccessObject.openSession().createQuery(hql);
			query.setString("code", "%" + code + "%");
			query.setInteger("clothingId", clothingId);
			query.setString("category","%" + category + "%");
		}
		return query;
	}
	public long getKitStylesCount(String keyword,String code,int clothingId,String category,Date fromDate, Date toDate,String strStyleID) {
		long count = 0;
			Query query = getKitStylesQuery("COUNT(*)",keyword, code, clothingId, category,fromDate,toDate,strStyleID);
			count = Utility.toSafeLong(query.uniqueResult());
		return count;
	}
	public String removeKitStyles(String removeIDs,String name,Date nTime) {
		if (removeIDs.equals("")) {
			return "请选择待删除项";
		}
		String hql="update KitStyle k set k.status=0,k.closeBy=:name,k.closeTime=:time where k.ID=:Id";
		Transaction transaction = null;
		Session session = null;
		Query query=null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();

			String[] arrKitStyleIDs = Utility.getStrArray(removeIDs);
			for (String kitStyleID : arrKitStyleIDs) {
				if (kitStyleID != null && kitStyleID != "") {
					query=session.createQuery(hql);
//					query.setString("Id", kitStyleID);
					query.setInteger("Id", Utility.toSafeInt(kitStyleID));
					query.setString("name", name);
					query.setDate("time", nTime);
					query.executeUpdate();
				}
			}

			transaction.commit();
			return Utility.RESULT_VALUE_OK;
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
			return e.getMessage();
		} finally {
			DataAccessObject.closeSession();
		}
	}
	private void removeKitStyleByID(Session session, String strKitStyleID) {
		dao.remove(session, KitStyle.class, Utility.toSafeInt(strKitStyleID));
	}
	public KitStyle getKitStyleByID(String strKitStyleID) {
		KitStyle kitStyle = null;
		if(StringUtils.isNotEmpty(strKitStyleID)){
			kitStyle = getKitStyleEntityByID(strKitStyleID);
		}
		
		return kitStyle;
	}
	public KitStyle getKitStyleEntityByID(String strKitStyleID) {
		KitStyle kitStyle = (KitStyle) dao.getEntityByID(KitStyle.class, Utility.toSafeInt(strKitStyleID));
		return kitStyle;
	}
	public void saveKitStyle(KitStyle kitStyle){
		if(kitStyle != null){
			dao.saveOrUpdate(kitStyle);
		}
	}
	
	
	
}
