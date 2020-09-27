package hongling.service.assemble;

import hongling.business.AssembleManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class RemoveAssemble extends BaseServlet {
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String removedIDs = getParameter("removedIDs");
			// 获得当前登陆用户
			Member loginUser = CurrentInfo.getCurrentMember();
			String user = loginUser.getName();

			output(new AssembleManager().removeAssembles(user, removedIDs));
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}
