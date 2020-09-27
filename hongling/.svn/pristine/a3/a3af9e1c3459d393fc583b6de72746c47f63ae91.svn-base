package centling.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;

import centling.entity.DHLCity;
import centling.entity.DHLDict;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;

public class DHLCityManager {

	/**
	 * 获取城市
	 * @param strKeyword
	 * @param code
	 * @param type
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DHLCity> getDHLCitys(String strKeyword, String code, String type) {
		List<DHLCity> list = new ArrayList<DHLCity>();
		
		String hql = "From DHLCity d WHERE (upper(d.City) like ?) ";
		
		// 其他国家
		if ("1".equals(type)) {
			hql += " AND d.CountryCode=?";
		// 美国
		} else {
			hql += " AND d.StateCode=?";
		}
		
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, Utility.toSafeString(strKeyword).toUpperCase() + "%");
			query.setString(1, code);
			list = query.list();
		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}

	/**
	 * 获取邮政编码
	 * @param strKeyword
	 * @param countryCode
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<String> getDHLPostalCodes(String countryCode, String city) {
		List<String> list = new ArrayList<String>();
		
		String hql = "From DHLDict d WHERE d.CountryCode=:CountryCode AND d.City=:City";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("CountryCode", countryCode);
			query.setString("City", city);
			List<DHLDict> dictList = query.list();
			for (DHLDict dhlDict: dictList) {
//				int codeB = Utility.toSafeInt(dhlDict.getCodeB());
//				int codeC = Utility.toSafeInt(dhlDict.getCodeC());
//				while (codeB<=codeC) {
//					list.add(Utility.toSafeString(codeB++));
//				}
				list.add(dhlDict.getCodeB()+"--"+dhlDict.getCodeC());
			}
		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			DataAccessObject.closeSession();
		}
		if (list.size()==0) {
			list.add("--");
		}
		return list;
	}
}