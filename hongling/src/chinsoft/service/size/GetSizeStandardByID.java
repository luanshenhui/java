package chinsoft.service.size;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.SizeManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.SizeStandard;
import chinsoft.service.core.BaseServlet;

public class GetSizeStandardByID extends BaseServlet {
	
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nSizeStandardID = Utility.toSafeInt(getParameter("id"));
			Integer nUnitID = Utility.toSafeInt(getParameter("unitid"));
			SizeStandard sizeStandard = new SizeManager().getSizeStandardByID(nSizeStandardID,nUnitID);
			output(sizeStandard);
		} catch (Exception e) {
			LogPrinter.debug("GetSizeStandardByID_err" + e.getMessage());
		}
	}
}
