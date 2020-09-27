package chinsoft.service.realmname;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.RealmNameManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.RealmName;
import chinsoft.service.core.BaseServlet;

public class GetRealmNameByID extends BaseServlet {

	private static final long serialVersionUID = 8254527345115894391L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strRealmNameID = getParameter("id");
			RealmName realmName = new RealmNameManager().getRealmNameByID(strRealmNameID);
			output(realmName);
		} catch (Exception e) {
			LogPrinter.debug("GetRealmNameByID_err" + e.getMessage());
		}
	}
}
