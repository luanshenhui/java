package centling.service.expresscom;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlExpressComManager;
import centling.entity.ExpressCom;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class BlSaveExpressCom extends BaseServlet {
	private static final long serialVersionUID = 1L;
	
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String strFormData = getParameter("formData");
			ExpressCom expressCom = new ExpressCom();
			expressCom = (ExpressCom)EntityHelper.updateEntityFromFormData(expressCom, strFormData);
			new BlExpressComManager().saveExpressCom(expressCom);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.error("getExpressCom_err" + e.getMessage());
		}
	}

}
