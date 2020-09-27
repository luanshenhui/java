package rcmtm.endpoint;

/**
 * TLogistics entity. @author MyEclipse Persistence Tools
 */

public class TLogistics implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long	serialVersionUID	= -7853716638850570353L;
//	private Integer	id;
//	private String	waybillNo;
	private String	logisticNo;
	private String	logisticCompany;
	private String	orderNo;
	private String	receiverName;
	private String	receiverPhoneno;
	private String	receiverCountry;
	private String	receiverCity;
	private String	receiverDistrict;
	private String	receiverAddress;
//	private Double	wareWeight;
//	private Double	wareVolume;
	private String	carryType;
	private Double	transportFee;
//	private String	status;
//	private String	createTime;
//	private String	confirmDate;
	private String	deliverDate;
	private String	remark;
	private String	receiverProvince;

	// Constructors

	public String getReceiverProvince() {
		return receiverProvince;
	}

	public void setReceiverProvince(String receiverProvince) {
		this.receiverProvince = receiverProvince;
	}
	
	/** default constructor */
	public TLogistics() {
	}

	// Property accessors

	public String getLogisticNo() {
		return this.logisticNo;
	}

	public void setLogisticNo(String logisticNo) {
		this.logisticNo = logisticNo;
	}

	public String getLogisticCompany() {
		return this.logisticCompany;
	}

	public void setLogisticCompany(String logisticCompany) {
		this.logisticCompany = logisticCompany;
	}

	public String getOrderNo() {
		return this.orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public String getReceiverName() {
		return this.receiverName;
	}

	public void setReceiverName(String receiverName) {
		this.receiverName = receiverName;
	}

	public String getReceiverPhoneno() {
		return this.receiverPhoneno;
	}

	public void setReceiverPhoneno(String receiverPhoneno) {
		this.receiverPhoneno = receiverPhoneno;
	}

	public String getReceiverCountry() {
		return this.receiverCountry;
	}

	public void setReceiverCountry(String receiverCountry) {
		this.receiverCountry = receiverCountry;
	}

	public String getReceiverCity() {
		return this.receiverCity;
	}

	public void setReceiverCity(String receiverCity) {
		this.receiverCity = receiverCity;
	}

	public String getReceiverDistrict() {
		return this.receiverDistrict;
	}

	public void setReceiverDistrict(String receiverDistrict) {
		this.receiverDistrict = receiverDistrict;
	}

	public String getReceiverAddress() {
		return this.receiverAddress;
	}

	public void setReceiverAddress(String receiverAddress) {
		this.receiverAddress = receiverAddress;
	}

	public String getCarryType() {
		return this.carryType;
	}

	public void setCarryType(String carryType) {
		this.carryType = carryType;
	}

	public Double getTransportFee() {
		return this.transportFee;
	}

	public void setTransportFee(Double transportFee) {
		this.transportFee = transportFee;
	}

	public String getDeliverDate() {
		return this.deliverDate;
	}

	public void setDeliverDate(String deliverDate) {
		this.deliverDate = deliverDate;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}