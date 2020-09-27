package chinsoft.service.fashion;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FashionManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;


public class GetFashions extends BaseServlet{
	private static final long serialVersionUID = 2374662018001169039L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nType = Utility.toSafeInt(getParameter("type"));
			String strImg = new FashionManager().getFashionsImgByParentID(nType);
			output(strImg);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
