package centling.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;

import centling.entity.DHLState;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;

public class DHLStateManager {
	
	/**
	 * 获取所有的州
	 * @param strKeyword
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DHLState> getDHLStates(String strKeyword) {
		List<DHLState> list = new ArrayList<DHLState>();
		String hql = "From DHLState d WHERE (upper(d.StateName) like ? or upper(d.StateCode) like ?)";
		
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, Utility.toSafeString(strKeyword).toUpperCase() + "%");
			query.setString(1, Utility.toSafeString(strKeyword).toUpperCase() + "%");
			list = query.list();
		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}
	
}