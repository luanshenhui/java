package chinsoft.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetFabricByCode extends BaseServlet {

	private static final long serialVersionUID = 8056845459527730974L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			super.service();
			output(new FabricManager().getFabricByCode(getParameter("code")));

			// Member loginUser = CurrentInfo.getCurrentMember();
			// Integer areaid = loginUser.getBusinessUnit();
			//
			// Fabric fabric = new FabricManager()
			// .getFabricByCode(getParameter("code"));
			// if (new FilterAreaFabric().isOurFabric(areaid, fabric)) {
			// output(fabric);
			// }

		} catch (Exception e) {
			LogPrinter.debug("GetFabricByID_err" + e.getMessage());
		}
	}
}
