package chinsoft.service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.MemberManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class SaveMemberMenu extends BaseServlet{
	private static final long serialVersionUID = -6192897803965585696L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		super.service();
		try {
			String strMemberID = getParameter("memberid");
            String strMenuIDs = getParameter("menus");
            Member member = new MemberManager().getMemberByID(strMemberID);
            
            if ("qorder".equals(getParameter("flag"))) {
            	member.setQordermenuids(strMenuIDs);
			} else if ("fabric".equals(getParameter("flag"))) {
            	member.setFabricMenuids(strMenuIDs);
			} else {
				member.setMenuIDs(strMenuIDs);
			}

            new MemberManager().saveMember(member);
            output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.info("SaveMemberMenu_err   "+e.getMessage());
		}
	}
}
