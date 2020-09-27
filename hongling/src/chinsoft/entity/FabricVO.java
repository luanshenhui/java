package chinsoft.entity;


public class FabricVO {

	private Integer id;
	private String code;
	private String categoryName;
	private Integer fabricSupplyCategoryID;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public Integer getFabricSupplyCategoryID() {
		return fabricSupplyCategoryID;
	}
	public void setFabricSupplyCategoryID(Integer fabricSupplyCategoryID) {
		this.fabricSupplyCategoryID = fabricSupplyCategoryID;
	}
	@Override
	public String toString() {
		return "FabricVO [id=" + id + ", code=" + code + ", categoryName=" + categoryName + ", fabricSupplyCategoryID=" + fabricSupplyCategoryID + "]";
	}
	
	
}
