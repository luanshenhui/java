package centling.service.orden;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class BlGetOrdensClient extends BaseServlet {
	private static final long serialVersionUID = 2882744934561220092L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			String from = getParameter("from");
//			String memberCode = "";
//			if (!"BlViewOrdenList".equals(from)){
//				memberCode = CurrentInfo.getCurrentMember().getCode();
//			}
//			List<Member> clients = new OrdenManager().getBlOrdensClient(memberCode, from);
			String memberCode = CurrentInfo.getCurrentMember().getCode();
			List<Member> clients = null;
			if ("BlViewOrdenList".equals(from)){//订单查看 “姓名”显示当前用户下所有子用户信息(存在订单为发货状态且不为管理用户)
				clients = new OrdenManager().getBlOrdensClients(memberCode, from);
			}else{//显示当前用户下一级子用户信息
				clients = new OrdenManager().getBlOrdensClient(memberCode, from);
			}
			output(clients);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
