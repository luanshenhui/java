package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.entity.EcodeRedirect;

public class EcodeRedirectManager {

	DataAccessObject dao = new DataAccessObject();
	private static List<EcodeRedirect> redirects = null;

	@SuppressWarnings({ "static-access", "unchecked" })
	public List<EcodeRedirect> getEcodeRedirects() {
		try {
			if (redirects == null) {
				Query query = dao.openSession().createQuery(
						" FROM EcodeRedirect ecode order by ecode.Count desc ");
				redirects = query.list();
			}

		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			dao.closeSession();
		}
		return redirects;
	}

	/**
	 * 根据 代码拆分的ecode查找返回 dict 的ecodes,ecode,ecode.....
	 * 
	 * @param ecode
	 * @return
	 */
	public String findCodesBySplitEcode(String ecode) {
		List<EcodeRedirect> ecodeRedirects = new ArrayList<EcodeRedirect>();
		String hqlString = "FROM EcodeRedirect e where e.Ecode = '" + ecode
				+ "'";
		try {
			ecodeRedirects = dao.openSession().createQuery(hqlString).list();
		} catch (HibernateException e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			dao.closeSession();
		}
		if (null != ecodeRedirects && !ecodeRedirects.isEmpty()) {
			return ecodeRedirects.get(0).getSplits();
		} else {
			return null;
		}
	}
	public List<String> findAllDitinctEcode() {
		List<String> ecodeRedirectList = new ArrayList<String>();
		String hqlString = "select distinct e.Ecode FROM EcodeRedirect e";
		try {
			ecodeRedirectList = dao.openSession().createQuery(hqlString).list();
		} catch (HibernateException e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			dao.closeSession();
		}
		return ecodeRedirectList;
	}
}