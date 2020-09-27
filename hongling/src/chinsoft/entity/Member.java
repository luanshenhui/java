package chinsoft.entity;
import java.util.Date;
public class Member implements java.io.Serializable {
	private static final long serialVersionUID = -8603192623973556733L;
	private String ID;
	private String code;
	private String password;
	private String username;
	private String name;
	private Integer groupID;
	private String groupName;
	private Integer statusID;
	private String statusName;
	private Date registDate;
	private Date lastLoginDate;
	private String clientIP;
	private String parentID;
	private String parentName;
	private String isTrustName;
	private Integer payTypeID;
	private String payTypeName;
	private String ordenPre;
	//客户公司名
	private String companyName;
	//联系人
	private String contact;
	//客户简称
	private String companyShortName;
	//收货地址
	private String receiveAddress;
	//帐号
	private String account;
	//合同号
	private String contractNo;
	//CMT价格
	private String cmtPrice;
	private String cmtPriceName;

	//备注
	private String memo;
	private String ownedPartner;
	private String ownedStore;
	private Integer subs;
	private Integer applyDeliveryTypeID;
	private String  applyDeliveryDays;
	private String applyDeliveryAddress;
	private Integer moneySignID;
	private String moneySignName;
	private String fabricPre;
	private Integer isMTO;
	private String isMTOName;
	private Integer homePage;
	private String homePageName;
	private String expressComId; // 快递公司ID 
	private String expressComName; // 快递公司name
	private Integer isDiscount;  // 是否打折
	private Integer isUserNo; //是否使用客户单号
	private String menuIDs;
	private String addressLine1;//
	private String addressLine2;//
	private String city;//
	private String division;//
	private String divisionCode;//
	private String postalCode;//
	private String countryCode;//
	private String countryName;//
	private String federalTaxID;//
	private String phoneNumber;//
	private String phoneExtension;//
	private String faxNumber;//
	private String telex;//
	private String email;//
	private Integer shippingPaymentType;//邮费付款方式
	private Integer priceType; // 定价方式
	private Double retailDiscountRate; // 零售折扣价格
	
	/**
	 * 经营单位
	 */
	private Integer businessUnit; // 经营单位
	
	private Integer companyID;//企业编码
	private String srUserID;//善融商务账号
	private Integer userStatus;// 10050已登录
	private String cmt100;//100cmt
	private String cmt300;//300cmt
	
	private String liningType;//默认衬类型
	private Integer logo;//logo更改
	
	private String qordermenuids;
	private Integer semiFinished; //是否使用半成品试衣
	private String isUserNoName;
	private String semiFinishedName;
	private String businessUnitName;
	
	private String fabricMenuids;//面料权限
	private Integer fabricType;//面料类型
	private String fabricTypeName;
	
	private String LTNo;
	
	public String getFabricTypeName() {
		return fabricTypeName;
	}

	public void setFabricTypeName(String fabricTypeName) {
		this.fabricTypeName = fabricTypeName;
	}

	public String getFabricMenuids() {
		return fabricMenuids;
	}

	public void setFabricMenuids(String fabricMenuids) {
		this.fabricMenuids = fabricMenuids;
	}

	public Integer getFabricType() {
		return fabricType;
	}

	public void setFabricType(Integer fabricType) {
		this.fabricType = fabricType;
	}

	public String getBusinessUnitName() {
		return businessUnitName;
	}

	public void setBusinessUnitName(String businessUnitName) {
		this.businessUnitName = businessUnitName;
	}

	public String getIsUserNoName() {
		return isUserNoName;
	}

	public void setIsUserNoName(String isUserNoName) {
		this.isUserNoName = isUserNoName;
	}

	public String getSemiFinishedName() {
		return semiFinishedName;
	}

	public void setSemiFinishedName(String semiFinishedName) {
		this.semiFinishedName = semiFinishedName;
	}

	public String getCmt100() {
		return cmt100;
	}

	public Integer getSemiFinished() {
		return semiFinished;
	}

	public void setSemiFinished(Integer semiFinished) {
		this.semiFinished = semiFinished;
	}

	public void setCmt100(String cmt100) {
		this.cmt100 = cmt100;
	}

	public String getCmt300() {
		return cmt300;
	}

	public void setCmt300(String cmt300) {
		this.cmt300 = cmt300;
	}
	public String getMenuIDs() {
		return menuIDs;
	}

	public Integer getShippingPaymentType() {
		return shippingPaymentType;
	}

	public void setShippingPaymentType(Integer shippingPaymentType) {
		this.shippingPaymentType = shippingPaymentType;
	}

	public String getAddressLine1() {
		return addressLine1;
	}

	public void setAddressLine1(String addressLine1) {
		this.addressLine1 = addressLine1;
	}

	public String getAddressLine2() {
		return addressLine2;
	}

	public void setAddressLine2(String addressLine2) {
		this.addressLine2 = addressLine2;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getDivision() {
		return division;
	}

	public void setDivision(String division) {
		this.division = division;
	}

	public String getDivisionCode() {
		return divisionCode;
	}

	public void setDivisionCode(String divisionCode) {
		this.divisionCode = divisionCode;
	}

	public String getFederalTaxID() {
		return federalTaxID;
	}

	public void setFederalTaxID(String federalTaxID) {
		this.federalTaxID = federalTaxID;
	}

	public String getPostalCode() {
		return postalCode;
	}

	public void setPostalCode(String postalCode) {
		this.postalCode = postalCode;
	}

	public String getCountryCode() {
		return countryCode;
	}

	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}

	public String getCountryName() {
		return countryName;
	}

	public void setCountryName(String countryName) {
		this.countryName = countryName;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public String getPhoneExtension() {
		return phoneExtension;
	}

	public void setPhoneExtension(String phoneExtension) {
		this.phoneExtension = phoneExtension;
	}

	public String getFaxNumber() {
		return faxNumber;
	}

	public void setFaxNumber(String faxNumber) {
		this.faxNumber = faxNumber;
	}

	public String getTelex() {
		return telex;
	}

	public void setTelex(String telex) {
		this.telex = telex;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setMenuIDs(String menuIDs) {
		this.menuIDs = menuIDs;
	}
	public String getCmtPriceName() {
		return cmtPriceName;
	}

	public void setCmtPriceName(String cmtPriceName) {
		this.cmtPriceName = cmtPriceName;
	}
	public String getFabricPre() {
		return fabricPre;
	}

	public void setFabricPre(String fabricPre) {
		this.fabricPre = fabricPre;
	}

	public String getMoneySignName() {
		return moneySignName;
	}

	public void setMoneySignName(String moneySignName) {
		this.moneySignName = moneySignName;
	}

	public Integer getMoneySignID() {
		return moneySignID;
	}

	public void setMoneySignID(Integer moneySignID) {
		this.moneySignID = moneySignID;
	}

	public Member() {
	}

	public Integer getApplyDeliveryTypeID() {
		return applyDeliveryTypeID;
	}

	public void setApplyDeliveryTypeID(Integer applyDeliveryTypeID) {
		this.applyDeliveryTypeID = applyDeliveryTypeID;
	}

	public String getApplyDeliveryDays() {
		return applyDeliveryDays;
	}

	public void setApplyDeliveryDays(String applyDeliveryDays) {
		this.applyDeliveryDays = applyDeliveryDays;
	}

	public String getApplyDeliveryAddress() {
		return applyDeliveryAddress;
	}

	public void setApplyDeliveryAddress(String applyDeliveryAddress) {
		this.applyDeliveryAddress = applyDeliveryAddress;
	}

	public String getID() {
		return ID;
	}

	public void setID(String ID) {
		this.ID = ID;
	}

	public String getCode() {
		return this.code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getPassword() {
		return this.password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUsername() {
		return this.username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getGroupID() {
		return this.groupID;
	}

	public void setGroupID(Integer groupID) {
		this.groupID = groupID;
	}
	
	public String getGroupName() {
		return this.groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public Integer getStatusID() {
		return this.statusID;
	}

	public void setStatusID(Integer statusID) {
		this.statusID = statusID;
	}
	
	public String getStatusName() {
		return this.statusName;
	}

	public void setStatusName(String statusName) {
		this.statusName = statusName;
	}

	public Date getRegistDate() {
		return this.registDate;
	}

	public void setRegistDate(Date registDate) {
		this.registDate = registDate;
	}

	public Date getLastLoginDate() {
		return this.lastLoginDate;
	}

	public void setLastLoginDate(Date lastLoginDate) {
		this.lastLoginDate = lastLoginDate;
	}

	public String getClientIP() {
		return this.clientIP;
	}

	public void setClientIP(String clientIP) {
		this.clientIP = clientIP;
	}

	public String getParentID() {
		return this.parentID;
	}

	public void setParentID(String parentID) {
		this.parentID = parentID;
	}

	public String getParentName() {
		return parentName;
	}

	public void setParentName(String parentName) {
		this.parentName = parentName;
	}
	
	public String getIsTrustName() {
		return this.isTrustName;
	}

	public void setIsTrustName(String isTrustName) {
		this.isTrustName = isTrustName;
	}
	
	public Integer getPayTypeID() {
		return this.payTypeID;
	}

	public void setPayTypeID(Integer payTypeID) {
		this.payTypeID = payTypeID;
	}
	
	public String getPayTypeName() {
		return this.payTypeName;
	}

	public void setPayTypeName(String payTypeName) {
		this.payTypeName = payTypeName;
	}
	
	public String getOrdenPre() {
		return this.ordenPre;
	}

	public void setOrdenPre(String ordenPre) {
		this.ordenPre = ordenPre;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	
	public String getCompanyShortName() {
		return companyShortName;
	}

	public void setCompanyShortName(String companyShortName) {
		this.companyShortName = companyShortName;
	}

	public String getReceiveAddress() {
		return receiveAddress;
	}

	public void setReceiveAddress(String receiveAddress) {
		this.receiveAddress = receiveAddress;
	}

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public String getCmtPrice() {
		return cmtPrice;
	}

	public void setCmtPrice(String cmtPrice) {
		this.cmtPrice = cmtPrice;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}
	
	public String getOwnedPartner() {
		return ownedPartner;
	}

	public void setOwnedPartner(String ownedPartner) {
		this.ownedPartner = ownedPartner;
	}
	
	public String getOwnedStore() {
		return ownedStore;
	}

	public void setOwnedStore(String ownedStore) {
		this.ownedStore = ownedStore;
	}

	
	public Integer getSubs() {
		return this.subs;
	}

	public void setSubs(Integer subs) {
		this.subs = subs;
	}

	public Integer getIsMTO() {
		return isMTO;
	}

	public void setIsMTO(Integer isMTO) {
		this.isMTO = isMTO;
	}

	public String getIsMTOName() {
		return isMTOName;
	}

	public void setIsMTOName(String isMTOName) {
		this.isMTOName = isMTOName;
	}

	public Integer getHomePage() {
		return homePage;
	}

	public void setHomePage(Integer homePage) {
		this.homePage = homePage;
	}

	public String getHomePageName() {
		return homePageName;
	}

	public void setHomePageName(String homePageName) {
		this.homePageName = homePageName;
	}

	public String getExpressComId() {
		return expressComId;
	}

	public void setExpressComId(String expressComId) {
		this.expressComId = expressComId;
	}

	public Integer getIsDiscount() {
		return isDiscount;
	}

	public void setIsDiscount(Integer isDiscount) {
		this.isDiscount = isDiscount;
	}

	public String getExpressComName() {
		return expressComName;
	}

	public void setExpressComName(String expressComName) {
		this.expressComName = expressComName;
	}

	public Integer getBusinessUnit() {
		return businessUnit;
	}

	public void setBusinessUnit(Integer businessUnit) {
		this.businessUnit = businessUnit;
	}

	public Integer getPriceType() {
		return priceType;
	}

	public void setPriceType(Integer priceType) {
		this.priceType = priceType;
	}

	public Double getRetailDiscountRate() {
		return retailDiscountRate;
	}

	public void setRetailDiscountRate(Double retailDiscountRate) {
		this.retailDiscountRate = retailDiscountRate;
	}

	public Integer getIsUserNo() {
		return isUserNo;
	}

	public void setIsUserNo(Integer isUserNo) {
		this.isUserNo = isUserNo;
	}

	public String getSrUserID() {
		return srUserID;
	}

	public void setSrUserID(String srUserID) {
		this.srUserID = srUserID;
	}

	public Integer getCompanyID() {
		return companyID;
	}

	public void setCompanyID(Integer companyID) {
		this.companyID = companyID;
	}

	public Integer getUserStatus() {
		return userStatus;
	}

	public void setUserStatus(Integer userStatus) {
		this.userStatus = userStatus;
	}

	public String getLiningType() {
		return liningType;
	}

	public void setLiningType(String liningType) {
		this.liningType = liningType;
	}

	public Integer getLogo() {
		return logo;
	}

	public void setLogo(Integer logo) {
		this.logo = logo;
	}

	public String getQordermenuids() {
		return qordermenuids;
	}

	public void setQordermenuids(String qordermenuids) {
		this.qordermenuids = qordermenuids;
	}

	public String getLTNo() {
		return LTNo;
	}

	public void setLTNo(String lTNo) {
		LTNo = lTNo;
	}

	
}