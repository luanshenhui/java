package chinsoft.entity;


public class Fabric implements java.io.Serializable  {
	/**
	 * 
	 */
	private static final long serialVersionUID = 5884511910359063074L;
	private Integer ID;
	private String code;
	private Double weight;
	private Double price;
	private Integer seriesID;
	private String seriesName;
	private Integer colorID;
	private String colorName;
	private Integer flowerID;
	private String flowerName;
	private Integer compositionID;
	private String compositionName;
	private Integer categoryID;
	private String categoryName;
	private Integer isStop;
	private String isStopName;
	private Double inventory;
	private String fabricSupplyID;//Member ID
	private String fabricSupplyCode;
	private Integer fabricSupplyCategoryID;
	private String fabricSupplyCategoryName;
	private String shaZhi;
	private Double dollarPrice;
	private Integer sequenceNo;
	private String fabricPrice;
	private String vseriesID;
	private Integer vcolorID;
	private String vcolorName;
	private Integer vflowerID;
	private String vflowerName;
	private Integer vcompositionID;
	private String vcompositionName;
	private String owners;

	public Double getDollarPrice() {
		return dollarPrice;
	}

	public void setDollarPrice(Double dollarPrice) {
		this.dollarPrice = dollarPrice;
	}

	public Integer getID() {
		return ID;
	}

	public void setID(Integer ID) {
		this.ID = ID;
	}

	public String getCode() {
		return code;
	}
	
	public void setCode(String code) {
		this.code = code;
	}
	
	public Double getWeight() {
		return weight;
	}
	public void setWeight(Double weight) {
		this.weight = weight;
	}
	public Double getPrice() {
		return price;
	}
	public void setPrice(Double price) {
		this.price = price;
	}
	public Integer getSeriesID() {
		return seriesID;
	}
	public void setSeriesID(Integer seriesID) {
		this.seriesID = seriesID;
	}
	public Integer getColorID() {
		return colorID;
	}
	public void setColorID(Integer colorID) {
		this.colorID = colorID;
	}
	public Integer getFlowerID() {
		return flowerID;
	}
	public void setFlowerID(Integer flowerID) {
		this.flowerID = flowerID;
	}
	public Integer getCompositionID() {
		return compositionID;
	}
	public void setCompositionID(Integer compositionID) {
		this.compositionID = compositionID;
	}
	public Integer getCategoryID() {
		return categoryID;
	}
	public void setCategoryID(Integer categoryID) {
		this.categoryID = categoryID;
	}


	public String getSeriesName() {
		return seriesName;
	}


	public void setSeriesName(String seriesName) {
		this.seriesName = seriesName;
	}


	public String getColorName() {
		return colorName;
	}


	public void setColorName(String colorName) {
		this.colorName = colorName;
	}


	public String getFlowerName() {
		return flowerName;
	}


	public void setFlowerName(String flowerName) {
		this.flowerName = flowerName;
	}


	public String getCompositionName() {
		return compositionName;
	}


	public void setCompositionName(String compositionName) {
		this.compositionName = compositionName;
	}


	public String getCategoryName() {
		return categoryName;
	}


	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public Integer getIsStop() {
		return isStop;
	}

	public void setIsStop(Integer isStop) {
		this.isStop = isStop;
	}
	
	public String getIsStopName() {
		return isStopName;
	}

	public void setIsStopName(String isStopName) {
		this.isStopName = isStopName;
	}

	public Double getInventory() {
		return inventory;
	}

	public void setInventory(Double inventory) {
		this.inventory = inventory;
	}

	public String getFabricSupplyID() {
		return fabricSupplyID;
	}

	public void setFabricSupplyID(String fabricSupplyID) {
		this.fabricSupplyID = fabricSupplyID;
	}

	public String getFabricSupplyCode() {
		return fabricSupplyCode;
	}

	public void setFabricSupplyCode(String fabricSupplyCode) {
		this.fabricSupplyCode = fabricSupplyCode;
	}

	public Integer getFabricSupplyCategoryID() {
		return fabricSupplyCategoryID;
	}

	public void setFabricSupplyCategoryID(Integer fabricSupplyCategoryID) {
		this.fabricSupplyCategoryID = fabricSupplyCategoryID;
	}

	public String getFabricSupplyCategoryName() {
		return fabricSupplyCategoryName;
	}

	public void setFabricSupplyCategoryName(String fabricSupplyCategoryName) {
		this.fabricSupplyCategoryName = fabricSupplyCategoryName;
	}
	
	public String getShaZhi() {
		return shaZhi;
	}

	public void setShaZhi(String shaZhi) {
		this.shaZhi = shaZhi;
	}

	public Integer getSequenceNo() {
		return sequenceNo;
	}

	public void setSequenceNo(Integer sequenceNo) {
		this.sequenceNo = sequenceNo;
	}

	public String getFabricPrice() {
		return fabricPrice;
	}

	public void setFabricPrice(String fabricPrice) {
		this.fabricPrice = fabricPrice;
	}

	public String getVseriesID() {
		return vseriesID;
	}

	public void setVseriesID(String vseriesID) {
		this.vseriesID = vseriesID;
	}

	public Integer getVcolorID() {
		return vcolorID;
	}

	public void setVcolorID(Integer vcolorID) {
		this.vcolorID = vcolorID;
	}

	public Integer getVflowerID() {
		return vflowerID;
	}

	public void setVflowerID(Integer vflowerID) {
		this.vflowerID = vflowerID;
	}

	public Integer getVcompositionID() {
		return vcompositionID;
	}

	public void setVcompositionID(Integer vcompositionID) {
		this.vcompositionID = vcompositionID;
	}

	public String getVcompositionName() {
		return vcompositionName;
	}

	public void setVcompositionName(String vcompositionName) {
		this.vcompositionName = vcompositionName;
	}

	public String getVcolorName() {
		return vcolorName;
	}

	public void setVcolorName(String vcolorName) {
		this.vcolorName = vcolorName;
	}

	public String getVflowerName() {
		return vflowerName;
	}

	public void setVflowerName(String vflowerName) {
		this.vflowerName = vflowerName;
	}

	@Override
	public String toString() {
		return "Fabric [ID=" + ID + ", code=" + code + ", weight=" + weight + ", price=" + price + ", seriesID=" + seriesID + ", seriesName=" + seriesName + ", colorID=" + colorID + ", colorName=" + colorName + ", flowerID=" + flowerID + ", flowerName=" + flowerName + ", compositionID=" + compositionID + ", compositionName=" + compositionName + ", categoryID=" + categoryID + ", categoryName=" + categoryName + ", isStop=" + isStop + ", isStopName=" + isStopName + ", inventory=" + inventory + ", fabricSupplyID=" + fabricSupplyID + ", fabricSupplyCode=" + fabricSupplyCode + ", fabricSupplyCategoryID=" + fabricSupplyCategoryID + ", fabricSupplyCategoryName=" + fabricSupplyCategoryName + ", shaZhi=" + shaZhi + ", dollarPrice=" + dollarPrice + ", sequenceNo=" + sequenceNo + ", fabricPrice=" + fabricPrice + ", vseriesID=" + vseriesID + ", vcolorID=" + vcolorID + ", vflowerID=" + vflowerID +", vcompositionID=" + vcompositionID + ", vcompositionName=" + vcompositionName+ ", vcolorName=" + vcolorName+ ", vflowerName=" + vflowerName+ "]";
	}

	public String getOwners() {
		return owners;
	}

	public void setOwners(String owners) {
		this.owners = owners;
	}
	
}
