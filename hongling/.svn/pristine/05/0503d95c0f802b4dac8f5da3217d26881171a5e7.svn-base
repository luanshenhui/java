package chinsoft.service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.MemberManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class GetMemberFabricFunctions extends BaseServlet{
	private static final long serialVersionUID = -7892754396898316731L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		super.service();
		try {           
			String strMemberID = getParameter("memberid");
			Member member = new MemberManager().getMemberByID(strMemberID);
			if(member != null){
				output(member.getFabricMenuids());
			}
			
		} catch (Exception e) {
			LogPrinter.debug("GetMemberFabricFunctions"+"----"+e.getMessage());
		}
	}
}
