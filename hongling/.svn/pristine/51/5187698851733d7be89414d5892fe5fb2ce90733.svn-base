package hongling.service.assemble;

import hongling.business.AssembleManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetStyleByClothingId extends BaseServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -4112155851362128215L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		super.service();
		try {
			String id = getParameter("clothingID");

			output(new AssembleManager().getStyleByClothingId(id));
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetAllFunctions_err" + "----" + e.getMessage());
		}
	}
}
