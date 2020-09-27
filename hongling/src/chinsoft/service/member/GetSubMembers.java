package chinsoft.service.member;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;


public class GetSubMembers extends BaseServlet{
	private static final long serialVersionUID = 2374662018001169009L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int moneySignID=Utility.toSafeInt(getParameter("moneySignID"));
			String strMemberCode = CurrentInfo.getCurrentMember().getCode();
			List<Member> members = new MemberManager().getSubMembers(strMemberCode,moneySignID);
			output(members);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
		
	}
}
