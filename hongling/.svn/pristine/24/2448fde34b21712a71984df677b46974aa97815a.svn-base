package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetEmbroids extends BaseServlet {
	private static final long serialVersionUID = 6177371136167941106L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			String strID = Utility.toUtf8(getParameter("categoryid"));
			output(new ClothingManager().GetEmbroids(Utility.toSafeInt(strID)));
		} catch (Exception e) {
			LogPrinter.debug("GetEmbroids_err" + e.getMessage());
		}
	}
}
