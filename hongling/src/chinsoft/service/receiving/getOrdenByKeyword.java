package chinsoft.service.receiving;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class getOrdenByKeyword extends BaseServlet {

	private static final long serialVersionUID = -1410352302905121447L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			// 取得检索关键字
			String strKeyword = Utility.toUtf8(request.getParameter("q")).toUpperCase();
			output(new OrdenManager().getOrdenByKeyword(strKeyword));
		} catch (Exception e) {
			LogPrinter.debug("GetOrdenByKeyword" + e.getMessage());
		}
	}
}
