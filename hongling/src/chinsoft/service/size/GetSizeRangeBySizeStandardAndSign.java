package chinsoft.service.size;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.SizeRangeManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetSizeRangeBySizeStandardAndSign extends BaseServlet{
	private static final long serialVersionUID = 6135592742768453406L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			Integer nUnitID = Utility.toSafeInt(getParameter("unitid"));
			output(new SizeRangeManager().getSizeRange(getParameter("sizestandardid"),getParameter("sign"),nUnitID));
		} catch (Exception e) {
			LogPrinter.debug("GetArea_err"+e.getMessage());
		}
	}

}
