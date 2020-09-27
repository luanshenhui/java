package rcmtm.business;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Query;

import rcmtm.entity.Geo;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

/**
* <p>Title: Geo_CN.java</p>
* <p>Description: </p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: RCOLLAR</p>
* @author <a href="mailto:fanjinhu@gmail.com">fjh</a>
* @date 2014-1-11
* @version 1.0
 */
public class Geo_CN extends BaseServlet {

	private static final long	serialVersionUID	= 1L;

	public void service(HttpServletRequest request,HttpServletResponse response) {
		List<Geo> ret = null;
		
		String query4 = Utility.toSafeString(request.getParameter("para"));
		String parentid = Utility.toSafeString(request.getParameter("value"));
		String keyword = Utility.toUtf8(request.getParameter("q"));
		
		if ("province".equals(query4)) {
			ret = getProvinces();
		} else if ("city".equals(query4)) {
			ret = getCites(Integer.parseInt(parentid));
		} else if ("district".equals(query4)) {
			ret = getDistrict(Integer.parseInt(parentid));
		} else if ("shortening".equals(query4)) {
			ret = shortening(keyword, parentid);
		}
		output(ret);
	}
	
	public List<Geo> getProvinces() {
		List<Geo> provinces = findByLevel(0);
		return provinces;
	}
	
	public List<Geo> getCites(int provinceCode) {
		List<Geo> cities = findByLevel(provinceCode);
		return cities;
	}

	public List<Geo> getDistrict(int cityCode) {
		List<Geo> districts = findByLevel(cityCode);
		return districts;
	}
	
	public List<Geo> shortening(String shortening, String parentid) {
		if (shortening.equals("+")) {
			return findByLevel(Integer.parseInt(parentid));
		} else {
			return findByShortening(Integer.parseInt(parentid), shortening);
		}
	}
	
	/* ----------------------------------
	 * 
	 * 		DAO
	 * 
	 * ----------------------------------
	 */
	private String findByLevel = "from Geo where parentid=?";
	
	@SuppressWarnings("unchecked")
	public List<Geo> findByLevel(int parentid) {
		List<Geo> obs = null;
		Query query = DataAccessObject.openSession().createQuery(findByLevel);
		query.setInteger(0, parentid);
		obs = (List<Geo>)query.list();
		return obs;
	}
	
	private String findByShortening = "from Geo where parentid=? and shortening like ?";
	
	@SuppressWarnings("unchecked")
	public List<Geo> findByShortening(int parentid, String shortening) {
		List<Geo> obs = null;
		Query query = DataAccessObject.openSession().createQuery(findByShortening);
		query.setInteger(0, parentid);
		query.setString(1, shortening + "%");
		obs = (List<Geo>)query.list();
		return obs;
	}
}
