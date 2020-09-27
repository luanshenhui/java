package chinsoft.service.message;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.MessageManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Message;
import chinsoft.service.core.BaseServlet;

public class GetMessageByID extends BaseServlet {

	private static final long serialVersionUID = 8254527345115894391L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strMessageID = getParameter("id");
			Message message = new MessageManager().getMessageByID(strMessageID);
			//修改消息状态为已读
			if(!CDict.YES.getID().equals(message.getIsRead())){
				message.setIsRead(CDict.YES.getID());
				message.setReadDate(new Date());
				new MessageManager().saveMessage(message);
			}
			output(message);
		} catch (Exception e) {
			LogPrinter.error("GetMessageByID_err" + e.getMessage());
		}
	}
}