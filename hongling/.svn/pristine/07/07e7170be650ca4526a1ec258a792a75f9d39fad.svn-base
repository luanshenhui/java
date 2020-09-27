package chinsoft.service.size;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.SizeManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetSpecHeight extends BaseServlet{
	private static final long serialVersionUID = 456112221503462579L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		
		try {
			super.service();
			output(new SizeManager().getSpecHeight(Utility.toSafeInt(getParameter("singleclothingid")), Utility.toSafeInt(getParameter("areaid")),this.getTempComponentIDs()));
		} catch (Exception e) {
			LogPrinter.debug("GetSpec_err"+e.getMessage());
		}
	}
}
