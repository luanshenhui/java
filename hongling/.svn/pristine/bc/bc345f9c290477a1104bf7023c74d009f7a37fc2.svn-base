package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetTempComponentIDs extends BaseServlet {

	private static final long serialVersionUID = -1750095872257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			output(getTempFabricCode() + "," + this.getTempComponentIDs());
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

