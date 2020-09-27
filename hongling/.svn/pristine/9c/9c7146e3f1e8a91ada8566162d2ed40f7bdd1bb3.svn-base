package chinsoft.service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetCurrentMember extends BaseServlet {
	
	private static final long serialVersionUID = -2098225252505951658L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		
		try {
			super.service();
			output(CurrentInfo.getCurrentMember());
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}

	}
}
