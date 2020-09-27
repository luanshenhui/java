package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class ClearTempDesigns extends BaseServlet {

	private static final long serialVersionUID = -3752715901655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			this.clearTempDesigns();
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}