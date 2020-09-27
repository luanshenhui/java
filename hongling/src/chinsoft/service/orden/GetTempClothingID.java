package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetTempClothingID extends BaseServlet {

	private static final long serialVersionUID = -1759095872257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			output(Utility.toSafeInt(this.getTempClothingID()));
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

