package chinsoft.service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.MemberManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class GetMemberByID extends BaseServlet {
	
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strMemberID = getParameter("id");
			Member member = new MemberManager().getMemberByID(strMemberID);
			output(member);
		} catch (Exception e) {
			LogPrinter.debug("GetMemberByID_err" + e.getMessage());
		}
	}
}
