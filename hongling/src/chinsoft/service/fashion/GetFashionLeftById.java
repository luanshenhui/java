package chinsoft.service.fashion;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FashionManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;


public class GetFashionLeftById extends BaseServlet{
	private static final long serialVersionUID = 2374662018001166039L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nType = Utility.toSafeInt(getParameter("id"));
			String strImg = new FashionManager().getFashionLeftImgByParentID(nType,request);
			output(strImg);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
