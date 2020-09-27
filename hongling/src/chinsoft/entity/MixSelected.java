package chinsoft.entity;


public class MixSelected implements java.io.Serializable {
	private static final long serialVersionUID = 1L;
	private String id;
	private String memberid;
	private String mixcodes;
	

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getMemberid() {
		return memberid;
	}
	public void setMemberid(String memberid) {
		this.memberid = memberid;
	}
	public String getMixcodes() {
		return mixcodes;
	}
	public void setMixcodes(String mixcodes) {
		this.mixcodes = mixcodes;
	}
	@Override
	protected Object clone(){
		try{
			return super.clone();
		}catch (CloneNotSupportedException e) {
			 e.printStackTrace();
			 return null;
		}
	}
	@Override
	public String toString() {
		return "MixSelected [id=" + id + ", memberid=" + memberid + ", mixcodes="+ mixcodes + "]";
	}
	
}