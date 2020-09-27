package chinsoft.service.size;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.SizeManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetClothingBodyType extends BaseServlet{
	private static final long serialVersionUID = 7050343472564612874L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		super.service();
		try {
			output(new SizeManager().getClotingBodyType(Utility.toSafeInt(getTempClothingID()), Utility.toSafeInt(getParameter("sizecategoryid"))));
		} catch (Exception e) {
			LogPrinter.info("GetClothingBodyType_err"+e.getMessage());
		}
	}

}
