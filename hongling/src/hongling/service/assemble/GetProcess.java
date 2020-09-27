package hongling.service.assemble;

import hongling.business.AssembleManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetProcess extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			super.service();
			Integer id = Utility.toSafeInt(request.getParameter("id"));

			String data = new AssembleManager().getProcessHtml(id);
			output(data);
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetOrdenStatisticerr" + e.getMessage());
		}
	}
}
