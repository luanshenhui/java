package hongling.service.assemble;

import hongling.business.AssembleManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetAssembleStyle extends BaseServlet {
	private static final long serialVersionUID = -7892754396898316791L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		super.service();
		try {
			String id = request.getParameter("id");
			output(new AssembleManager().findAssembleStyles(id));
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetAllFunctions_err" + "----" + e.getMessage());
		}
	}
}
