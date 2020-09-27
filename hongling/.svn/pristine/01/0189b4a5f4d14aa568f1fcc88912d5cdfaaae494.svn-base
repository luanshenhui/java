package chinsoft.service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.MemberManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetMemberByKeyword extends BaseServlet {
	private static final long serialVersionUID = 6177371136167941106L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			// 取得检索关键字
			String strKeyword = Utility.toUtf8(request.getParameter("q"));
			output(new MemberManager().getMemberByKeyword(strKeyword));
		} catch (Exception e) {
			LogPrinter.debug("GetMemberByKeyword_err" + e.getMessage());
		}
	}
}
