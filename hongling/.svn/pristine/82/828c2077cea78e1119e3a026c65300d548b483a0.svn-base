package work.business;

import org.hibernate.HibernateException;
import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;

public class OrdenManager {
	//根据订单号查询订单状态
	public String getStatusByID(String strOrdenID){
		String strHQL="SELECT StatusID FROM Orden WHERE OrdenID=:ordenID";
		Query query=DataAccessObject.openSession().createQuery(strHQL);
		query.setString("ordenID", strOrdenID);
		String status;
		try {
			status = Utility.toSafeString(query.uniqueResult());
		} catch (HibernateException e) {
			// TODO Auto-generated catch block
			return "ERROR";
		}
		return status;
	}
	
}
