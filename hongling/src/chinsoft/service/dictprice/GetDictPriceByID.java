package chinsoft.service.dictprice;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictPriceManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Dictprice;
import chinsoft.service.core.BaseServlet;

public class GetDictPriceByID extends BaseServlet {

	private static final long serialVersionUID = 8254527345115894391L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strDictpriceID = getParameter("id");
			Dictprice information = new DictPriceManager().getDictPriceByID(strDictpriceID);
			output(information);
		} catch (Exception e) {
			LogPrinter.debug("GetInformationByID_err" + e.getMessage());
		}
	}
}
