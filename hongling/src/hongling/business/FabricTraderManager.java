package hongling.business;

import hongling.entity.FabricTrader;
import hongling.util.DateUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;

public class FabricTraderManager {
	private DataAccessObject dao = new DataAccessObject();
	
	public List<FabricTrader> getFabricTraderList(int pageNo,int pageSize,String keyword){
		List<FabricTrader> fabricTraders=new ArrayList<FabricTrader>();
		Query query=getFabricTraderQuery("f",keyword);
		query.setFirstResult(pageNo*pageSize);
		query.setMaxResults(pageSize);
		fabricTraders=(List<FabricTrader>)query.list();
		return fabricTraders;
		
	}
	public int getFabricTraderCount(String keyword){
		int count=0;
		Query query=getFabricTraderQuery("COUNT(*)",keyword);
		count=Utility.toSafeInt(query.uniqueResult());
		return count;
	}
	public Query getFabricTraderQuery(String strChange,String keyword){
		Query query=null;
		
		String hql="SELECT "+strChange+" FROM FabricTrader f Where (1=1)";
		if(keyword!=null&&!"".equals(keyword)){
			hql+=" AND (f.traderName LIKE :Keyword  OR f.recommendation LIKE :Keyword OR f.address LIKE :Keyword ) ";
		}
		query=DataAccessObject.openSession().createQuery(hql);
		if(keyword!=null&&!"".equals(keyword)){
			query.setString("Keyword", "%"+keyword+"%");
		}
		return query;
	}
	public String removeFabricTader(String ids){
		if (ids.equals("")) {
			return "请选择待删除项";
		}
		Transaction transaction=null;
    	Session session=null;
    	
    	try {
			session= DataAccessObject.openSession();
			transaction=session.beginTransaction();
			String[] IDs = Utility.getStrArray(ids);
			for(Object ID : IDs){
				if(ID!=null&&ID!=""){
					new DataAccessObject().remove(session,FabricTrader.class, Utility.toSafeInt(ID));
				}
			}
			transaction.commit();
	    	return Utility.RESULT_VALUE_OK;
		} catch (HibernateException e) {
			e.printStackTrace();
			return e.getMessage();
		}
    	finally{
    		DataAccessObject.closeSession();
    	}
	}
	public void saveFabricTrader(FabricTrader fabricTrader){
		new DataAccessObject().saveOrUpdate(fabricTrader);
	}
	public FabricTrader getFabricTraderByID(String id){
		return (FabricTrader)new DataAccessObject().getEntityByID(FabricTrader.class, Utility.toSafeInt(id));
	}
	/**
	 * 获取面料信息报表
	 * @param username
	 * @param pageIndex
	 * @param pageSize
	 * @param date 
	 */
	
	public List getFabricReport(String code, int pageIndex, int pageSize, Date date, String fpareaId) {
		if (date == null) {
			date = new Date();
		}
		String time = DateUtils.formatDate(date, "yyyy-MM-dd");
		String daytime = time;
		String monthtime = time.substring(0, 7);
		String yeartime = time.substring(0, 4);
		String strSQL = "";
		strSQL += "SELECT f.ID,f.CODE,ft.TRADERNAME,fp.RMBPRICE,fp.DOLLARPRICE,  " + "(SELECT t.NAME FROM DICT t WHERE ID=(F.COLORID)), " + "(SELECT t.NAME FROM DICT t WHERE ID=(F.COMPOSITIONID)), "
				+ "SUM(CASE WHEN to_char(O.PUBDATE,'yyyy-MM-dd hh24:mi:ss') LIKE '" + monthtime + "%' THEN FC.FABRICSIZE ELSE 0 END),"
				+ "SUM(CASE WHEN to_char(O.PUBDATE,'yyyy-MM-dd hh24:mi:ss') LIKE '" + yeartime + "%' THEN FC.FABRICSIZE ELSE 0 END) "
				+ "FROM FABRIC f JOIN ORDEN o ON f.ID=o.FABRICID JOIN  MEMBER m ON m.ID=o.PUBMEMBERID JOIN DICT d ON o.CLOTHINGID=d.ID "
				+ "JOIN FABRICCONSUME fc ON fc.USERNAME=m.USERNAME AND fc.SORT=d.ECODE JOIN FABRICWAREROOM fw ON f.CODE=fw.FABRICNO "
				+ "JOIN FABRICTRADER ft ON fw.BRANDS=ft.ID JOIN FABRICPRICE fp ON fp.FABRICCODE=f.CODE AND fp.AREAID='" + fpareaId + "'";

		if (StringUtils.isNotBlank(code)) {
			strSQL += "AND f.CODE like '" + code + "%'";
		}
		strSQL += " GROUP BY  f.ID,f.CODE,f.COMPOSITIONID,f.COLORID,ft.TRADERNAME,fp.RMBPRICE,fp.DOLLARPRICE";
		SQLQuery sql = dao.openSession().createSQLQuery(strSQL);
		if (pageSize != 0) {
			sql.setFirstResult(pageIndex * pageSize);
			sql.setMaxResults(pageSize);
		}
		List list = sql.list();
		return list;
	}
	
}
