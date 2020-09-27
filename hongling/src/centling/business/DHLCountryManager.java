package centling.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;

import centling.entity.DHLCountry;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;

public class DHLCountryManager {
	DataAccessObject dao = new DataAccessObject();
	
	public DHLCountry getDHLCountryByCountryCode(String countryCode){
		return (DHLCountry)dao.getEntityByDual(DHLCountry.class, "CountryCode", countryCode);
	}
	
	/**
	 * 查询所有国家
	 * @param strKeyword 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DHLCountry> getDHLCountries(String strKeyword) {
		List<DHLCountry> list = new ArrayList<DHLCountry>();
		String hql = "From DHLCountry d WHERE (upper(d.en) like ? OR upper(d.CountryCode) like ?)";
		
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
