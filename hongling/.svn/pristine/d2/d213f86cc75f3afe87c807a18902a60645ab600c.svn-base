package chinsoft.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class OccupyFabric extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String strUsername = CurrentInfo.getERPUserName();
			String strCode = getParameter("fabricCode");
			String strAmount = getParameter("amount");
			String strMemo = getParameter("memo");
			String result = new FabricManager().occupyFabric(strUsername, strCode, strAmount, strMemo);
			output(result);
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}