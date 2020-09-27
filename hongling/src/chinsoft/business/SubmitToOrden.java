package chinsoft.business;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import chinsoft.business.CDict;
import chinsoft.business.FabricManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.EntityHelper;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.ErrorMessage;
import chinsoft.entity.Errors;
import chinsoft.entity.Fabric;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.service.core.BaseServlet;

public class SubmitToOrden extends BaseServlet{
	private static final long serialVersionUID = 1L;

	public String submitOrdens(String strFormData){
		this.setTempCustomer(strFormData);
		Map<String, Object> maps = EntityHelper.jsonToMap(strFormData);
		Object[] keys = maps.keySet().toArray();
		for (Object key : keys) {
			String strKey = Utility.toSafeString(key);
			if(strKey.startsWith("fabric_")){
				String value = Utility.toSafeString(maps.get(strKey));
				for(Orden orden:this.getTempOrdens()){
					if(("fabric_" + orden.getOrdenID()).equals(strKey)){
						orden.setFabricCode(value);
						Fabric fabric = new FabricManager().getFabricByCode(value);
						if(fabric != null){
							orden.setFabricID(fabric.getID());
						}else{
							orden.setFabricID(null);
						}
					}
				}
			}
		}
		List<Orden> ordens = this.getTempOrdens();
		for (int i = 0; i < ordens.size(); i++) {
			ordens.get(i).setStatusID(CDict.OrdenStatusSaving.getID());
			ordens.get(i).setComponents(this.processBiao(ordens.get(i)));
		}
		new OrdenManager().submitOrdens(this.getTempCustomer(), ordens);
		
		return getPrice(ordens);
	}
	
	public String submitOrden(String strFormData,int nClothingID,String strFabricCode ){
		if(strFormData.contains("2000part_label_10108")){
			strFormData=strFormData.replaceAll("2000part_label_10108", "part_label_10108");
		}
		this.clearTempDesigns();
		this.setTempClothingID(nClothingID);
		this.setTempFabricCode(strFabricCode);
		
		Map<String, Object> maps = EntityHelper.jsonToMap(strFormData);
		Object[] keys = maps.keySet().toArray();
		String strIds ="";
		String strTextValue ="";
		String strComponents ="";
		for (Object key : keys) {
			String strKey = Utility.toSafeString(key);
			if(strKey.startsWith("temp_")){
				int nId=Utility.toSafeInt(strKey.substring(strKey.lastIndexOf("_")+1));
				strIds += nId+",";
			}
		}
		//刺绣信息
		if("3000".equals(getParameter("clothingID"))){
			String[] positions = new String[5];
			for (Object key : keys) {//刺绣信息
				String strKey = Utility.toSafeString(key);
				if(strKey.startsWith("category_label_3000_")){
					int n = Utility.toSafeInt(strKey.split("_")[4]);
					positions[n] = (String) maps.get(strKey);
				}
			}
			for(String position : positions){
				if(position != null){
					strComponents += position+",";
				}
			}
		}else{
			for (Object key : keys) {
				String strKey = Utility.toSafeString(key);
				if(strKey.startsWith("category_label_")){
					int nComponentID = Utility.toSafeInt(maps.get(strKey));
					if(nComponentID>0){
						strComponents += nComponentID+",";
					}
				}
			}
		}
		for (Object key : keys) {
			String strKey = Utility.toSafeString(key);
			if(strKey.startsWith("category_textbox_")){
				String strLabel = strKey.replace("category_textbox_", "");
				String strValue = Utility.toSafeString(maps.get(strKey));
				if(!"".equals(strValue)){
					for(String str : Utility.getStrArray(strValue)){
						if("".equals(str)){
							strValue = strValue.replace(",,", ",");
						}
					}
					if(strValue.startsWith(",")){
						strValue = strValue.substring(1, strValue.length());
					}else if(strValue.endsWith(",")){
						strValue = strValue.substring(0, strValue.length()-1);
					}
					strValue = strValue.replace(",", "_");
					this.setTempComponentText(strLabel + ":" + strValue);
				}else{
					this.setTempComponentText(strLabel + ":");
					if(!CDict.CUSTORMERTEXT.contains("," +strLabel+",")){//客户指定内容不为空
						strTextValue = ResourceHelper.getValue("Orden_CheckText");
					}
				}
			}else if(strKey.startsWith("component_")){
				int nId=Utility.toSafeInt(strKey.substring(strKey.lastIndexOf("_")+1));
				if(strIds.indexOf(nId+"")<0 && !Utility.contains(strComponents, Utility.toSafeString(nId))){
//					this.setTempComponentID(nId);
					strComponents += nId+",";
				}
			}
		}
		this.setTempCustomer(strFormData);
		Orden orden = this.updateOrdenByParam(strFormData,strComponents);
		this.setTempOrden(orden);
		List<Orden> ordens = new ArrayList<Orden>();
		ordens.add(orden);
		for (int i = 0; i < ordens.size(); i++) {
			ordens.get(i).setStatusID(CDict.OrdenStatusSaving.getID());
		}
		new OrdenManager().submitOrdens(this.getTempCustomer(), ordens);
		
		return getPrice(ordens);
	}
	
	public String getPrice(List<Orden> ordens){
		double free = 0.0;
		for(Orden orden : ordens) {
			free += orden.getOrdenPrice();
		}
		try{
			this.clearTempOrdens();
			int clothingID = ordens.get(ordens.size()-1).getClothingID();
			HttpContext.setSessionValue(CDict.SessionKey_ClothingID, clothingID);
			this.fixCameoDefaultComponents(clothingID);
		}catch(Exception e){}
		
		return String.format("%.2f",free);
		
	}
	public String submitToERP(Orden orden) {
		DataAccessObject dao = new DataAccessObject();
		String strResult = "";
		try {
			if (CDict.OrdenStatusPlateMaking.getID().equals(orden.getStatusID())) {
				String strTemp = new XmlManager().submitToErp(orden);
				System.out.println(strTemp);
				String strCode = "";
				String strContent = "";
				String strReplaceContent = "";
				if (strTemp.length()>0 && !"Bl_Error_152".equals(strTemp) && !"OK".equals(strTemp)) {
					Errors errors=(Errors) XmlManager.doStrXmlToObject(strTemp, Errors.class);
					for(ErrorMessage error : errors.getList()){
						strCode = error.getCode();
						strContent = error.getContent();
						strReplaceContent = error.getReplaceContent();
						if("1".equals(strCode)){//成功，返回code=1，Content=交期
							try {
								SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
								Date date = sf.parse(strContent);
								orden.setJhrq(date);
								dao.saveOrUpdate(orden);
							} catch (Exception e) {
								strResult += " 交期未返回! ";
							}
						}else{//失败，返回code=错误id，Content=错误信息，ReplaceContent=*替换值
							String strErrorValue = "";
							if(strCode.length()>0){//存在code值
								strErrorValue = ResourceHelper.getValue("Bl_Error_"+strCode);
							}else{//无code值
								strErrorValue = strContent;
							}
							if(null!=strReplaceContent){
//								strErrorValue = strErrorValue.replace("*", strReplaceContent) + " ";
								String[] strReplace = strReplaceContent.split("~");//多个*值，以~隔开
								for(int i=0;i<strReplace.length;i++){
									strErrorValue=strErrorValue.replaceFirst("\\*", strReplace[i]);
								}
							}
							strResult += strErrorValue + " ";
						}
					}
					
				}else if("Bl_Error_152".equals(strTemp)){//数据库连接
					strResult += ResourceHelper.getValue("Bl_Error_152") +" ";
				}
				else{
					strResult += " BL未返回信息! ";
				}
				if(strResult.length()>0){//提交失败，保存订单
					orden.setStatusID(CDict.OrdenStatusSaving.getID());
					orden.setMemo("提交BL 失败 ");
					dao.saveOrUpdate(orden);
					List<OrdenDetail> details = orden.getOrdenDetails();
					if (details != null) {
						for (OrdenDetail detail : details) {
							detail.setOrdenID(orden.getOrdenID());
							dao.saveOrUpdate(detail);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		}
		return strResult;
	
	}
	public void saveOrden(Orden orden){
		DataAccessObject dao = new DataAccessObject();
		dao.saveOrUpdate(orden);
	}
}
