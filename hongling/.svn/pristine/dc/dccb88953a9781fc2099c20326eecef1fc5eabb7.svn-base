package chinsoft.service.message;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.MessageManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetNewMessageCount extends BaseServlet {

	private static final long serialVersionUID = 8254527345135894391L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strReceiveMemberID = CurrentInfo.getCurrentMember().getID();
			long nCount = new MessageManager().getNewMessageCount(strReceiveMemberID);
			output(nCount);
		} catch (Exception e) {
			LogPrinter.error("GetNewMessageCount_err" + e.getMessage());
		}
	}
}
