package chinsoft.entity;

import java.util.List;

public class ClothingBodyType{

	
	private int categoryID;//体型分类
	private String categoryName;//体型分类
	private List<Dict> bodyTypes;//体型信息
	private String clothName;//着装风格  服装名称 
	
	public int getCategoryID() {
		return this.categoryID;
	}

	public void setCategoryID(int categoryID) {
		this.categoryID = categoryID;
	}

	public String getCategoryName() {
		return this.categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public List<Dict> getBodyTypes() {
		return this.bodyTypes;
	}

	public void setBodyTypes(List<Dict> bodyTypes) {
		this.bodyTypes = bodyTypes;
	}

	public String getClothName() {
		return clothName;
	}

	public void setClothName(String clothName) {
		this.clothName = clothName;
	}
	
}
