package chinsoft.service.groupmenu;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.GroupMenuManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetQGroupFunctions extends BaseServlet{
	private static final long serialVersionUID = -7892754396898316791L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		super.service();
		try {           
			int nGroupID = Utility.toSafeInt(getParameter("groupid"));
			output(new GroupMenuManager().getQGroupFunctions(nGroupID));
		} catch (Exception e) {
			LogPrinter.debug("GetAuthorityMenu_err"+"----"+e.getMessage());
		}
	}
}
