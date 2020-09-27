package chinsoft.service.size;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.SizeManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetArea extends BaseServlet{
	private static final long serialVersionUID = 6135592742768453406L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nSizeCategoryID=Utility.toSafeInt(getParameter("sizecategoryid"));
			output(new SizeManager().getArea(Utility.toSafeInt(getTempClothingID()),nSizeCategoryID));
		} catch (Exception e) {
			LogPrinter.debug("GetArea_err"+e.getMessage());
		}
	}

}
