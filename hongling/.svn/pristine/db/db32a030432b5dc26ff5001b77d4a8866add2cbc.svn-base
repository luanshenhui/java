package chinsoft.tempService;

import java.util.ArrayList;
import java.util.List;

import chinsoft.business.ClothingManager;
import chinsoft.business.DictManager;
import chinsoft.business.SizeManager;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.entity.SizeStandard;

/**
 * 切换尺寸分类时用
 * @author Administrator
 *
 */
public class SizeChangeService {
	private Orden orden;
	private ClothingManager clothingManager = new ClothingManager();
	private SpliceHtmlStr spliceHtmlStr = new SpliceHtmlStr();
	private SizeManager sizeManager = new SizeManager();
	
	public SizeChangeService(){
		
	}
	public SizeChangeService(Orden  orden){
		this.orden = orden;
	}
	
	/**
	 * 亚殴奥码。。。
	 * @return
	 */
	public String getSize_areaHtml(){
		
		return clothingManager.getOrdenSize_areaHtml(orden);
	}
	
	
	public String getSize__spec_partHtml(){
		StringBuffer bodyBuffer = new StringBuffer();
		String[] clothArr;
		switch (orden.getClothingID()) {
		case 1:
			clothArr = new String[] { "3", "2000" };
			break;
		case 2:
			clothArr = new String[] { "3", "2000", "4000" };
			break;
		case 4:
			clothArr = new String[] { "4000", "2000" };
			break;
		case 5:
			clothArr = new String[] { "90000", "2000" };
			break;
		case 6:
			clothArr = new String[] { "3", "4000" };
			break;
		case 7:
			clothArr = new String[] { "95000", "98000" };
			break;
		default:
			clothArr = new String[] { orden.getClothingID().toString() };
			break;
		}
		for(String clothID :clothArr){
			bodyBuffer.append(spliceHtmlStr.getSingleClothSpecialBodyInput(orden, clothID));
		}
		return bodyBuffer.toString();
	}
	
	public String getSize_bodytypeHtml(){
		String tempString = "";
		try {
			tempString = spliceHtmlStr.spliceSizeBodyType(orden);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return tempString;
	}
	
	public String getStyle_titleHtml(){
		
		StringBuffer titleBuffer = new StringBuffer();
		List<Dict> titleList =  DictManager.getDicts(41);
		Integer title;
		if(null == orden.getOrdenID() || "".equals(orden.getOrdenID())){
			title = 20100;
		}
		else if(null != orden && (null == orden.getStyleID() || "".equals(orden.getStyleID())) || orden.getStyleID() == -1){
			title = 20100;
		}
		else{
			title = orden.getStyleID();
		}
		if(!"10052".equals(orden.getSizeCategoryID().toString()) ||
				("2000".equals(orden.getClothingID().toString()) || "3000".equals(orden.getClothingID().toString())
						||"4000".equals(orden.getClothingID().toString())||"5000".equals(orden.getClothingID().toString()))){
			titleList.clear();
		}
		String checked ;
		for(Dict dict: titleList){
			checked = "";
			if(dict.getID() == title || dict.getID().toString().equals(title.toString())){
				checked = "checked = 'true'";
			}else{
				checked = "";
			}
			if(orden != null && "6000".equals(Utility.toSafeString(orden.getClothingID())) && !"20102".equals(Utility.toSafeString(dict.getID()))){
				titleBuffer.append("<label style='display:inline;clear:none;'><input type='radio' "+checked+" name='styleID' value='"+dict.getID()+"'>"+dict.getName()+"</label>");
			}else if(orden != null && !"6000".equals(Utility.toSafeString(orden.getClothingID()))){
				titleBuffer.append("<label style='display:inline;clear:none;'><input type='radio' "+checked+" name='styleID' value='"+dict.getID()+"'>"+dict.getName()+"</label>");
			}else if(orden == null){
				titleBuffer.append("<label style='display:inline;clear:none;'><input type='radio' "+checked+" name='styleID' value='"+dict.getID()+"'>"+dict.getName()+"</label>");
			}
		}
		if(orden != null && "6000".equals(Utility.toSafeString(orden.getClothingID())) && "10052".equals(Utility.toSafeString(orden.getSizeCategoryID()))){
			String arr[]={"0A02","0A01"};
			String checkedDY="";
			String styDY="";
			for(int i=0;i<arr.length;i++){
				checkedDY="";
				//新添加的订单没有布料号 - -!
				if(null != orden.getFabricCode() && !"".equals(orden.getFabricCode())){
					if(arr[i].equals(orden.getStyleDY())){
						checkedDY=" checked='true' ";
					}else if((null == orden.getStyleDY() || "".equals(orden.getStyleDY()))
							&& "0A02".equals(arr[i])){
						checkedDY=" checked='true' ";
					}
					else{
						checkedDY="";
					} 
				}else{
					if("0A02".equals(arr[i])){
						checkedDY=" checked='true' ";
					}
				}
				
				styDY+="<input type='radio' name='styleDY' value='"+arr[i]+"' "+checkedDY+"/>"+ResourceHelper.getValue("DY_"+arr[i]);
			}
			titleBuffer.append(styDY);
		}
		return titleBuffer.toString();
	}
	
	public String getChangeSizeAreaHtml(){
		StringBuffer areaChangeBuffer = new StringBuffer();
		
		String sizepartvalues = orden.getSizePartValues();
		String[] sizeInputArr = (sizepartvalues==null||"".equals(sizepartvalues))?new String[]{}: sizepartvalues.split(",");
		List<OrdenDetail> ordenDetailList = orden.getOrdenDetails()==null?new ArrayList<OrdenDetail>():orden.getOrdenDetails();
		OrdenDetail detail = null;
		for(OrdenDetail ordenDetail :ordenDetailList){
//			if(clothID.equals(ordenDetail.getSingleClothingID().toString())){
//				detail = ordenDetail;
//			}
		}
		
		
		return areaChangeBuffer.toString();
	}
	
	public String getChangeSizeHeightHtml(String height){
		String sizepartvalues = orden.getSizePartValues();
		String[] sizeInputArr = (sizepartvalues==null||"".equals(sizepartvalues))?new String[]{}: sizepartvalues.split(",");
		
		String tempComponentIDs = "";
		if("3000".equals(orden.getClothingID().toString()) && null !=orden.getComponents() && !"".equals(orden.getComponents())){
			if(orden.getComponents().indexOf("3028")>0){//长袖  3028
				tempComponentIDs = "3028";
			}else if(orden.getComponents().indexOf("3029")>0){//短袖3029
				tempComponentIDs = "3029";
			}
		}
		String strSpecChest = "undefined";
		
//		Integer clothID = orden.getClothingID();
//		Integer categoryID = orden.getSizeCategoryID();
//		Integer areaID = orden.getSizeAreaID();
//		Integer  nUnitID = orden.getSizeUnitID();
//		String specHeights = new SizeManager().getSpecHeight(orden.getClothingID(), orden.getSizeAreaID(),tempComponentIDs);
		List<SizeStandard> sizeStandards = new SizeManager().getSizeStandard(
				orden.getClothingID(), orden.getSizeCategoryID(), orden.getSizeAreaID(), height,strSpecChest, orden.getSizeUnitID());
		//根据工艺筛选尺寸
		List<SizeStandard> validSizeStandards = new SizeManager().getValidSizeStandard(sizeStandards,tempComponentIDs);
		sizeStandards = validSizeStandards;
		
		StringBuffer bodyBuffer = new StringBuffer();
		bodyBuffer.append("<div id='part_" + orden.getClothingID()+ "' style='padding-left: 0px;'>");
		bodyBuffer.append("<ul>");
		String requiredParts = "";
		String part_label_ = "part_label_";
		String sizeValue;
		for (SizeStandard sizeStandard : sizeStandards) {
			sizeValue = "";
//			String[] keyValue;
//			for(String size :sizeInputArr){
//				if(size.indexOf(":") <= 0){
//					if("2000".equals(orden.getClothingID().toString()) 
//							&& (10108 == sizeStandard.getPartID() || "10108".equals(sizeStandard.getPartID().toString()))){
//						sizeValue = size;
//					}
//				}else{
//					keyValue = size.split(":");
//					if(keyValue.length>1){
//						if(keyValue[0].equals(sizeStandard.getPartID().toString())){
//							sizeValue = keyValue[1];
//						}
//						//西裤臀围
//					}else if("2000".equals(orden.getClothingID().toString()) && keyValue.length>1 &&
//							(10108 == sizeStandard.getPartID() || "10108".equals(sizeStandard.getPartID().toString()))){
//						sizeValue = keyValue[0];
//					}
//				}
//				
//			}
			Float defaultValue = sizeStandard.getDefaultValue();
			if("".equals(sizeValue) && null!=defaultValue){
				sizeValue = defaultValue.toString();
			}

			String star = "";
			if (null != sizeStandard.getIsRequired() && "10050".equals(sizeStandard.getIsRequired().toString())) {
				if (requiredParts != "") {
					requiredParts += "," + sizeStandard.getPartID();
				} else {
					requiredParts += sizeStandard.getPartID();
				}
				star = " star";
			}
			String readonly = "";
			if (null != sizeStandard.getIsReadonly() && "10050".equals(sizeStandard.getIsReadonly().toString())) {
				readonly = " readonly='yes' style='color:#bbb;'";
			}
			
			bodyBuffer
					.append("<li class='part_label'>"
							+ sizeStandard.getPartName()
							+ "</li><li onclick='$.csSize.showPartMessage(this);' class='part_value"
							+ star + "' title='"
							+ sizeStandard.getSizeFrom() + " - "
							+ sizeStandard.getSizeTo() + "'>");
			
			String tun = "";
			if("2000".equals(orden.getClothingID().toString()) && "part_label_10108".equals(part_label_ + sizeStandard.getPartID())){
				tun = orden.getClothingID().toString();
			}
			bodyBuffer
					.append("<input type='text' "
							+ readonly + " onfocus='$.csSize.playShow("	+ orden.getClothingID()+ ","+ sizeStandard.getSizeCategoryID()+ ","
							+ sizeStandard.getPartID() + ")'onkeyup=$.csSize.onlyNumber(this)  onblur=$.csSize.validatePartRange('"
							+ (part_label_ + sizeStandard.getPartID())
							+ "','" + sizeStandard.getID() + "','"
							+ sizeStandard.getSizeFrom() + "','"
							+ sizeStandard.getSizeTo() + "')" + 
							" value='"+ sizeValue + "' " +
							" id='"	+ (part_label_ + sizeStandard.getPartID())
							+ "' name='" + tun
							+ (part_label_ + sizeStandard.getPartID())
							+ "'/></li>");
		}
	
		bodyBuffer.append("</ul>");
		bodyBuffer.append("</div>");
		return bodyBuffer.toString();
	}
		
}
