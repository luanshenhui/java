package chinsoft.entity;
public class CrossRule implements java.io.Serializable {
	private static final long serialVersionUID = 8976729804682315200L;
	private Integer ID;
	private String rules;
	private String memo;
	
	public Integer getID() {
		return this.ID;
	}

	public void setID(Integer ID) {
		this.ID = ID;
	}
	
	public String getRules() {
		return rules;
	}

	public void setRules(String rules) {
		this.rules = rules;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}
	
	public String getMemo() {
		return memo;
	}
}