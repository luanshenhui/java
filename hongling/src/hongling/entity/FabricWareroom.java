package hongling.entity;

import java.sql.Timestamp;
import java.util.Date;

import chinsoft.entity.Dict;

public class FabricWareroom {
	private Integer id;
	private String fabricNo;
	private Integer category;
	private String shazhi;
	private Integer flower;
	private Integer color;
	private Double weight;
	private Integer composition;
	private Double rmb;
	private Double dollar;
	private String property;
	private String brands;
	private String address;
	private String belong;
	private Integer status;
	private Double stock;
	private String createBy;
	private Date createTime;
	private String closeBy;
	private Timestamp closeTime;
	private String categoryName;
	private String flowerName;
	private String compositionName;
	private String colorName;
	private FabricTrader fabricTrader;
	private String propertyName;
	
	private Dict dict;
	
	public Dict getDict() {
		return dict;
	}

	public void setDict(Dict dict) {
		this.dict = dict;
	}

	public FabricWareroom() {
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getFabricNo() {
		return fabricNo;
	}

	public void setFabricNo(String fabricNo) {
		this.fabricNo = fabricNo;
	}

	public Integer getCategory() {
		return category;
	}

	public void setCategory(Integer category) {
		this.category = category;
	}

	public String getShazhi() {
		return shazhi;
	}

	public void setShazhi(String shazhi) {
		this.shazhi = shazhi;
	}

	public Integer getFlower() {
		return flower;
	}

	public void setFlower(Integer flower) {
		this.flower = flower;
	}

	public Integer getColor() {
		return color;
	}

	public void setColor(Integer color) {
		this.color = color;
	}

	public Double getWeight() {
		return weight;
	}

	public void setWeight(Double weight) {
		this.weight = weight;
	}

	public Integer getComposition() {
		return composition;
	}

	public void setComposition(Integer composition) {
		this.composition = composition;
	}

	public Double getRmb() {
		return rmb;
	}

	public void setRmb(Double rmb) {
		this.rmb = rmb;
	}

	public Double getDollar() {
		return dollar;
	}

	public void setDollar(Double dollar) {
		this.dollar = dollar;
	}

	public String getProperty() {
		return property;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public String getBrands() {
		return brands;
	}

	public void setBrands(String brands) {
		this.brands = brands;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getBelong() {
		return belong;
	}

	public void setBelong(String belong) {
		this.belong = belong;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Double getStock() {
		return stock;
	}

	public void setStock(Double stock) {
		this.stock = stock;
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

	public String getCloseBy() {
		return closeBy;
	}

	public void setCloseBy(String closeBy) {
		this.closeBy = closeBy;
	}

	public Timestamp getCloseTime() {
		return closeTime;
	}

	public void setCloseTime(Timestamp closeTime) {
		this.closeTime = closeTime;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
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

	public String getColorName() {
		return colorName;
	}

	public void setColorName(String colorName) {
		this.colorName = colorName;
	}

	public FabricTrader getFabricTrader() {
		return fabricTrader;
	}

	public void setFabricTrader(FabricTrader fabricTrader) {
		this.fabricTrader = fabricTrader;
	}

	public String getPropertyName() {
		return propertyName;
	}

	public void setPropertyName(String propertyName) {
		this.propertyName = propertyName;
	}
	
	
}
