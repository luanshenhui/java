package chinsoft.service.groupmenu;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.GroupMenuManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetAllFabricFunctions extends BaseServlet{
	private static final long serialVersionUID = -7892754396898316791L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		super.service();
		try {
			output(new GroupMenuManager().getAllFabricFunctions());
		} catch (Exception e) {
			LogPrinter.debug("getAllFabricFunctions"+"----"+e.getMessage());
		}
	}
}