package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetOverdueCount extends BaseServlet {

	private static final long serialVersionUID = -1759095872257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			String strMemberCode = CurrentInfo.getCurrentMember().getCode();
			output(new OrdenManager().getOverdueCount(strMemberCode));
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

