package chinsoft.tempService;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import chinsoft.business.DictManager;
import chinsoft.business.OrdenManager;
import chinsoft.business.SizeManager;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.ClothingBodyType;
import chinsoft.entity.Dict;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.entity.SizeStandard;

/**
 * 初始化订单添加和编辑用
 * @author Administrator
 *
 */
public class SpliceHtmlStr {
	private SizeManager sizeManager = new SizeManager();
	private DictManager dictManager = new DictManager();
	public SpliceHtmlStr(){
		
	}
	/**
	 * 尺寸录入信息
	 * 初始默认二件套的净体
	 * @return
	 */
	public String spliceBody(){
		StringBuffer bodyBuffer = new StringBuffer();
		Integer[] singleClothings  = new Integer[]{3,2000};
		for(Integer clothID : singleClothings){
			Integer nSingleClothingID = clothID;
			Integer nSizeCategoryID = 10052;
			Integer nAreaID = -1;
			String strSpecHeight = "undefined";
			String strSpecChest = "undefined";
			
			Integer  nUnitID = null;
			HttpServletRequest request = ServletActionContext.getRequest();
			String path = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ request.getContextPath();
			
			
//			if(path.indexOf("127.0.0.1")>0  || path.indexOf("localhost")>0){//测试用 本地
			if(path.indexOf("us.rcmtm.com") > 0 || path.indexOf("172.17.4.5") > 0) {
				// 美州区默认是  默认英寸的
				nUnitID = 10265;
			}else{
				//默认厘米的
				nUnitID = 10266;
			}
			
			List<SizeStandard> sizeStandards = new SizeManager().getSizeStandard(nSingleClothingID, nSizeCategoryID, nAreaID, strSpecHeight,strSpecChest, nUnitID);
			bodyBuffer.append("<div>" + dictManager.getDictByID(clothID).getName() + "</div>");
			bodyBuffer.append("<div id='spec_" + clothID + "'></div>");
			bodyBuffer.append("<div id='part_" + clothID+ "' style='padding-left: 0px;'>");
			bodyBuffer.append("<ul>");
			String requiredParts = "";
			String part_label_ = "part_label_";
			for (SizeStandard sizeStandard : sizeStandards) {
				Float defaultValue = sizeStandard.getDefaultValue();
				if (defaultValue == null) {
					defaultValue = 0F;
				}
				String star = "";
				if (null != sizeStandard.getIsRequired() && 10050 == sizeStandard.getIsRequired()) {
					if (requiredParts != "") {
						requiredParts += "," + sizeStandard.getPartID();
					} else {
						requiredParts += sizeStandard.getPartID();
					}
					star = " star";
				}
				String readonly = "";
				if (null != sizeStandard.getIsReadonly() && 10050 == sizeStandard.getIsReadonly()) {
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
				if(clothID==2000 && "part_label_10108".equals(part_label_ + sizeStandard.getPartID())){
					tun = clothID.toString();
				}
				bodyBuffer
						.append("<input type='text' "
								+ readonly + " onfocus='$.csSize.playShow("	+ clothID+ ","+ sizeStandard.getSizeCategoryID()+ ","
								+ sizeStandard.getPartID() + ")'onkeyup=$.csSize.onlyNumber(this)  onblur=$.csSize.validatePartRange('"
								+ (part_label_ + sizeStandard.getPartID())
								+ "','" + sizeStandard.getID() + "','"
								+ sizeStandard.getSizeFrom() + "','"
								+ sizeStandard.getSizeTo() + "')" + 
//										" value='"
//								+ defaultValue + "' " +
										" id='"
								+ (part_label_ + sizeStandard.getPartID())
								+ "' name='" + tun
								+ (part_label_ + sizeStandard.getPartID())
								+ "'/></li>");
			}
			bodyBuffer.append("</ul>");
			bodyBuffer.append("</div>");
			
		}
		return bodyBuffer.toString();
	}

	
	/**
	 * 编辑尺寸 标准号
	 * @param orden
	 * @return
	 */
	public String spliceSizes(Orden orden){
		StringBuffer sizesBuffer = new StringBuffer();
		
		
		return sizesBuffer.toString();
	}
	
	/**
	 * 尺寸的勾选信息
	 * 订单号为Null初始化
	 * @return
	 */
	public String spliceBodytype(){
		StringBuffer bodyTypeBuffer = new StringBuffer();
		Integer clothID = 1;
		Integer[] singleClothings  = new Integer[]{3,2000};
		
		List<ClothingBodyType> bodyTypeList = sizeManager.getClotingBodyType(1,10052);
		for(int i =0 ;i< bodyTypeList.size() ;i ++){
			if(32 != bodyTypeList.get(i).getCategoryID()){
				List<Dict> typeList =  bodyTypeList.get(i).getBodyTypes();
				if(null != typeList && !typeList.isEmpty()){
					if (i == bodyTypeList.size() - 1) {
						bodyTypeBuffer.append("<ul id='clothing_style' class='hline'>");
					} else {
						bodyTypeBuffer.append("<ul class='hline'>");
					}
					bodyTypeBuffer.append("<li style='width:620px;clear:both;'>" + bodyTypeList.get(i).getCategoryName() + "</li>");
					for(int j = 0;j<typeList.size() ;j++){
						bodyTypeBuffer.append("<li><label><input type='checkbox' ");
						if (10284 == typeList.get(j).getID() || 10368 == typeList.get(j).getID()) {
							bodyTypeBuffer.append("checked='true' ");
						} else if (j == 0 && i < bodyTypeList.size() - 1) {
							bodyTypeBuffer.append("checked='true' ");
						}
						bodyTypeBuffer.append("  name='body_type_" + bodyTypeList.get(i).getCategoryID() + "' value='" + typeList.get(j).getID() + "' onclick='$.csControl.checkOnce(this);'  onfocus='$.csSize.playShow(-1,$.csControl.getRadioValue(\"size_category\")," + typeList.get(j).getID()+ ");'/> " + typeList.get(j).getName() + "</label></li>");
					}
					bodyTypeBuffer.append("</ul>");
				}
			}
		}
		//着装风格
		for(Integer singleClothing : singleClothings){
			for (int i = 0; i < bodyTypeList.size(); i++) {
				if ( 32 == bodyTypeList.get(i).getCategoryID()) {
					List<Dict> typeList =  bodyTypeList.get(i).getBodyTypes();
					if (i == bodyTypeList.size() - 1) {
						bodyTypeBuffer.append("<ul id='clothing_style' class='hline'>");
					} else {
						bodyTypeBuffer.append("<ul class='hline'>");
					}
					bodyTypeBuffer.append("<li  style='width:620px;clear:both;'>" + bodyTypeList.get(i).getCategoryName() + "&nbsp;" + dictManager.getDictByID(singleClothing).getName() + "</li>");
					for (int j = 0; j < typeList.size(); j++) {
						String fitCloth = typeList.get(j).getExtension();
						if (fitCloth.indexOf(singleClothing.toString())>=0){
							bodyTypeBuffer.append("<li><label><input type='checkbox' ");
							if (10284 == typeList.get(j).getID()) {
								bodyTypeBuffer.append("checked='true' ");
							}
							bodyTypeBuffer.append("name='body_type_" + bodyTypeList.get(i).getCategoryID() + "_" + dictManager.getDictByID(singleClothing).getID() + "' id='body_type_" + bodyTypeList.get(i).getCategoryID() + "_" +dictManager.getDictByID(singleClothing).getID() + "_" + typeList.get(j).getID() + "' value='" + typeList.get(j).getID()  + "' onclick='$.csControl.checkOnce(this);' onfocus='$.csSize.playShow(-1,$.csControl.getRadioValue(\"size_category\")," + typeList.get(j).getID()  + ");'/> " + typeList.get(j).getName() + "</label></li>");
						}
					}
					bodyTypeBuffer.append("</ul>");
				}
			}
			
		}
		return bodyTypeBuffer.toString();
	}
	
	
	public String spliceBodySpec(Orden orden){
		String sizepartvalues = orden.getSizePartValues();
		String[] sizeInputArr = sizepartvalues.split(",");
		String sizeValue;
		StringBuffer bodyBuffer = new StringBuffer();
		Integer[] clothArr;
		List<OrdenDetail> ordenDetailList = orden.getOrdenDetails();
		if(ordenDetailList == null){
			ordenDetailList = new ArrayList<OrdenDetail>();
		}
		//默认初始化时是二件套 的
		switch (orden.getClothingID()) {
		case 1:
			clothArr = new Integer[]{3,2000};
			break;
		case 2:
			clothArr = new Integer[]{3,2000,4000};
			break;
		case 4:
			clothArr = new Integer[]{4000,2000};
			break;
		case 5:
			clothArr = new Integer[]{90000,2000};
			break;
		case 6:
			clothArr = new Integer[]{3,4000};
			break;
		case 7:
			clothArr = new Integer[]{95000,98000};
			break;
		default:
			clothArr = new Integer[]{orden.getClothingID()};
			break;
		}
		for(Integer clothID : clothArr){
			Integer nSingleClothingID = clothID;
			Integer nSizeCategoryID = orden.getSizeCategoryID();
			
			Integer nAreaID = -1;
			String strSpecHeight = "undefined";
			//如果是标准号
			if("10054".equals(orden.getSizeCategoryID().toString())){
				nAreaID = Utility.toSafeInt(orden.getSizeAreaID());
				
				for(OrdenDetail ordenDetail : ordenDetailList){
					if(ordenDetail.getSingleClothingID().toString().equals(clothID.toString()) || ordenDetail.getSingleClothingID() == clothID ){
						strSpecHeight = ordenDetail.getSpecHeight();
					}
				}
			}
			
			String strSpecChest = "undefined";
			Integer  nUnitID = Utility.toSafeInt(orden.getSizeUnitID());
			
			List<SizeStandard> sizeStandards = new SizeManager().getSizeStandard(nSingleClothingID, nSizeCategoryID, nAreaID, strSpecHeight,strSpecChest, nUnitID);
			
			String tempComponentIDs = "";
			if(3000 == clothID){
				if(null !=orden.getComponents() && !"".equals(orden.getComponents())){
					if(orden.getComponents().indexOf("3028")>0){//长袖  3028
						tempComponentIDs = "3028";
					}else if(orden.getComponents().indexOf("3029")>0){//短袖3029
						tempComponentIDs = "3029";
					}
				}
			}
			String specHeights = new SizeManager().getSpecHeight(nSingleClothingID, nAreaID,tempComponentIDs);
			//根据工艺筛选尺寸
			List<SizeStandard> validSizeStandards = new SizeManager().getValidSizeStandard(sizeStandards,tempComponentIDs);
			sizeStandards = validSizeStandards;
			
			bodyBuffer.append("<div>" + DictManager.getDictByID(clothID).getName() + "</div>");
			
			//三件套、两件套(西服+马夹)中 马甲 没有净体尺寸
			if((2== orden.getClothingID()||"2".equals(orden.getClothingID()) 
					|| 6== orden.getClothingID()||"6".equals(orden.getClothingID())) //三件套
					&&  "10052".equals(orden.getSizeCategoryID().toString()) //净体
					&& "4000".equals(clothID.toString())){//马甲 
				bodyBuffer.append("<div id='spec_" + clothID + "'></div>");
				bodyBuffer.append("<div id='part_" + clothID + "' style='padding-left: 60px;'>"+ResourceHelper.getValue("Label_VestNoSize")+"</div>");
			}else{
				String[] specHeightArr = specHeights.split(",");
				if("10054".equals(orden.getSizeCategoryID().toString()) && specHeightArr.length > 0){
					bodyBuffer.append("<div id='spec_" + clothID + "'>");
					bodyBuffer.append("<ul class='size_spec_height'>");
					String checkedString = "";
					for(String heigth : specHeightArr){
						if(null!= heigth && !"".equals(heigth)){
							if(!"undefined".equals(strSpecHeight) && heigth.equals(strSpecHeight)){
									checkedString = "checked='checked'";
							}else{
								checkedString = "";
							}
							bodyBuffer.append("<li><label><input type='radio' value='" + heigth + "' "+checkedString+" name='size_spec_height_" + clothID + "' onclick=$.csSize.generateSpecChest(" + clothID + ") />" + heigth + "</label></li>");
						}
					}
					bodyBuffer.append("</ul></div>");
				}else{
					bodyBuffer.append("<div id='spec_" + clothID + "'></div>");
				}
				bodyBuffer.append("<div id='part_" + clothID+ "' style='padding-left: 0px;'>");
				bodyBuffer.append("<ul>");
				String requiredParts = "";
				String part_label_ = "part_label_";
				for (SizeStandard sizeStandard : sizeStandards) {
					if(null != sizeStandard.getDefaultValue() && !"".equals(sizeStandard.getDefaultValue())){
						sizeValue =  sizeStandard.getDefaultValue().toString();
					}else{
						sizeValue = "";
					}
					String[] keyValue;
					for(String size :sizeInputArr){
						if(size.indexOf(":") <= 0){
							if(2000 == clothID 
									&& (10108 == sizeStandard.getPartID() || "10108".equals(sizeStandard.getPartID().toString()))){
								sizeValue = size;
							}
						}else{
							keyValue = size.split(":");
							if(keyValue.length>1){
								if(keyValue[0].equals(sizeStandard.getPartID().toString())){
									sizeValue = keyValue[1];
								}
								//西裤臀围
							}else if(2000 == clothID && keyValue.length>1 &&
									(10108 == sizeStandard.getPartID() || "10108".equals(sizeStandard.getPartID().toString()))){
								sizeValue = keyValue[0];
							}
						}
						
					}
					Float defaultValue = sizeStandard.getDefaultValue();
					if("".equals(sizeValue) && null != defaultValue){
						sizeValue = defaultValue.toString();
					}
//					if (null != defaultValue && 0F != defaultValue) {
//						defaultValue = 0F;
//					}else{
//						sizeValue = defaultValue.toString();
//					}
					String star = "";
					if (null != sizeStandard.getIsRequired() && 10050 == sizeStandard.getIsRequired()) {
						if (requiredParts != "") {
							requiredParts += "," + sizeStandard.getPartID();
						} else {
							requiredParts += sizeStandard.getPartID();
						}
						star = " star";
					}
					String readonly = "";
					if (null != sizeStandard.getIsReadonly() && 10050 == sizeStandard.getIsReadonly()) {
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
					if(clothID==2000 && "part_label_10108".equals(part_label_ + sizeStandard.getPartID())){
						tun = clothID.toString();
					}
					bodyBuffer
							.append("<input type='text' "
									+ readonly + " onfocus='$.csSize.playShow("	+ clothID+ ","+ sizeStandard.getSizeCategoryID()+ ","
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
			}
		}
		return bodyBuffer.toString();
	}
	/**
	 * 获取单件服装类的尺寸录入信息
	 */
	public String getSingleClothSpecialBodyInput(Orden orden,String clothID){
		String sizepartvalues = orden.getSizePartValues();
		String[] sizeInputArr = (sizepartvalues==null||"".equals(sizepartvalues))?new String[]{}: sizepartvalues.split(",");
		List<OrdenDetail> ordenDetailList = orden.getOrdenDetails()==null?new ArrayList<OrdenDetail>():orden.getOrdenDetails();
		OrdenDetail detail = null;
		for(OrdenDetail ordenDetail :ordenDetailList){
			if(clothID.equals(ordenDetail.getSingleClothingID().toString())){
				detail = ordenDetail;
			}
		}
		
		String tempComponentIDs = "";
		if("3000".equals(clothID) && null !=orden.getComponents() && !"".equals(orden.getComponents())){
			if(orden.getComponents().indexOf("3028")>0){//长袖  3028
				tempComponentIDs = "3028";
			}else if(orden.getComponents().indexOf("3029")>0){//短袖3029
				tempComponentIDs = "3029";
			}
		}
		String specHeights = "";
		
		Dict cloth = DictManager.getDictByID(Utility.toSafeInt(clothID));
		StringBuffer bodyBuffer = new StringBuffer();
		String sizeValue;
		

		Integer nSingleClothingID = Utility.toSafeInt(clothID);
		Integer nSizeCategoryID = orden.getSizeCategoryID();
		
		Integer nAreaID = -1;
		String strSpecHeight = "undefined";
		//如果是标准号
		if("10054".equals(orden.getSizeCategoryID().toString())){
			nAreaID = Utility.toSafeInt(orden.getSizeAreaID());
			if(-1 == nAreaID){
				nAreaID = 10201;
			}
			specHeights = new SizeManager().getSpecHeight(nSingleClothingID, nAreaID,tempComponentIDs);
//			if(null != detail){
//				strSpecHeight = detail.getSpecHeight();
//				if(null == strSpecHeight || "".equals(strSpecHeight)){
//					strSpecHeight = specHeights.split(",")[0];
//				}
//			}else{
				strSpecHeight = specHeights.split(",")[0];
//			}
		}
		
		String strSpecChest = "undefined";
		Integer  nUnitID = Utility.toSafeInt(orden.getSizeUnitID());
		specHeights = new SizeManager().getSpecHeight(nSingleClothingID, nAreaID,tempComponentIDs);
		List<SizeStandard> sizeStandards = new SizeManager().getSizeStandard(nSingleClothingID, nSizeCategoryID, nAreaID, strSpecHeight,strSpecChest, nUnitID);
		//根据工艺筛选尺寸
		List<SizeStandard> validSizeStandards = new SizeManager().getValidSizeStandard(sizeStandards,tempComponentIDs);
		sizeStandards = validSizeStandards;
		
		bodyBuffer.append("<div>" + DictManager.getDictByID(Utility.toSafeInt(clothID)).getName() + "</div>");
		//三件套、两件套(西服+马夹)中 马甲 没有净体尺寸
		if((2== orden.getClothingID()||"2".equals(orden.getClothingID()) 
				|| 6== orden.getClothingID()||"6".equals(orden.getClothingID())) //三件套
				&&  "10052".equals(orden.getSizeCategoryID().toString()) //净体
				&& "4000".equals(clothID.toString())){//马甲 
			bodyBuffer.append("<div id='spec_" + clothID + "'></div>");
			bodyBuffer.append("<div id='part_" + clothID + "' style='padding-left: 60px;'>"+ResourceHelper.getValue("Label_VestNoSize")+"</div>");
		}else{
			String[] specHeightArr = specHeights.split(",");
			if("10054".equals(orden.getSizeCategoryID().toString()) && specHeightArr.length > 0){
				bodyBuffer.append("<div id='spec_" + clothID + "'>");
				bodyBuffer.append("<ul class='size_spec_height'>");
				String checkedString = "";
				for(String heigth : specHeightArr){
					if(null!= heigth && !"".equals(heigth)){
						if(!"undefined".equals(strSpecHeight) && heigth.equals(strSpecHeight)){
								checkedString = "checked='checked'";
						}else{
							checkedString = "";
						}
						bodyBuffer.append("<li><label><input type='radio' value='" + heigth + "' "+checkedString+" name='size_spec_height_" + clothID + "' onclick=$.csSize.generateSpecChest(" + clothID + ") />" + heigth + "</label></li>");
					}
				}
				bodyBuffer.append("</ul></div>");
			}else{
				bodyBuffer.append("<div id='spec_" + clothID + "'></div>");
			}
			bodyBuffer.append("<div id='part_" + clothID+ "' style='padding-left: 0px;'>");
			bodyBuffer.append("<ul>");
			String requiredParts = "";
			String part_label_ = "part_label_";
			for (SizeStandard sizeStandard : sizeStandards) {
				sizeValue = "";
				String[] keyValue;
				for(String size :sizeInputArr){
					if(size.indexOf(":") <= 0){
						if("2000".equals(clothID) 
								&& (10108 == sizeStandard.getPartID() || "10108".equals(sizeStandard.getPartID().toString()))){
							sizeValue = size;
						}
					}else{
						keyValue = size.split(":");
						if(keyValue.length>1){
							if(keyValue[0].equals(sizeStandard.getPartID().toString())){
								sizeValue = keyValue[1];
							}
							//西裤臀围
						}else if("2000".equals(clothID) && keyValue.length>1 &&
								(10108 == sizeStandard.getPartID() || "10108".equals(sizeStandard.getPartID().toString()))){
							sizeValue = keyValue[0];
						}
					}
					
				}
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
				if("2000".equals(clothID) && "part_label_10108".equals(part_label_ + sizeStandard.getPartID())){
					tun = clothID.toString();
				}
				bodyBuffer
						.append("<input type='text' "
								+ readonly + " onfocus='$.csSize.playShow("	+ clothID+ ","+ sizeStandard.getSizeCategoryID()+ ","
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
		}
		return bodyBuffer.toString();
	}
	
	
	public String spliceSizeBodyType(Orden orden){
		String bodyTypes = orden.getSizeBodyTypeValues();
		
		StringBuffer bodyTypeBuffer = new StringBuffer();
		Integer[] singleClothings;
		switch (orden.getClothingID()) {
		case 1:
			singleClothings = new Integer[]{3,2000};
			break;
		case 2:
			singleClothings = new Integer[]{3,2000,4000};
			break;
		case 4:
			singleClothings = new Integer[]{4000,2000};
			break;
		case 5:
			singleClothings = new Integer[]{90000,2000};
			break;
		case 6:
			singleClothings = new Integer[]{3,4000};
			break;
		case 7:
			singleClothings = new Integer[]{95000,98000};
			break;
		default:
			singleClothings = new Integer[]{orden.getClothingID()};
			break;
		}
//		for(Integer singleClothing :singleClothings)
		if(1==1){
		List<ClothingBodyType> bodyTypeList = sizeManager.getClotingBodyType(orden.getClothingID(),orden.getSizeCategoryID());
		for(int i =0 ;i< bodyTypeList.size() ;i ++){
			if(32 != bodyTypeList.get(i).getCategoryID()){
				List<Dict> typeList =  bodyTypeList.get(i).getBodyTypes();
				if(null != typeList && !typeList.isEmpty()){
					if (i == bodyTypeList.size() - 1) {
						bodyTypeBuffer.append("<ul id='clothing_style' class='hline'>");
					} else {
						bodyTypeBuffer.append("<ul class='hline'>");
					}
					bodyTypeBuffer.append("<li style='width:620px;clear:both;'>" + bodyTypeList.get(i).getCategoryName() + "</li>");
					boolean bodyFlag = false;
					Integer valueID = 0;
					for(Dict dict :typeList){
						if (null == bodyTypes || "".equals(bodyTypes)) {
							valueID = 0;
						}else{
							if (bodyTypes.indexOf(dict.getID()
									.toString()) >= 0) {
								valueID = dict.getID();
								break;
							}
						}
						
					}
					for(int j = 0;j<typeList.size() ;j++){
						bodyTypeBuffer.append("<li><label><input type='checkbox' ");
						
//						if (10284 == typeList.get(j).getID() || 10368 == typeList.get(j).getID()) {
//							bodyTypeBuffer.append("checked='true' ");
//						} else if (j == 0 && i < bodyTypeList.size() - 1) {
//							bodyTypeBuffer.append("checked='true' ");
//						}
//						if (null != bodyTypes) {
//							if (bodyTypes.indexOf(typeList.get(j).getID()
//									.toString()) > 0) {
//								bodyTypeBuffer.append("checked='true' ");
//							}else if(10088 == typeList.get(j).getID() || 10368 == typeList.get(j).getID()||10284 == typeList.get(j).getID()){
//								bodyTypeBuffer.append("checked='true' ");
//							}
//						}else{
//							if(10088 == typeList.get(j).getID() ||10284 == typeList.get(j).getID() || 10368 == typeList.get(j).getID()){
//								bodyTypeBuffer.append("checked='true' ");
//							}else if (j == 0 && i < bodyTypeList.size() - 1) {
//								bodyTypeBuffer.append("checked='true' ");
//							}
//						}
						if(valueID == 0){
							if(j == 0 && i < bodyTypeList.size() - 1){
								bodyTypeBuffer.append("checked='true' ");
							}
						}else{
							if(valueID.toString().equals(typeList.get(j).getID().toString())){
								bodyTypeBuffer.append("checked='true' ");
							}
						}

						bodyTypeBuffer.append("  name='body_type_" + bodyTypeList.get(i).getCategoryID() + "' value='" + typeList.get(j).getID() + "' onclick='$.csControl.checkOnce(this);'  onfocus='$.csSize.playShow(-1,$.csControl.getRadioValue(\"size_category\")," + typeList.get(j).getID()+ ");'/> " + typeList.get(j).getName() + "</label></li>");
					}
					bodyTypeBuffer.append("</ul>");
				}
			}
		}
	}
		
		
		
		//着装风格
		for(Integer singleClothing :singleClothings){
			List<ClothingBodyType> bodyTypeList = sizeManager.getClotingBodyType(singleClothing,orden.getSizeCategoryID());
			List<OrdenDetail> details = orden.getOrdenDetails();
			String[]  componentTextArr = new String[]{};
			if(null != orden.getComponentTexts() && !"".equals(orden.getComponentTexts())){
				componentTextArr = orden.getComponentTexts().split(",");
			}else if(null==orden.getOrdenID() || "".equals(orden.getOrdenID())){
				componentTextArr = new String[]{};
			}
			for (int i = 0; i < bodyTypeList.size(); i++) {
				if ( 32 == bodyTypeList.get(i).getCategoryID()) {
					List<Dict> typeList =  bodyTypeList.get(i).getBodyTypes();
					if (i == bodyTypeList.size() - 1) {
						bodyTypeBuffer.append("<ul id='clothing_style' class='hline'>");
					} else {
						bodyTypeBuffer.append("<ul class='hline'>");
					}
					bodyTypeBuffer.append("<li style='width:620px;clear:both;'>" + bodyTypeList.get(i).getCategoryName() + "&nbsp;" + dictManager.getDictByID(singleClothing).getName() + "</li>");
					
					Integer clothingStyleID = 0;
					for (Dict style : typeList) {
						if (componentTextArr.length > 0) {
							for (String key_value : componentTextArr) {
								String[] clothingstyle = key_value.split(":");
								if (clothingstyle.length > 1) {
									if (singleClothing.toString().equals(clothingstyle[0])) {
										if (style.getID().toString().equals(clothingstyle[1])) {
											clothingStyleID = style.getID();
											break;
										}
									}
								}
							}
						}
					}
					for (int j = 0; j < typeList.size(); j++) {
						String fitCloth = typeList.get(j).getExtension();
						if (fitCloth.indexOf(singleClothing.toString())>=0){
							bodyTypeBuffer.append("<li><label><input type='checkbox' ");
//							if (componentTextArr.length > 0) {
//								for (String key_value : componentTextArr) {
//									String[] clothingstyle = key_value.split(":");
//									if (clothingstyle.length > 1) {
//										if (singleClothing.toString().equals(clothingstyle[0])) {
//											if (typeList.get(j).getID().toString().equals(clothingstyle[1])) {
//												bodyTypeBuffer.append("checked='true' ");
//											} else if (10284 == typeList.get(j).getID() || "10284".equals(typeList.get(j).getID().toString())) {
//												bodyTypeBuffer.append("checked='true' ");
//											}
//										}
//									}
//								}
//							}else if (10284 == typeList.get(j).getID() || "10284".equals(typeList.get(j).getID().toString())) {
//								bodyTypeBuffer.append("checked='true' ");
//							}
							if (0 != clothingStyleID) {
								if (typeList.get(j).getID().toString().equals(clothingStyleID.toString())) {
									bodyTypeBuffer.append("checked='true' ");
								}
							} else {
								if(10284 == typeList.get(j).getID() || "10284".equals(typeList.get(j).getID().toString())){
									bodyTypeBuffer.append("checked='true' ");
								}
							}
							bodyTypeBuffer.append("name='body_type_" + bodyTypeList.get(i).getCategoryID() + "_" + dictManager.getDictByID(singleClothing).getID() + "' id='body_type_" + bodyTypeList.get(i).getCategoryID() + "_" +dictManager.getDictByID(singleClothing).getID() + "_" + typeList.get(j).getID() + "' value='" + typeList.get(j).getID()  + "' onclick='$.csControl.checkOnce(this);' onfocus='$.csSize.playShow(-1,$.csControl.getRadioValue(\"size_category\")," + typeList.get(j).getID()  + ");'/> " + typeList.get(j).getName() + "</label></li>");
						}
					}
					bodyTypeBuffer.append("</ul>");
				}
			}
		}
		return bodyTypeBuffer.toString();
	}
}
