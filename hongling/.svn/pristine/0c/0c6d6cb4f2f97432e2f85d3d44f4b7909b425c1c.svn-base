package chinsoft.service.orden;

import chinsoft.business.ClothingManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.tempService.ClothingChangeService;

import com.opensymphony.xwork2.ActionSupport;

public class ChangeClothingAction extends ActionSupport{
	
	private String changeClothID;
	private String changeOrdenID;
	private String size_category;
	private String size_unit;
	
	private String fabricCode;
	private Double fabricInventory;
	private String fabricInventoryHtml;
	/**工艺信息*/
	private String processHtml;
	/**刺绣 信息*/
	private String embroideryHtml;
	/**尺寸分类信息*/
	private String size_categoryHtml;
	/**欧亚美码*/
	private String size_areaHtml;
	/**尺寸的录入信息*/
	private String size_inputHtml;
	/**特体信息和着装风格*/
	private String bodyTypeHtml;
	/**长短款 套不套西服*/
	private String titleHtml;
	/**图X*/
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
			if(null!=changeOrdenID && "5000".equals(changeClothID)){
				orden.setSizeCategoryID(10053);
			}
		}
		if(("6000".equals(changeClothID) || "5000".equals(changeClothID)) && "10054".equals(orden.getSizeCategoryID().toString())){
			orden.setSizeCategoryID(10052);
		}
		
		//尺寸类别 不同时 录入的尺寸信息清空
		if(null == orden.getSizeUnitID() ||	!orden.getSizeUnitID().toString().equals(size_unit)){
			orden.setSizePartValues("");
		}
		orden.setSizeUnitID(Integer.parseInt(size_unit));
		if(null == orden.getSizeAreaID() || "".equals(orden.getSizeAreaID())){
			orden.setSizeAreaID(10201);
			
		}else if("10054".equals(size_category) && !orden.getSizeCategoryID().toString().equals(size_category)){
			//默认英美码
			orden.setSizeAreaID(10201);
			orden.setSizePartValues("");
		}
		
		orden.setClothingID(Utility.toSafeInt(changeClothID));
		ClothingChangeService clothingChangeService = new ClothingChangeService(orden);
		
		fabricInventory = 0.0;
		//编辑和复制信息时订单有面料信息
		if(null != orden.getFabricCode() && !"".equals(orden.getFabricCode())){
			fabricInventory =clothingChangeService.getFabricInventory();
			fabricCode = orden.getFabricCode();
			//如果订单中没有保存 托管信息
			if(null != orden.getAutoID() && !"".equals(orden.getAutoID())){
				orden.setAutoID(100);
			}
			if(0.0==fabricInventory){
				//库存
				fabricInventoryHtml =  new ClothingManager().getFabric_resultHtml(orden);
			}else{
				//托管
				fabricInventoryHtml = new ClothingManager().getAutoContainerHtml(orden);
			}
		}
		try {
			processHtml = clothingChangeService.getProcessHtml();
//			if(!"5".equals(changeClothID) && !"90000".equals(changeClothID) && 
//					!"95000".equals(changeClothID) && !"98000".equals(changeClothID)
//					&& !"7".equals(changeClothID)){
			if(!"5".equals(changeClothID) && !"90000".equals(changeClothID)){
				embroideryHtml = clothingChangeService.getEmbroidsHtml(orden);
			}
			size_categoryHtml = clothingChangeService.getSize_cateGoryHtml();
		
			size_areaHtml = clothingChangeService.getSize_areaHtml();
			size_inputHtml = clothingChangeService.getSize_inputHtml();
			titleHtml = clothingChangeService.getSize_titleHtml();
			bodyTypeHtml = clothingChangeService.getSize_bodyTypeHtml();
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
	public String getProcessHtml() {
		return processHtml;
	}
	public void setProcessHtml(String processHtml) {
		this.processHtml = processHtml;
	}
	public String getEmbroideryHtml() {
		return embroideryHtml;
	}
	public void setEmbroideryHtml(String embroideryHtml) {
		this.embroideryHtml = embroideryHtml;
	}
	public String getSize_categoryHtml() {
		return size_categoryHtml;
	}
	public void setSize_categoryHtml(String size_categoryHtml) {
		this.size_categoryHtml = size_categoryHtml;
	}
	public String getSize_inputHtml() {
		return size_inputHtml;
	}
	public void setSize_inputHtml(String size_inputHtml) {
		this.size_inputHtml = size_inputHtml;
	}
	public String getBodyTypeHtml() {
		return bodyTypeHtml;
	}
	public void setBodyTypeHtml(String bodyTypeHtml) {
		this.bodyTypeHtml = bodyTypeHtml;
	}
	public String getSize_areaHtml() {
		return size_areaHtml;
	}
	public void setSize_areaHtml(String size_areaHtml) {
		this.size_areaHtml = size_areaHtml;
	}
	public String getTitleHtml() {
		return titleHtml;
	}
	public void setTitleHtml(String titleHtml) {
		this.titleHtml = titleHtml;
	}
	
	public String getFabricCode() {
		return fabricCode;
	}
	public void setFabricCode(String fabricCode) {
		this.fabricCode = fabricCode;
	}
	public Double getFabricInventory() {
		return fabricInventory;
	}
	public void setFabricInventory(Double fabricInventory) {
		this.fabricInventory = fabricInventory;
	}
	public String getFabricInventoryHtml() {
		return fabricInventoryHtml;
	}
	public void setFabricInventoryHtml(String fabricInventoryHtml) {
		this.fabricInventoryHtml = fabricInventoryHtml;
	}
	public String getImgHtml() {
		return imgHtml;
	}
	public void setImgHtml(String imgHtml) {
		this.imgHtml = imgHtml;
	}
	public String getSize_category() {
		return size_category;
	}
	public void setSize_category(String size_category) {
		this.size_category = size_category;
	}
	public String getSize_unit() {
		return size_unit;
	}
	public void setSize_unit(String size_unit) {
		this.size_unit = size_unit;
	}
	
	
	
}
