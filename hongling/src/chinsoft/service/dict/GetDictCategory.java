package chinsoft.service.dict;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictCategoryManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetDictCategory extends BaseServlet {
	private static final long serialVersionUID = 6468670315843211574L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			new DictCategoryManager();
			output(DictCategoryManager.getAllDictCategory());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}
	}
}
