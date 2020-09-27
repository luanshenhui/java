package hongling.service.assemble;

import hongling.business.AssembleManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetSPProcessByKeyword extends BaseServlet {
	private static final long serialVersionUID = 6177371136167941106L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			// 取得检索关键字
			String strKeyword = Utility.toUtf8(request.getParameter("q"))
					.toUpperCase();
			String id = request.getParameter("id");
			output(new AssembleManager().GetComponentByKeyword(strKeyword,
					Utility.toSafeInt(id)));
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetMemberByKeyword_err" + e.getMessage());
		}
	}
}