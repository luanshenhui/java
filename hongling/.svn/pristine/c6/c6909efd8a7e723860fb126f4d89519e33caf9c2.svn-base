package chinsoft.service.orden;

import chinsoft.business.OrdenManager;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.tempService.ClothingChangeService;
import chinsoft.tempService.SizeChangeService;

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.util.logging.Logger;
public class ChangeSizeInfoAction extends ActionSupport{
	private String changeOrdenID;
	private String changeClothID;
	private String changeSize_category;
	private String changeSize_unit;
	private String changeSize_area;
	private String changeSize_height;
	
	private String size_areaHtml;
	private String size_spec_partHtml;
	private String size_spec_part2Html;
	private String size_heightHtml;

	
	public String changeUnit(){
		Orden orden = new Orden();
		if(null != changeOrdenID && !"".equals(changeOrdenID)){
			orden = new OrdenManager().getOrdenByID(changeOrdenID);
		}
		if(null == orden){
			orden = new Orden();
		}
		
		if(null == orden.getSizeUnitID() || !orden.getSizeUnitID().toString().equals(changeSize_unit)
				|| null == orden.getSizeCategoryID() || !orden.getSizeCategoryID().toString().equals(changeSize_category)){
			orden.setSizePartValues("");
		}
		
		orden.setSizeAreaID(10201);
		orden.setClothingID(Utility.toSafeInt(changeClothID));
		orden.setSizeCategoryID(Utility.toSafeInt(changeSize_category));
		orden.setSizeUnitID(Utility.toSafeInt(changeSize_unit));
		
		SizeChangeService sizeChangeService = new SizeChangeService(orden);
		try {
			size_areaHtml = sizeChangeService.getSize_areaHtml(); 
			size_spec_partHtml = sizeChangeService.getSize__spec_partHtml();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return SUCCESS;
	}
	
	public String changeArea(){
		Orden orden = new Orden();
		if(null != changeOrdenID && !"".equals(changeOrdenID)){
			orden = new OrdenManager().getOrdenByID(changeOrdenID);
		}
		if(null == orden){
			orden = new Orden();
		}
		
		if(null == orden.getSizeUnitID() || !orden.getSizeUnitID().toString().equals(changeSize_unit)
				|| null == orden.getSizeCategoryID() || !orden.getSizeCategoryID().toString().equals(changeSize_category)
				|| null == orden.getSizeAreaID() || !orden.getSizeAreaID().toString().equals(changeSize_area)){
			orden.setSizePartValues("");
		}
		
		orden.setClothingID(Utility.toSafeInt(changeClothID));
		orden.setSizeCategoryID(Utility.toSafeInt(changeSize_category));
		orden.setSizeUnitID(Utility.toSafeInt(changeSize_unit));
		orden.setSizeAreaID(Utility.toSafeInt(changeSize_area));
		
		
		SizeChangeService sizeChangeService = new SizeChangeService(orden);
		size_spec_partHtml = sizeChangeService.getSize__spec_partHtml();
		return SUCCESS;
	}
	
	public String changeHeight(){
		Orden orden = new Orden();
		if(null != changeOrdenID && !"".equals(changeOrdenID)){
			orden = new OrdenManager().getOrdenByID(changeOrdenID);
		}
		if(null == orden){
			orden = new Orden();
		}
		if(null == orden.getSizeUnitID() || !orden.getSizeUnitID().toString().equals(changeSize_unit)
				|| null == orden.getSizeCategoryID() || !orden.getSizeCategoryID().toString().equals(changeSize_category)){
			orden.setSizePartValues("");
		}
		
		orden.setClothingID(Utility.toSafeInt(changeClothID));
		orden.setSizeCategoryID(Utility.toSafeInt(changeSize_category));
		orden.setSizeUnitID(Utility.toSafeInt(changeSize_unit));
		orden.setSizeAreaID(Utility.toSafeInt(changeSize_area));
		
		SizeChangeService sizeChangeService = new SizeChangeService(orden);
		
		try {
			size_heightHtml = sizeChangeService.getChangeSizeHeightHtml(changeSize_height);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return SUCCESS;
	}

	public String getChangeOrdenID() {
		return changeOrdenID;
	}

	public void setChangeOrdenID(String changeOrdenID) {
		this.changeOrdenID = changeOrdenID;
	}

	public String getChangeClothID() {
		return changeClothID;
	}

	public void setChangeClothID(String changeClothID) {
		this.changeClothID = changeClothID;
	}

	public String getChangeSize_category() {
		return changeSize_category;
	}

	public void setChangeSize_category(String changeSize_category) {
		this.changeSize_category = changeSize_category;
	}

	public String getChangeSize_unit() {
		return changeSize_unit;
	}

	public void setChangeSize_unit(String changeSize_unit) {
		this.changeSize_unit = changeSize_unit;
	}

	public String getChangeSize_height() {
		return changeSize_height;
	}

	public void setChangeSize_height(String changeSize_height) {
		this.changeSize_height = changeSize_height;
	}

	public String getSize_spec_partHtml() {
		return size_spec_partHtml;
	}

	public void setSize_spec_partHtml(String size_spec_partHtml) {
		this.size_spec_partHtml = size_spec_partHtml;
	}

	public String getSize_heightHtml() {
		return size_heightHtml;
	}

	public void setSize_heightHtml(String size_heightHtml) {
		this.size_heightHtml = size_heightHtml;
	}

	public String getChangeSize_area() {
		return changeSize_area;
	}

	public void setChangeSize_area(String changeSize_area) {
		this.changeSize_area = changeSize_area;
	}

	public String getSize_areaHtml() {
		return size_areaHtml;
	}

	public void setSize_areaHtml(String size_areaHtml) {
		this.size_areaHtml = size_areaHtml;
	}

	public String getSize_spec_part2Html() {
		return size_spec_part2Html;
	}

	public void setSize_spec_part2Html(String size_spec_part2Html) {
		this.size_spec_part2Html = size_spec_part2Html;
	}
	
}
