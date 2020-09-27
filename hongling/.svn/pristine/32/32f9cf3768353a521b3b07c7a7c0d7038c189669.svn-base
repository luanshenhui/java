package chinsoft.service.realmname;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.RealmNameManager;
import chinsoft.entity.RealmName;
import chinsoft.service.core.BaseServlet;

public class GetRealmName extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		RealmName realmName=null;
		try {
//			super.service();
			//获取全部域名
			String strHref = getParameter("realm");
			realmName= new RealmNameManager().getRealmName(strHref);
			
		} catch (Exception e) {
			//LogPrinter.debug("getmembers_err" + e.getMessage());
		}
		output(realmName);
	}
}
