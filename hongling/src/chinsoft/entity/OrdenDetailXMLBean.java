package chinsoft.entity;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

@XmlAccessorType(XmlAccessType.FIELD)
public class OrdenDetailXMLBean {
	@XmlElement(name="Model")
	private String model;
	@XmlElement(name="Categories")
	private String categories;
	@XmlElement(name="InterliningType")
	private String interliningType;
	@XmlElement(name="Quantity")
	private String quantity;
	@XmlElement(name="VersionStyle")
	private String versionStyle;
	@XmlElement(name="ClothingStyle")
	private String clothingStyle;
	@XmlElement(name="ClothingSize")
	private String clothingSize;
	@XmlElement(name="OrdersProcess")
	private String ordersProcess;
	
	@XmlElement(name="Embroidery")
	private String embroidery;
	
	@XmlElement(name="Price")
	private String price;
	@XmlElement(name="StyleNum")
	private String styleNum;
	
	@XmlElement(name="Edition")
	private String edition;

	public String getModel() {
		return model;
	}

	public void setModel(String model) {
		this.model = model;
	}

	public String getCategories() {
		return categories;
	}

	public void setCategories(String categories) {
		this.categories = categories;
	}

	public String getInterliningType() {
		return interliningType;
	}

	public void setInterliningType(String interliningType) {
		this.interliningType = interliningType;
	}

	public String getQuantity() {
		return quantity;
	}

	public void setQuantity(String quantity) {
		this.quantity = quantity;
	}

	public String getVersionStyle() {
		return versionStyle;
	}

	public void setVersionStyle(String versionStyle) {
		this.versionStyle = versionStyle;
	}

	public String getClothingStyle() {
		return clothingStyle;
	}

	public void setClothingStyle(String clothingStyle) {
		this.clothingStyle = clothingStyle;
	}

	public String getClothingSize() {
		return clothingSize;
	}

	public void setClothingSize(String clothingSize) {
		this.clothingSize = clothingSize;
	}

	public String getOrdersProcess() {
		return ordersProcess;
	}

	public void setOrdersProcess(String ordersProcess) {
		this.ordersProcess = ordersProcess;
	}

	public String getEmbroidery() {
		return embroidery;
	}

	public void setEmbroidery(String embroidery) {
		this.embroidery = embroidery;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getStyleNum() {
		return styleNum;
	}

	public void setStyleNum(String styleNum) {
		this.styleNum = styleNum;
	}

	public String getEdition() {
		return edition;
	}

	public void setEdition(String edition) {
		this.edition = edition;
	}

}
