package hongling.service.assemble;

import hongling.business.AssembleManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.service.core.BaseServlet;

public class ValidateCode extends BaseServlet {

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			super.service();
			String inputCode = request.getParameter("code");
			int nCount = new AssembleManager().validateCode(inputCode);
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdens_err" + e.getMessage());
		}
	}

}
