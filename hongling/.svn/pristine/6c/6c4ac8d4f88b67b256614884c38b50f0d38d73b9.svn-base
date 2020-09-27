package chinsoft.entity;

import chinsoft.business.CDictCategory;

public class Dict implements java.io.Serializable,Cloneable{
	private static final long serialVersionUID = 3640916850592743522L;
	private Integer ID;
	private String name;
	private Integer categoryID;
	private String code;
	private Integer sequenceNo;
	private Integer parentID;
	private Integer statusID;
	private String constDefine;
	private String ecode;
	private Integer exclusionGroupID;
	private Integer mediumGroupID;
	private Integer isDefault;
	private String bodyType;
	private String memo;
	private Integer zindex;
	private String extension;
	private String colorLinkIDs;
	private String shapeLinkIDs;
	private Integer isElement;
	private String en;
	private String de;
	private String fr;
	private String ja;
	private Integer isSingleCheck;
	private Double occupyFabric;
	private Double price;
	private String affectedAllow;
	private String affectedDisabled;
	private Integer notShowOnFront;
	private String parentFabric;
	private Double dollarPrice;
	private String position;
	private Integer isShow;
	private String allName;

	public String getAllName() {
		return allName;
	}

	public void setAllName(String allName) {
		this.allName = allName;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public Double getDollarPrice() {
		return dollarPrice;
	}

	public void setDollarPrice(Double dollarPrice) {
		this.dollarPrice = dollarPrice;
	}

	public Dict(Integer ID, String name, String extension){
		this.setID(ID);
		this.setName(name);
		this.setParentID(parentID);
		this.setCategoryID(categoryID);
		this.setExtension(extension);
		this.setParentID(0);
		this.setCategoryID(CDictCategory.Version.getID());
	}

	public Dict() {
		
	}

	public Integer getID() {
		return ID;
	}

	public void setID(Integer ID) {
		this.ID = ID;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getCategoryID() {
		return categoryID;
	}

	public void setCategoryID(Integer categoryID) {
		this.categoryID = categoryID;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getExtension() {
		return extension;
	}

	public void setExtension(String extension) {
		this.extension = extension;
	}

	public Integer getSequenceNo() {
		return sequenceNo;
	}

	public void setSequenceNo(Integer sequenceNo) {
		this.sequenceNo = sequenceNo;
	}

	public Integer getParentID() {
		return parentID;
	}

	public void setParentID(Integer parentID) {
		this.parentID = parentID;
	}

	public Integer getStatusID() {
		return statusID;
	}

	public void setStatusID(Integer statusID) {
		this.statusID = statusID;
	}

	public String getConstDefine() {
		return constDefine;
	}

	public void setConstDefine(String constDefine) {
		this.constDefine = constDefine;
	}
	
	public String getEcode() {
		return ecode;
	}

	public void setEcode(String ecode) {
		this.ecode = ecode;
	}
	
	public Integer getExclusionGroupID() {
		return exclusionGroupID;
	}

	public void setExclusionGroupID(Integer exclusionGroupID) {
		this.exclusionGroupID = exclusionGroupID;
	}
	
	public Integer getMediumGroupID() {
		return mediumGroupID;
	}

	public void setMediumGroupID(Integer mediumGroupID) {
		this.mediumGroupID = mediumGroupID;
	}
	
	public Integer getIsDefault() {
		return isDefault;
	}

	public void setIsDefault(Integer isDefault) {
		this.isDefault = isDefault;
	}

	
	public String getBodyType() {
		return bodyType;
	}

	public void setBodyType(String bodyType) {
		this.bodyType = bodyType;
	}
	
	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}
	
	public Integer getZindex() {
		return zindex;
	}
	
	public void setZindex(Integer zindex) {
		this.zindex = zindex;
	}
	
	public String getColorLinkIDs() {
		return colorLinkIDs;
	}
	
	public void setColorLinkIDs(String colorLinkIDs) {
		this.colorLinkIDs = colorLinkIDs;
	}
	
	public String getShapeLinkIDs() {
		return shapeLinkIDs;
	}
	
	public void setShapeLinkIDs(String shapeLinkIDs) {
		this.shapeLinkIDs = shapeLinkIDs;
	}
	
	public Integer getIsElement() {
		return isElement;
	}

	public void setIsElement(Integer isElement) {
		this.isElement = isElement;
	}
	
	public Integer getIsSingleCheck() {
		return isSingleCheck;
	}

	public void setIsSingleCheck(Integer isSingleCheck) {
		this.isSingleCheck = isSingleCheck;
	}
	public Double getOccupyFabric() {
		return occupyFabric;
	}

	public void setOccupyFabric(Double occupyFabric) {
		this.occupyFabric = occupyFabric;
	}
	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}
	
	public String getAffectedAllow() {
		return affectedAllow;
	}

	public void setAffectedAllow(String affectedAllow) {
		this.affectedAllow = affectedAllow;
	}

	public String getAffectedDisabled() {
		return affectedDisabled;
	}

	public void setAffectedDisabled(String affectedDisabled) {
		this.affectedDisabled = affectedDisabled;
	}
	
	public String getParentFabric() {
		return parentFabric;
	}

	public void setParentFabric(String parentFabric) {
		this.parentFabric = parentFabric;
	}
	
	public Integer getNotShowOnFront() {
		return notShowOnFront;
	}

	public void setNotShowOnFront(Integer notShowOnFront) {
		this.notShowOnFront = notShowOnFront;
	}



	public boolean equals(Object obj){
		if(!(obj instanceof Dict))
			return false;
		Dict dict = (Dict)obj;
		return this.ID.equals(dict.getID());
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

	public String getEn() {
		return en;
	}

	public void setEn(String en) {
		this.en = en;
	}

	public String getDe() {
		return de;
	}

	public void setDe(String de) {
		this.de = de;
	}

	public String getFr() {
		return fr;
	}

	public void setFr(String fr) {
		this.fr = fr;
	}

	public String getJa() {
		return ja;
	}

	public void setJa(String ja) {
		this.ja = ja;
	}

	public Integer getIsShow() {
		return isShow;
	}

	public void setIsShow(Integer isShow) {
		this.isShow = isShow;
	}

	@Override
	public String toString() {
		return "Dict [ID=" + ID + ", name=" + name + ", categoryID=" + categoryID + ", code=" + code + ", sequenceNo=" + sequenceNo + ", parentID=" + parentID + ", statusID=" + statusID + ", constDefine=" + constDefine + ", ecode=" + ecode + ", exclusionGroupID=" + exclusionGroupID + ", mediumGroupID=" + mediumGroupID + ", isDefault=" + isDefault + ", bodyType=" + bodyType + ", memo=" + memo + ", zindex=" + zindex + ", extension=" + extension + ", colorLinkIDs=" + colorLinkIDs + ", shapeLinkIDs=" + shapeLinkIDs + ", isElement=" + isElement + ", en=" + en + ", de=" + de + ", fr=" + fr + ", ja=" + ja + ", isSingleCheck=" + isSingleCheck + ", occupyFabric=" + occupyFabric + ", price=" + price + ", affectedAllow=" + affectedAllow + ", affectedDisabled=" + affectedDisabled + ", notShowOnFront=" + notShowOnFront + ", parentFabric=" + parentFabric + ", dollarPrice=" + dollarPrice + ", position=" + position + ", isShow=" + isShow + ", allName=" + allName + "]";
	}
	
}