package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Mix;

public class MixManager {
	DataAccessObject dao = new DataAccessObject();

	// 构造
	public MixManager() {
	}
	
	/**
	 * 根据mixcode 查询信息
	 */
	@SuppressWarnings("unchecked")
	public List<Mix> getMixByCode(String mixcode)
    {
		List<Mix> list= new ArrayList<Mix>();
    	try {
	    	String hql = "FROM Mix WHERE  CODE=:CODE" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("CODE", Utility.toSafeString(mixcode));
			list=query.list();
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return list;
    }
	
	/**
	 * 得到mixcodes
	 */
	@SuppressWarnings("unchecked")
	public String getAllMixcodes()
    {
		StringBuffer str= new StringBuffer();
		List<String> list = new ArrayList<String>();
    	try {
	    	String hql = "SELECT m.CODE FROM Mix m" ;
			Query query = DataAccessObject.openSession().createSQLQuery(hql);
			list=query.list();
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	for(String val :list)
    	{
    		str.append(val+",");
    	}
    	return str.toString();
    }

}