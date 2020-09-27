package chinsoft.service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class RemoveDictPrices extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015725L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String id = getParameter("id");
			output(new DictManager().removeDictPrice(id));
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}