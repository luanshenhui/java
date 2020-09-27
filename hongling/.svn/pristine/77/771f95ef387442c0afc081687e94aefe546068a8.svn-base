package chinsoft.service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SignOut extends BaseServlet {
	private static final long serialVersionUID = 8964069083532613103L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {		
		try {
			//super.service();
			HttpContext.signOut();
//			this.clearTempDesigns();
			this.clearTempOrdens();
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
