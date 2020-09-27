package chinsoft.entity;

import java.util.List;

public class OrdenDetail implements java.io.Serializable {
	
	private static final long serialVersionUID = 6932067693255985373L;
	private String ID;
	private String ordenID;
	private Integer singleClothingID;
	private String singleClothingName;
	private Integer amount;
	private Double cmtPrice;
	private Double fabricPrice;
	private Double processPrice;
	private String specChest ;
	private String specHeight;
	private Double fabricAmount;
	private String singleComponents;
	private String singleEmbroiderys;
	private List<Embroidery> emberoidery;

	public String getSingleEmbroiderys() {
		return singleEmbroiderys;
	}

	public void setSingleEmbroiderys(String singleEmbroiderys) {
		this.singleEmbroiderys = singleEmbroiderys;
	}

	public Double getFabricAmount() {
		return fabricAmount;
	}

	public void setFabricAmount(Double fabricAmount) {
		this.fabricAmount = fabricAmount;
	}

	public String getSpecChest() {
		return specChest;
	}

	public void setSpecChest(String specChest) {
		this.specChest = specChest;
	}

	public String getSpecHeight() {
		return specHeight;
	}

	public void setSpecHeight(String specHeight) {
		this.specHeight = specHeight;
	}

	
	
	public String getID() {
		return ID;
	}
	
	public void setID(String ID) {
		this.ID = ID;
	}   
	
	public String getOrdenID() {
		return ordenID;
	}

	public void setOrdenID(String ordenID) {
		this.ordenID = ordenID;
	}

	public Integer getSingleClothingID() {
		return singleClothingID;
	}

	public void setSingleClothingID(Integer singleClothingID) {
		this.singleClothingID = singleClothingID;
	}
	
	public String getSingleClothingName() {
		return singleClothingName;
	}

	public void setSingleClothingName(String singleClothingName) {
		this.singleClothingName = singleClothingName;
	}
	
	public String getSingleComponents() {
		return singleComponents;
	}

	public void setSingleComponents(String singleComponents) {
		this.singleComponents = singleComponents;
	}

	public Integer getAmount() {
		return amount;
	}

	public void setAmount(Integer amount) {
		this.amount = amount;
	}

	public Double getCmtPrice() {
		return cmtPrice;
	}

	public void setCmtPrice(Double cmtPrice) {
		this.cmtPrice = cmtPrice;
	}

	public Double getFabricPrice() {
		return fabricPrice;
	}

	public void setFabricPrice(Double fabricPrice) {
		this.fabricPrice = fabricPrice;
	}

	public Double getProcessPrice() {
		return processPrice;
	}

	public void setProcessPrice(Double processPrice) {
		this.processPrice = processPrice;
	}

	public List<Embroidery> getEmberoidery() {
		return emberoidery;
	}

	public void setEmberoidery(List<Embroidery> emberoidery) {
		this.emberoidery = emberoidery;
	}
}