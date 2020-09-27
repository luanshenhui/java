package chinsoft.service.core;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;

import centling.business.FabricPriceManager;
import centling.entity.Discount;
import centling.entity.FabricPrice;
import chinsoft.business.CDict;
import chinsoft.business.ClothingManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.CustomerManager;
import chinsoft.business.DictManager;
import chinsoft.business.FabricManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Customer;
import chinsoft.entity.Detail;
import chinsoft.entity.Dict;
import chinsoft.entity.Fabric;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;

public class BaseServlet extends HttpServlet {
	
	protected void checkDetail(HttpServletRequest request, Detail detail) {
		if(StringUtils.isNotEmpty(detail.getImgUrl())){
			String strNewImg = "";
			String[] strImgs = Utility.getStrArray(detail.getImgUrl());
			for(String strImg : strImgs){
				String strRealPath = request.getSession().getServletContext().getRealPath(strImg.replace("../..",""));
				if(new File(strRealPath).exists()){
					if(StringUtils.isNotEmpty(strNewImg)){
						strNewImg += ",";
					}
					strNewImg += strImg;
				}
			}
			detail.setImgUrl(strNewImg);
		}
	}
	
	protected List<Detail> trimDetails(List<Detail> details){
		List<Detail> result = new ArrayList<Detail>();
		for(Detail d: details){
			if(StringUtils.isNotEmpty(d.getImgUrl()) && !contain(result,d)){
				result.add(d);
			}
		}
		return result;
	}
	private boolean contain(List<Detail> details,Detail detail){
		for(Detail d:details){
			if(d.getImgUrl().equals(detail.getImgUrl())){
				return true;
			}
			
		}
		return false;
	}
	protected  String getTempFabricCode() {
		Member loginUser = CurrentInfo.getCurrentMember();
		String strFabricCode = Utility.toSafeString(HttpContext.getSessionValue(CDict.SessionKey_FabricCode));
		if(StringUtils.isEmpty(strFabricCode) || "null".equals(strFabricCode)){
			strFabricCode = new FabricManager().getDefaultFabricCode(this.getTempClothingID(),loginUser);
		}
		// System.out.println("获取默认面料"+strFabricCode);
		return strFabricCode;
	}
	
	protected void setTempClothingID(int nClothingID){
		HttpContext.setSessionValue("SESSION_BXLB","");
		if(nClothingID<=0){
			nClothingID = CDict.ClothingSuit2PCS.getID();
		}
		if(nClothingID != Utility.toSafeInt(this.getTempClothingID())){
			HttpContext.setSessionNull(CDict.SessionKey_FabricCode);
			HttpContext.setSessionNull(CDict.SessionKey_CurrentComponentID);
			HttpContext.setSessionNull(CDict.SessionKey_ComponentIDs);
			HttpContext.setSessionNull(CDict.SessionKey_ComponentTexts);
		}
		
		HttpContext.setSessionValue(CDict.SessionKey_ClothingID, nClothingID);
	}
	
	protected String getTempClothingID() {
		String strClothingID = "";
		try {
			strClothingID = Utility.toSafeString(HttpContext.getSessionValue(CDict.SessionKey_ClothingID));
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug(e.getMessage());
		}

		if(strClothingID == null || "".equals(strClothingID)){
			strClothingID = new OrdenManager().getDefaultClothingID();
		}
		return strClothingID;
	}
	
	protected void setTempFabricCode(String fabricCode){
		HttpContext.setSessionValue(CDict.SessionKey_FabricCode, fabricCode);
	}
	
	protected void setTempComponentText(String strKeyValue){
		String strComponentTexts = getTempComponentTexts();
		HttpContext.setSessionValue(CDict.SessionKey_ComponentTexts, new ClothingManager().saveTempComponentTexts(strComponentTexts,strKeyValue));
	}
	
	protected String getTempComponentTexts() {
		String strComponentTexts = Utility.toSafeString(HttpContext.getSessionValue(CDict.SessionKey_ComponentTexts));
		return strComponentTexts;
	}
	
	protected void setTempComponentID(int nComponentID){
		String strComponentIDs = getTempComponentIDs();
		HttpContext.setSessionValue(CDict.SessionKey_CurrentComponentID, nComponentID);
		HttpContext.setSessionValue(CDict.SessionKey_ComponentIDs, new ClothingManager().saveTempComponentIDs(strComponentIDs,nComponentID));
	}
	
	protected void setTempParameterID(int nParameterID){
		String strComponentIDs = getTempComponentIDs();
		HttpContext.setSessionValue(CDict.SessionKey_ComponentIDs, new ClothingManager().saveTempParameterIDs(strComponentIDs,nParameterID));
	}
	
	protected String getTempComponentIDs() {
		String strComponentIDs = Utility.toSafeString(HttpContext.getSessionValue(CDict.SessionKey_ComponentIDs));
		
		if(StringUtils.isEmpty(strComponentIDs)){
			List<Dict> defaultDicts = new ClothingManager().getDefaultComponent(Utility.toSafeInt(this.getTempClothingID()),this.getTempFabricCode());
			for(Dict dict :defaultDicts){
				strComponentIDs += dict.getID() + ",";
			}

			if(strComponentIDs.endsWith(",")){
				strComponentIDs = strComponentIDs.substring(0,strComponentIDs.length() -1 );
			}
		}
		
		return strComponentIDs;
	}

	protected void setTempCustomer(String strFormData) {
		Customer customer = this.getTempCustomer();
		String strCustomerID = EntityHelper.getValueByParamID(strFormData);
		if("".equals(strCustomerID)){
			customer.setPubMemberID(CurrentInfo.getCurrentMember().getID());
			customer.setPubDate(new Date());
		}
		else{
			customer = new CustomerManager().getCustomerByID(strCustomerID);
		}
		//量体人员姓名
		customer.setLtName(Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "ltName")));
		customer = (Customer) EntityHelper.updateEntityFromFormData(customer, strFormData);
		HttpContext.setSessionValue(CDict.SessionKey_CustomerInfo, customer);
	}
	
	protected Customer getTempCustomer() {
		Customer customer = null;
		try {
			customer =  (Customer)HttpContext.getSessionValue(CDict.SessionKey_CustomerInfo);
			if(customer == null){
				customer = new Customer();
			}
			return customer;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return customer;
	}
		
	protected void setTempOrden(Orden orden) {
		List<Orden> tempOrdens = this.getTempOrdens();
		if(tempOrdens == null){
			tempOrdens = new ArrayList<Orden>();
		}
		Orden removedOrden = null;
		for(Orden o : tempOrdens){
			if(o.getOrdenID().equals(orden.getOrdenID())){
				orden.setStatusID(o.getStatusID());
				removedOrden = o;
			}
		}
		if(removedOrden != null){
			tempOrdens.remove(removedOrden);
		}
		tempOrdens.add(orden);
		HttpContext.setSessionValue(CDict.SessionKey_Ordens, tempOrdens);
	}
	
	@SuppressWarnings("unchecked")
	protected List<Orden> getTempOrdens() {
		try {
			List<Orden> ordens =  (List<Orden>)HttpContext.getSessionValue(CDict.SessionKey_Ordens);
			if(ordens == null||ordens.get(0)==null){
				ordens = new ArrayList<Orden>();
			}
			for(Orden orden:ordens){
				new OrdenManager().extendOrden(orden);
			}
			return ordens;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	protected List<Discount> getTempDiscounts() {
		try {
			List<Discount> discounts = (List<Discount>)HttpContext.getSessionValue(CDict.SessionKey_CurrentDiscountsOfMember);
			if(discounts == null){
				discounts = new ArrayList<Discount>();
			}
			return discounts;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	protected void setTempDiscounts(List<Discount> discounts) {
		try {
			HttpContext.setSessionValue(CDict.SessionKey_CurrentDiscountsOfMember, discounts);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	protected void removeTempOrden(String strOrdenID) {
		List<Orden> tempOrdens = this.getTempOrdens();
		for(Orden orden : tempOrdens){
			if(orden.getOrdenID().equals(strOrdenID)){
				 tempOrdens.remove(orden);
			}
		}
		HttpContext.setSessionValue(CDict.SessionKey_Ordens, tempOrdens);
	}
	
	protected void clearTempDesigns(){
		HttpContext.setSessionNull(CDict.SessionKey_ClothingID);
		HttpContext.setSessionNull(CDict.SessionKey_FabricCode);
		HttpContext.setSessionNull(CDict.SessionKey_ComponentIDs);
		HttpContext.setSessionNull(CDict.SessionKey_ComponentTexts);
	}
	
	protected void clearTempOrdens(){
		HttpContext.setSessionNull(CDict.SessionKey_ComponentTexts);
		HttpContext.setSessionNull(CDict.SessionKey_CustomerInfo);
		HttpContext.setSessionNull(CDict.SessionKey_Ordens);
		clearTempDesigns();
	}
	
	protected Orden updateOrdenByParam(String strFormData,String strComponents) {
		String strOrdenID = Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "ordenID"));
		
		Orden orden = getOrdenByID(strOrdenID);
		
		if(EntityHelper.getValueByKey(strFormData, "userNo")!=null){
			orden.setUserordeNo(Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "userNo")));
		}
		
		if(null != EntityHelper.getValueByKey(strFormData, "autoID") && !"".equals(EntityHelper.getValueByKey(strFormData, "autoID"))){
			int autoID = Utility.toSafeInt(EntityHelper.getValueByKey(strFormData, "autoID"));
			orden.setAutoID(autoID);
		}else{
			orden.setAutoID(null);
		}
		//西裤追加一条数量
		String strMorePants = Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "morePants"));
		if("on".equals(strMorePants)){
			orden.setMorePants(CDict.YES.getID());
		}else{
			orden.setMorePants(1);
		}

		int nSizeUnitID = Utility.toSafeInt(EntityHelper.getValueByKey(strFormData, "sizeUnitID"));
		orden.setSizeUnitID(nSizeUnitID);
		
		if(EntityHelper.getValueByKey(strFormData, "styleID")!=null){
			int nStyleID = Utility.toSafeInt(EntityHelper.getValueByKey(strFormData, "styleID"));
			orden.setStyleID(nStyleID);
		}else{
			orden.setStyleID(CDict.NormalStyle.getID());
		}
		
		orden.setPubMemberID(CurrentInfo.getCurrentMember().getID());
		orden.setClothingID(Utility.toSafeInt(this.getTempClothingID()));
		//订单数量
//		if(CDict.ClothingChenYi.getID().equals(orden.getClothingID())){
			String shirtAmount = Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "shirtAmount"));
			if(!CDict.YES.getID().equals(orden.getMorePants())){
				if("".equals(shirtAmount)){
					orden.setMorePants(1);
				}else{
					orden.setMorePants(Utility.toSafeInt(shirtAmount));
				}
			}
//		}

		orden.setFabricCode(getTempFabricCode());
		Fabric fabric = new FabricManager().getFabricByCode(orden.getFabricCode());
		if(fabric != null){
			orden.setFabricID(fabric.getID());
		}
		if("".equals(strComponents)){
			orden.setComponents(this.getTempComponentIDs());
		}else{
			orden.setComponents(strComponents);
		}
		orden.setComponentTexts(this.getTempComponentTexts());
		Map<String, Object> maps = EntityHelper.jsonToMap(strFormData);
		Object[] keys = maps.keySet().toArray();
		String strParts = "";
		String strBodyTypes = "";
		String strStyle = this.getTempComponentTexts();
		for (Object key : keys) {
			String strKey = Utility.toSafeString(key);
			if(strKey.startsWith("part_label_")){
				if(strParts.equals("")){
					strParts += strKey.replace("part_label_", "") + ":" + maps.get(strKey);
				}
				else{
					if(strFormData.contains("'area':'10204'") && strKey.equals("part_label_10108")){
						strParts += "," + strKey.replace("part_label_", "") + ":," + maps.get(strKey);
					}else{
						strParts += "," + strKey.replace("part_label_", "") + ":" + maps.get(strKey);
					}
				}
			}
			if(strKey.startsWith("body_type_")){
				if(CDict.CLOTHINGSTYLE.equals(strKey.split("_")[2])){
					strStyle += "," + strKey.split("_")[3] + ":" + maps.get(strKey);
				}else{
					if(strBodyTypes.equals("")){
						strBodyTypes += maps.get(strKey);
					}
					else{
						strBodyTypes += "," + maps.get(strKey);
					}
				}
			}

			if(strKey.equals("size_category")){
				orden.setSizeCategoryID(Utility.toSafeInt(maps.get(strKey)));
			}
			if(strKey.equals("area")){
				orden.setSizeAreaID(Utility.toSafeInt(maps.get(strKey)));
			}
			if(strKey.equals("size_spec")){
				orden.setSizeSpec(Utility.toSafeString(maps.get(strKey)));
			}
		}
		orden.setComponentTexts(strStyle);
		orden.setSizePartValues(strParts);
		orden.setSizeBodyTypeValues(strBodyTypes);
		String strStyleDY = Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "styleDY"));
		orden.setStyleDY(strStyleDY);
		List<OrdenDetail> ordenDetails = new ArrayList<OrdenDetail>();
		List<Dict> singleClothings = new ClothingManager().getSingleClothings(orden.getClothingID());

		for(Dict singleClothing: singleClothings){
			OrdenDetail ordenDetail = new OrdenDetail();
			//订单数量
			ordenDetail.setAmount(1);
			if(CDict.YES.getID().equals(orden.getMorePants()) && CDict.ClothingPants.getID().equals(singleClothing.getID())){
				ordenDetail.setAmount(2);
			}else if(CDict.YES.getID().equals(orden.getMorePants()) 
					&& (CDict.ClothingShangYi.getID().equals(singleClothing.getID()) || CDict.ClothingMaJia.getID().equals(singleClothing.getID()))){
				ordenDetail.setAmount(1);
			}else{
				ordenDetail.setAmount(orden.getMorePants());
			}
//			if(CDict.ClothingChenYi.getID().equals(singleClothing.getID())){
//				ordenDetail.setAmount(orden.getMorePants());
//			}
			//ordenDetail.setPrice(300.0);
			ordenDetail.setSingleClothingID(singleClothing.getID());
			String strSizeHeight = Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "size_spec_height_" +singleClothing.getID()));
			ordenDetail.setSpecHeight(strSizeHeight);
			
			String strSizeChest = Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "size_spec_chest_" +singleClothing.getID()));
			ordenDetail.setSpecChest(strSizeChest);
			ordenDetails.add(ordenDetail);
		}
		
		orden.setOrdenDetails(ordenDetails);
		new OrdenManager().setPrice(orden);
		
		if("".endsWith(strComponents)){
			String strComponentIDs = orden.getComponents();
			List<Dict> defaultComponents = new ClothingManager().getDefaultComponent(orden.getClothingID(), orden.getFabricCode());
			for(Dict component:defaultComponents){
				if(StringUtils.isNotEmpty(strComponentIDs)){
					strComponentIDs = Utility.replace(strComponentIDs, Utility.toSafeString(component.getID()));
				}
			}
			//去除(冲突关系)残余默认值(珠边部位)
			if(!"".equals(strComponentIDs)){
				String[] strComponentID = strComponentIDs.split(",");
				for(String strComponent :strComponentID){
					Dict compontent = DictManager.getDictByID(Utility.toSafeInt(strComponent));
					if(CDict.YES.getID().equals(compontent.getIsDefault())){
						strComponentIDs = Utility.replace(strComponentIDs, Utility.toSafeString(compontent.getID()));
					}
				}
			}
			orden.setComponents(strComponentIDs);
		}
		
		return orden;
	}

	protected Orden getOrdenByID(String strOrdenID) {
		Orden orden = null;
		if(StringUtils.isNotEmpty(strOrdenID)){
			if(strOrdenID.length() == 36){
				List<Orden> tempOrdens = this.getTempOrdens();
				for(Orden o :tempOrdens){
					if(strOrdenID.equals(o.getOrdenID())){
						orden = o;
						break;
					}
				}
			}else{
				orden = new OrdenManager().getOrdenByID(strOrdenID);
			}
		}
		if(orden == null){
			orden = new Orden();
			orden.setOrdenID(UUID.randomUUID().toString());
		}
		
		return orden;
	}
	
	protected void output(Object object) {
		HttpContext.output(object);
	}
	
	protected String getParameter(String strParameter){
		return HttpContext.getParameter(strParameter);
	}
	
	protected void redirectToLogin(){
		HttpContext.redirect(Utility.getLoginPath());
	}
	
	protected void service() {
		if (CurrentInfo.checkAccess() == false) {
			redirectToLogin();
		}
	}
	
	private static final long serialVersionUID = 5217506226804531188L;
	
	//面料标、商标  -->  工艺信息 添加 自定义内容id
	protected String processBiao(Orden orden){
		String strOrdersProcess=orden.getComponents();
		String[] strComponents = orden.getComponents().split(",");
		for(int i=0;i<strComponents.length;i++){
			if(!"".equals(strComponents[i])){
				Dict component =DictManager.getDictByID(Utility.toSafeInt((strComponents[i])));
				Dict dictParent =  DictManager.getDictByID(component.getParentID());
				String[] str = CDict.CUSTOMERLABELSITEID.split(",");
				for(int n=0;n<str.length;n++){
					if(str[n].equals(Utility.toSafeString(component.getParentID()))){//商标、面料标
						if(orden.getComponentTexts() != null && !"".equals(orden.getComponentTexts())){
							String[] strComponentTexts = orden.getComponentTexts().split(",");
							for(int j=1;j<strComponentTexts.length;j++){
								String[] ComponentText = strComponentTexts[j].split(":");
								Dict dict =DictManager.getDictByID(Utility.toSafeInt(ComponentText[0]));
								if(dict.getParentID().equals(dictParent.getParentID()) && !strOrdersProcess.contains(ComponentText[0])){
									strOrdersProcess+=","+ComponentText[0];
									break;
								}
							}
						}
					}
				}
			}
		}
		String[] str = CDict.CUSTOMERLABELSITEID.split(",");
		for(int n=0;n<str.length;n++){
			if(orden.getComponentTexts() != null && !"".equals(orden.getComponentTexts())){
				String[] strComponentTexts = orden.getComponentTexts().split(",");
				for(int j=1;j<strComponentTexts.length;j++){
					String[] ComponentText = strComponentTexts[j].split(":");
					String process = ","+strOrdersProcess+",";
					if(ComponentText.length>1 && !process.contains(","+ComponentText[0]+",")){
						Dict dictLocation =DictManager.getDictByID(Utility.toSafeInt(str[n]));
						Dict dict =DictManager.getDictByID(Utility.toSafeInt(ComponentText[0]));
						if(dict.getParentID().equals(dictLocation.getParentID())){
							strOrdersProcess+=","+ComponentText[0];
							break;
						}
					}
				}
			}
		}
		return strOrdersProcess;
	}
	//检查面料标商标
	public String checkProcessBiao(List<Orden> ordens){
		String strError ="";
		for(Orden orden :ordens){
			if(orden.getComponentTexts() != null && !"".equals(orden.getComponentTexts())){
				String[] strComponentTexts = orden.getComponentTexts().split(",");
				for(int j=1;j<strComponentTexts.length;j++){
					String[] ComponentText = strComponentTexts[j].split(":");
					Dict dictContent =DictManager.getDictByID(Utility.toSafeInt(ComponentText[0]));
					if(Utility.contains(CDict.LABELPARENTID,Utility.toSafeString(dictContent.getParentID()))){
						if(!"".equals(orden.getComponents())){
							String[] strComponents = orden.getComponents().split(",");
							int num=0;
							for(int i=0;i<strComponents.length;i++){
								if(strComponents[i].indexOf("_")>0){
									continue;
								}
								Dict dict =DictManager.getDictByID(Utility.toSafeInt(strComponents[i]));
								Dict dictParent =DictManager.getDictByID(dict.getParentID());
								if(ComponentText.length >1 && dictParent.getParentID().equals(dictContent.getParentID()) && Utility.contains(CDict.LABELPARENTID,Utility.toSafeString(dictParent.getParentID()))  && !Utility.contains(CDict.LABELIDS,strComponents[i])){
									num ++;
									break;
								}
							}
							if(num ==0){
								strError = ResourceHelper.getValue("Orden_CheckLapel");
								break;
							}
						}
					}
				}
			}
			if("".equals(strError) && !"".equals(orden.getComponents()) && orden.getComponents() != null){
				String[] strComponents = orden.getComponents().split(",");
				for(int i=0;i<strComponents.length;i++){
					if(strComponents[i].indexOf("_")>0){
						continue;
					}
					Dict dict =DictManager.getDictByID(Utility.toSafeInt(strComponents[i]));
					Dict dictParent =DictManager.getDictByID(dict.getParentID());
					if(Utility.contains(CDict.LABELPARENTID,Utility.toSafeString(dictParent.getParentID()))
							&& !Utility.contains(CDict.LABELIDS,strComponents[i]) && !Utility.contains(CDict.NOLABELPARENTID,strComponents[i])){
						if(orden.getComponentTexts() != null && !"".equals(orden.getComponentTexts())){
							String[] strComponentTexts = orden.getComponentTexts().split(",");
							int num=0;
							for(int j=1;j<strComponentTexts.length;j++){
								String[] strComponentText = strComponentTexts[j].split(":");
									Dict dictText =DictManager.getDictByID(Utility.toSafeInt(strComponentText[0]));
									if(dictText.getParentID().equals(dictParent.getParentID()) && strComponentText.length>1 && Utility.contains(CDict.LABELPARENTID,Utility.toSafeString(dictText.getParentID()))){
										num ++;
										break;
									}
							}
							if(num ==0){
								strError = ResourceHelper.getValue("Orden_CheckLapel");
								break;
							}
						}else{
							strError = ResourceHelper.getValue("Orden_CheckLapel");
							break;
						}
					}
				}
			}
		}
		
		return strError;
	}
	
	protected void fixCameoDefaultComponents(int clothingID){
		if("fix".equals(HttpContext.getSessionValue("orden_type"))){//默认工艺
			if(CurrentInfo.getCurrentMember().getBusinessUnit() == 20138 || CurrentInfo.getCurrentMember().getBusinessUnit() == 20144 
					|| CurrentInfo.getCurrentMember().getBusinessUnit() == 20140){
				String  mrgy="";
				if("CLX".equals(CurrentInfo.getCurrentMember().getUsername())){
					if(clothingID == 1){//套装
						mrgy=CDict.CLX_1T;
					}
					if(clothingID == 3){
						 mrgy=CDict.CLX_XF;
					}
					if(clothingID == 2000){//西裤
						mrgy=CDict.CLX_XK;
					}
					if(clothingID == 3000){//衬衣
						mrgy=CDict.CLX_CY;
					}
				}/*else{
					if(clothingID == 1){//套装
						mrgy=CDict.CAMEO_1T;
					}
					if(clothingID == 3){
						 mrgy=CDict.CAMEO_XF;
					}
					if(clothingID == 2000){//西裤
						mrgy=CDict.CAMEO_XK;
					}
				}*/
				String[] ids = mrgy.split(";");
			    String[] id1s = ids[0].split(",");
			    for(int i=0;i<id1s.length;i++){//单选
					this.setTempComponentID(Utility.toSafeInt(id1s[i]));
				}
			    String[] id2s = ids[1].split(",");
			    for(int i=0;i<id2s.length;i++){//多选
			    	this.setTempParameterID(Utility.toSafeInt(id2s[i]));
			    }
			    if(ids.length == 3){
			    	 String[] id3s = ids[2].split(",");
					    for(int i=0;i<id3s.length;i++){//面料表、商标
					    	String strLabel = id3s[i].split(":")[0];
					    	String strValue = id3s[i].split(":")[1];
					    	this.setTempComponentText(strLabel + ":" + strValue);
					    }
			    }
			}
		}
	}
	
	public String checkFabricCode(){
		String strFabricCode=this.getTempFabricCode();
		String strHead=strFabricCode.substring(0,2);
		if (CDict.FABRIC_HEAD.indexOf(strHead+",")>=0) {
			//指定规则开头的红领面料
			Fabric fabric = new FabricManager().getFabricByCode(strFabricCode);
			if (null==fabric) {
				return ResourceHelper.getValue("Bl_Error_189");//面料未找到
			}else{
				Member member=CurrentInfo.getCurrentMember();
				FabricPrice fabricPrice = new FabricPriceManager().getFabricPriceByAreaAndFabric(member.getBusinessUnit(), fabric.getCode());
				if (null==fabricPrice) {
					return ResourceHelper.getValue("Bl_Error_190");//面料价格未维护
				}
			}
		}else if(strFabricCode.length()==7){
			
		}
		return "";
	}
	
}
