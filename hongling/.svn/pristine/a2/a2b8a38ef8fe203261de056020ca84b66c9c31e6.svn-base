package chinsoft.service.message;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.MessageManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Message;
import chinsoft.service.core.BaseServlet;

public class GetMessages extends BaseServlet {

	private static final long serialVersionUID = 8773652529479474459L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			String strKeyword = this.getParameter("keyword");
			String  strMemberID = CurrentInfo.getCurrentMember().getID();
			int	nInOrSent=Utility.toSafeInt(getParameter("inOrSent"));
			List<Message> data = new MessageManager().getMessages(nPageIndex, CDict.PAGE_SIZE, strMemberID,nInOrSent, strKeyword);
			long nCount = new MessageManager().getMessagesCount(strMemberID,nInOrSent,strKeyword);
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.error("getMessages_err" + e.getMessage());
		}
	}
}
