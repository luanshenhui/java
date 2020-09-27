package chinsoft.service.orden;

import chinsoft.business.ClothingManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.tempService.SizeChangeService;

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.util.logging.Logger;

public class ChangeSizeCategoryAction extends ActionSupport{
	
	private String changeClothID;
	private String changeOrdenID;
	private String changeSize;
	private String changeSize_unit;
	
	
	private String  size_areaHtml;
	private String size_spec_partHtml;
	private String size_bodytypeHtml;
	private String style_titleHtml;
	
	private String imgHtml;
	
	public String execute(){
		Orden orden = null;
		if(null != changeOrdenID && !"".equals(changeOrdenID)){
			orden = new OrdenManager().getOrdenByID(changeOrdenID);
		}
		
		if(null == orden){
			orden = new Orden();
			//添加页面切换服装分类时默认都是净体的
			orden.setSizeCategoryID(10052);
//			orden.setSizeUnitID(-1);
		}if(("6000".equals(changeClothID) || "5000".equals(changeClothID)) && "10054".equals(orden.getSizeCategoryID().toString())){
			orden.setSizeCategoryID(10052);
		}
		
		//尺寸类别 不同时 录入的尺寸信息清空
		if(null == orden.getSizeCategoryID() || !orden.getSizeCategoryID().toString().equals(changeSize)
				|| null == orden.getSizeUnitID() ||	!orden.getSizeUnitID().toString().equals(changeSize_unit)){
			orden.setSizePartValues("");
		}
		if(null == orden.getSizeAreaID() || "".equals(orden.getSizeAreaID())){
			orden.setSizeAreaID(10201);
			
		}else if("10054".equals(changeSize) && !orden.getSizeCategoryID().toString().equals(changeSize)){
			//默认英美码
			orden.setSizeAreaID(10201);
			orden.setSizePartValues("");
		}

		
		orden.setSizeCategoryID(Utility.toSafeInt(changeSize));
		orden.setClothingID(Utility.toSafeInt(changeClothID));
		orden.setSizeUnitID(Utility.toSafeInt(changeSize_unit));
	
		SizeChangeService sizeChangeService = new SizeChangeService(orden);
		
		try {
			size_areaHtml = sizeChangeService.getSize_areaHtml();
			size_spec_partHtml = sizeChangeService.getSize__spec_partHtml();
			size_bodytypeHtml = sizeChangeService.getSize_bodytypeHtml();
			style_titleHtml = sizeChangeService.getStyle_titleHtml();
			imgHtml = new ClothingManager().showImg(orden);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return SUCCESS;
	}

	public String getChangeClothID() {
		return changeClothID;
	}

	public void setChangeClothID(String changeClothID) {
		this.changeClothID = changeClothID;
	}

	public String getChangeOrdenID() {
		return changeOrdenID;
	}

	public void setChangeOrdenID(String changeOrdenID) {
		this.changeOrdenID = changeOrdenID;
	}

	public String getChangeSize_unit() {
		return changeSize_unit;
	}

	public void setChangeSize_unit(String changeSize_unit) {
		this.changeSize_unit = changeSize_unit;
	}

	public String getSize_areaHtml() {
		return size_areaHtml;
	}

	public void setSize_areaHtml(String size_areaHtml) {
		this.size_areaHtml = size_areaHtml;
	}

	public String getSize_spec_partHtml() {
		return size_spec_partHtml;
	}

	public void setSize_spec_partHtml(String size_spec_partHtml) {
		this.size_spec_partHtml = size_spec_partHtml;
	}

	public String getSize_bodytypeHtml() {
		return size_bodytypeHtml;
	}

	public void setSize_bodytypeHtml(String size_bodytypeHtml) {
		this.size_bodytypeHtml = size_bodytypeHtml;
	}

	public String getStyle_titleHtml() {
		return style_titleHtml;
	}

	public void setStyle_titleHtml(String style_titleHtml) {
		this.style_titleHtml = style_titleHtml;
	}

	public String getChangeSize() {
		return changeSize;
	}

	public void setChangeSize(String changeSize) {
		this.changeSize = changeSize;
	}

	public String getImgHtml() {
		return imgHtml;
	}

	public void setImgHtml(String imgHtml) {
		this.imgHtml = imgHtml;
	}
	
	
}
