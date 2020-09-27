package hongling.entity;

import java.util.Date;

public class FabricTrader {
	private Integer id;
	private String traderName;
	private Integer traderLevel;
	private String recommendation;
	private String address;
	private String telephone;
	private String remark;
	private String createBy;
	private Date createTime;
	
	
	
	public FabricTrader() {
	}

	public FabricTrader(Integer id, String traderName, Integer traderLevel,
			String recommendation, String address, String telephone,
			String remark, String createBy, Date createTime) {
		super();
		this.id = id;
		this.traderName = traderName;
		this.traderLevel = traderLevel;
		this.recommendation = recommendation;
		this.address = address;
		this.telephone = telephone;
		this.remark = remark;
		this.createBy = createBy;
		this.createTime = createTime;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getTraderName() {
		return traderName;
	}

	public void setTraderName(String traderName) {
		this.traderName = traderName;
	}

	public Integer getTraderLevel() {
		return traderLevel;
	}

	public void setTraderLevel(Integer traderLevel) {
		this.traderLevel = traderLevel;
	}

	public String getRecommendation() {
		return recommendation;
	}

	public void setRecommendation(String recommendation) {
		this.recommendation = recommendation;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getCreateBy() {
		return createBy;
	}

	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	
	
	
}
