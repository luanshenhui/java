package chinsoft.service.cash;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetBalance extends BaseServlet{
	private static final long serialVersionUID = 7050343472564612874L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		
		try {
			super.service();
			//output(new CashManager().getBalance());
		} catch (Exception e) {
			LogPrinter.debug("GetClothingBodyType_err"+e.getMessage());
		}
	}
}
