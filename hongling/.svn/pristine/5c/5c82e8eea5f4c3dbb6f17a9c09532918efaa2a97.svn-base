package chinsoft.entity;
public class SizeRange implements java.io.Serializable ,Cloneable{
	private static final long serialVersionUID = 8976729804680315400L;
	private Integer ID;
	private String sizeStandardIDs;
	private Float sizeFrom;
	private Float sizeTo;
	private String sign;
	
	public boolean equals(Object obj){
		if(!(obj instanceof SizeRange))
			return false;
		SizeRange range = (SizeRange)obj;
		return this.ID.equals(range.getID());
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
	
	public String getSign() {
		return sign;
	}
	public void setSign(String sign) {
		this.sign = sign;
	}
	public Integer getID() {
		return ID;
	}
	public void setID(Integer iD) {
		ID = iD;
	}
	public String getSizeStandardIDs() {
		return sizeStandardIDs;
	}
	public void setSizeStandardIDs(String sizeStandardIDs) {
		this.sizeStandardIDs = sizeStandardIDs;
	}
	public Float getSizeFrom() {
		return sizeFrom;
	}
	public void setSizeFrom(Float sizeFrom) {
		this.sizeFrom = sizeFrom;
	}
	public Float getSizeTo() {
		return sizeTo;
	}
	public void setSizeTo(Float sizeTo) {
		this.sizeTo = sizeTo;
	}
}