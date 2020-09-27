package chinsoft.service.message;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.business.MessageManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.entity.Message;
import chinsoft.service.core.BaseServlet;

public class SaveMessage extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			//super.service();
			String strFormData = getParameter("formData");
			Message message = new Message();
			message = (Message) EntityHelper.updateEntityFromFormData(message, strFormData);
			List<Message> messages = new ArrayList<Message>();
			//接收人名字
			String strReceiverIDs = getParameter("receiverID");
			String[] receiverIDs = Utility.getStrArray(strReceiverIDs);
			if(receiverIDs==null || receiverIDs.length==0){
				output("Please Input The Username");
				return;
			}

			String  strPubMemberID = CurrentInfo.getCurrentMember().getID();
			for(String receiverID : receiverIDs){
				if(receiverID != null && !"".equals(receiverID) && !"".equals(receiverID.trim())){
					Message tempMessage = new Message();
					tempMessage = (Message)message.clone();

					Member member = new MemberManager().getMemberByID(receiverID);
					if(member != null){
						tempMessage.setReceiverID(member.getID());
					}
					
					tempMessage.setPubMemberID(strPubMemberID);
					tempMessage.setPubDate(new Date());
					messages.add(tempMessage);
				}
			}
			
			new MessageManager().saveMessages(messages);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			LogPrinter.error(err.getMessage());
		}
	}
}