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

public class GetPickMembers extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strKeyword =getParameter("searchKeyword");
			
			int searchGroupIDs=Utility.toSafeInt(getParameter("searchGroupIDs"));
			
			List<Member> data = new MemberManager().getPickMembers(strKeyword, searchGroupIDs);
			Member parent = new MemberManager().getMemberByID(CurrentInfo.getCurrentMember().getParentID());
			if(parent != null){
				data.add(parent);
			}
			output(data);
		} catch (Exception e) {
			LogPrinter.debug("getmembers_err" + e.getMessage());
		}
	}
}
