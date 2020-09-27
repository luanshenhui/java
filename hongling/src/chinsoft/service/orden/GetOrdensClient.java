package chinsoft.service.orden;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;


public class GetOrdensClient extends BaseServlet{
	private static final long serialVersionUID = 2374662118001169009L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			String from = getParameter("from");
			String memberCode = "";
			if (!"BlViewOrdenList".equals(from)){
				memberCode = CurrentInfo.getCurrentMember().getCode();
			}
			List<Member> clients = new OrdenManager().getOrdensClient(memberCode);
			output(clients);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
