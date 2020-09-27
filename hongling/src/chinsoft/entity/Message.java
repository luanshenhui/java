package chinsoft.entity;
import java.util.Date;
public class Message implements java.io.Serializable,Cloneable{
	
	private static final long serialVersionUID = 1995297368052685915L;
	private String ID;
	private String title;
	private String content;
	private Date pubDate;
	private String pubMemberID;
	private String receiverID;
	private Integer isRead;
	private Date readDate;
	private String pubMemberName;
	private String receiverName;
	
	public Message(){
		
	}
	public String getID() {
		return this.ID;
	}
	public void setID(String ID) {
		this.ID = ID;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}

	public String getPubMemberID() {
		return pubMemberID;
	}
	public void setPubMemberID(String pubMemberID) {
		this.pubMemberID = pubMemberID;
	}
	public String getReceiverID() {
		return receiverID;
	}
	public void setReceiverID(String receiverID) {
		this.receiverID = receiverID;
	}
	public Integer getIsRead() {
		return isRead;
	}
	public void setIsRead(Integer isRead) {
		this.isRead = isRead;
	}
	public Date getPubDate() {
		return pubDate;
	}
	public void setPubDate(Date pubDate) {
		this.pubDate = pubDate;
	}
	public Date getReadDate() {
		return readDate;
	}
	public void setReadDate(Date readDate) {
		this.readDate = readDate;
	}
	public String getPubMemberName() {
		return pubMemberName;
	}
	public void setPubMemberName(String pubMember) {
		this.pubMemberName = pubMember;
	}
	public String getReceiverName() {
		return receiverName;
	}
	public void setReceiverName(String receiver) {
		this.receiverName = receiver;
	}
	@Override
	public Object clone(){
        try {
			return super.clone();
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
			return null;
		}
    }
}
