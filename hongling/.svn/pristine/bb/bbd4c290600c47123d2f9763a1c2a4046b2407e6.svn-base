package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SetTempFabricCode extends BaseServlet {

	private static final long serialVersionUID = -1759095871257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			// 原默认面料,写死的 定死的,死的透透的
			String fabricCode = getParameter("fabriccode");
			this.setTempFabricCode(fabricCode);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

