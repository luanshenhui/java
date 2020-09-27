package chinsoft.service.size;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.SizeManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetSizeCategory extends BaseServlet{
	private static final long serialVersionUID = -8094375453509599296L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			output(new SizeManager().getSizeCategory(Utility.toSafeInt(this.getTempClothingID())));
		} catch (Exception e) {
		LogPrinter.debug("GetSizeCategory_err"+e.getMessage());
		}
	}
}
