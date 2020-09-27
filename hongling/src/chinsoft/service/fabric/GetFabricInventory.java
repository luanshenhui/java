package chinsoft.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetFabricInventory extends BaseServlet{

	private static final long serialVersionUID = 8386546310167190420L;
	@Override
	public void service(HttpServletRequest request,HttpServletResponse response) {
		super.service();
		try {
			String strCode = getParameter("code");
			Double dblResult = new FabricManager().getFabricInventory(strCode);
			output(dblResult);
		} catch (Exception e) {
			LogPrinter.debug("GetFabricInventory+err"+e.getMessage());
		}
	}
}
