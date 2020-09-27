package centling.dto;

public class DiscountDto implements java.io.Serializable{
	private static final long serialVersionUID = 5711768973826281153L;
	private String ID;            //id
	private String memberId;      //用户ID
	private String memberUserName;
	private Integer disClothingId;//衣服种类id（西服、衬衣）
	private String disClothingName;
	private Integer fromNum;      //从多少件
	private Integer toNum;        //到多少件
	private Integer discountNum;  //折扣百分数
	private String memo;          //备注
	public DiscountDto() {
		super();
	}
	public DiscountDto(String iD, String memberId, String memberName,
			Integer disClothingId, String disClothingName, Integer fromNum,
			Integer toNum, Integer discountNum, String memo) {
		super();
		ID = iD;
		this.memberId = memberId;
		this.memberUserName = memberName;
		this.disClothingId = disClothingId;
		this.disClothingName = disClothingName;
		this.fromNum = fromNum;
		this.toNum = toNum;
		this.discountNum = discountNum;
		this.memo = memo;
	}
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
	public String getMemberId() {
		return memberId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	public String getMemberUserName() {
		return memberUserName;
	}
	public void setMemberUserName(String memberUserName) {
		this.memberUserName = memberUserName;
	}
	public Integer getDisClothingId() {
		return disClothingId;
	}
	public void setDisClothingId(Integer disClothingId) {
		this.disClothingId = disClothingId;
	}
	public String getDisClothingName() {
		return disClothingName;
	}
	public void setDisClothingName(String disClothingName) {
		this.disClothingName = disClothingName;
	}
	public Integer getFromNum() {
		return fromNum;
	}
	public void setFromNum(Integer fromNum) {
		this.fromNum = fromNum;
	}
	public Integer getToNum() {
		return toNum;
	}
	public void setToNum(Integer toNum) {
		this.toNum = toNum;
	}
	public Integer getDiscountNum() {
		return discountNum;
	}
	public void setDiscountNum(Integer discountNum) {
		this.discountNum = discountNum;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
}
