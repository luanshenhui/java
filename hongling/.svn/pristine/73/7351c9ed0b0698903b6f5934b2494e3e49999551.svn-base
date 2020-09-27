package chinsoft.service.information;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.InformationManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Information;
import chinsoft.service.core.BaseServlet;

public class GetInformationByID extends BaseServlet {

	private static final long serialVersionUID = 8254527345115894391L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strInformationID = getParameter("id");
			Information information = new InformationManager().getInformationByID(strInformationID);
			output(information);
		} catch (Exception e) {
			LogPrinter.debug("GetInformationByID_err" + e.getMessage());
		}
	}
}
