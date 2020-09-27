package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.entity.Message;

public class MessageManager {
	DataAccessObject dao = new DataAccessObject();
	
	/**
	 * 保存或修改消息
	 * @author zhou yong
	 * @param messages 信息List
	 */
	public void saveMessage(Message message){
		if(message == null){
			return;
		}
		dao.saveOrUpdate(message);
	}
	/**
	 * 保存多条消息
	 * @author zhou yong
	 * @param messages 信息List
	 */
	public void saveMessages(List<Message> messages){
		if(messages == null || messages.size()==0){
			return;
		}
		for(Message message : messages){
			message.setIsRead(CDict.NO.getID());
			dao.saveOrUpdate(message);
		}
	}
	/**
	 * 通过ID查找消息
	 * @author zhou yong
	 * @param strMessageID 消息ID
	 * @return Message消息对象
	 */
	public Message getMessageByID(String strMessageID){
		Message message = (Message) dao.getEntityByID(Message.class, strMessageID);
		message = extendMessage(message);
		return message;
	}
	
	/**
	 * 删除一条消息
	 * @author zhou yong
	 * @param messageId 消息ID
	 * @param session
	 */
	public void removeMessage(Session session,String messageId){
		dao.remove(session,Message.class, messageId);
	}
	/**
	 * 删除多条消息
	 * @author zhou yong
	 * @param removedIDs 消息ID，多个逗号隔开
	 * @return 删除状态
	 */
	public String removeMessages(String removeIDs){
		if (removeIDs.equals("")) {
			return "请选择待删除项";
		}		
    	Transaction transaction=null;
    	Session session=null;
    	try {
	    	session= DataAccessObject.openSession();
	    	transaction=session.beginTransaction();
	    	
	    	String[] arrMessageIDs = Utility.getStrArray(removeIDs);
	    	LogPrinter.debug("length_arr" + arrMessageIDs.length);
	    	for (Object messageID : arrMessageIDs) {
	    		if(messageID != null && messageID != "")
	            {
	                this.removeMessage(session, Utility.toSafeString(messageID));
	            }
	    	}	    	
	    	transaction.commit();
	    	return Utility.RESULT_VALUE_OK;
    	} catch (Exception e) {
	    	transaction.rollback();
			LogPrinter.error(e.getMessage());
			return e.getMessage();
		}finally{
			DataAccessObject.closeSession();
		}
	}
	public long getNewMessageCount(String strReceiveMemberID)
    {
		long count = 0;
    	try {
    		String hql = "SELECT COUNT(*) FROM Message m WHERE m.ReceiverID = :ReceiveID AND m.IsRead = :NO" ;
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("ReceiveID", strReceiveMemberID);
			query.setInteger("NO", CDict.NO.getID());
			
			count=Utility.toSafeLong(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return count;
    }
	/**
	 * 消息的数量
	 * @author zhou yong
	 * @param strKeyword
	 * @return
	 */
	public long getMessagesCount(String strReceiveMemberID,int nInOrSent, String strKeyword)
    {
		long count = 0;
    	try {
    		String hql = "SELECT COUNT(*) FROM Message m WHERE Title LIKE :Keyword  " ;
    		if(nInOrSent==0){
	    		hql=hql+" AND m.ReceiverID= :ID";
	    	}else{
	    		hql=hql+" AND m.PubMemberID= :ID";
	    	}
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("ID", strReceiveMemberID);
			query.setString("Keyword", "%" + strKeyword + "%");
			count=Utility.toSafeLong(query.uniqueResult());
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return count;
    }

	/**
	 * 获取消息列表
	 * @param nPageIndex
	 * @param nPageSize
	 * @param strKeyword
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Message> getMessages(int nPageIndex, int nPageSize, String strMemberID,int nInOrSent, String strKeyword)
    {
		List<Message> list= new ArrayList<Message>();
    	try {
	    	String hql = "FROM Message i WHERE Title LIKE :Keyword " ;
	    	if(nInOrSent==0){
	    		hql=hql+" AND i.ReceiverID= :ID";
	    	}else{
	    		hql=hql+" AND i.PubMemberID= :ID";
	    	}
	    	hql=hql+" ORDER BY PubDate DESC ,ID desc";
	    	Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("ID", strMemberID);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			query.setString("Keyword", "%" + strKeyword + "%");
			list=query.list();
			for(Message message : list){
				message = extendMessage(message);
			}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	
    	return list;
    }
	/**
	 * 设置message的发送人和接收人名称
	 * @param message
	 * @return
	 */
	public Message extendMessage(Message message){
		String receiverID = message.getReceiverID();
		if(receiverID != null && receiverID != ""){
			Member member = new MemberManager().getMemberByID(receiverID);
			if(member != null){
				message.setReceiverName(member.getName());
			}
		}
		String pubMemberID = message.getPubMemberID();
		if(pubMemberID != null && pubMemberID != ""){
			Member member = new MemberManager().getMemberByID(pubMemberID);
			if(member != null){
				message.setPubMemberName(member.getName());
			}
		}
		return message;
	}
}
