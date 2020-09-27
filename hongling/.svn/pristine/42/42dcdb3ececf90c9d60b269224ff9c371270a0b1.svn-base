package chinsoft.service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.MemberManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetMemberByUsername extends BaseServlet {
	private static final long serialVersionUID = 6177371136167941116L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String username = getParameter("username");
			output(new MemberManager().getMemberByUsername(username));
		} catch (Exception e) {
			LogPrinter.debug("GetMemberByUsername_err" + e.getMessage());
		}
	}
}
