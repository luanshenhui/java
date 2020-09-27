package chinsoft.service.alipay;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.business.Alipay;
import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.OrdenManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

/**
 * 保存/提交订单
 * @author Dirk
 *
 */
public class SubmitOrden extends BaseServlet {

	private static final long serialVersionUID = -3852715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String strFormData = getParameter("formData");
			if(strFormData.contains("2000part_label_10108")){
				strFormData=strFormData.replaceAll("2000part_label_10108", "part_label_10108");
			}
			
			this.clearTempDesigns();
			
			this.setTempClothingID(Utility.toSafeInt(getParameter("clothingID")));
			
			this.setTempFabricCode(getParameter("fabricCode"));
			
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
					if(strKey.startsWith("category_label_3000_Position_") && !"-1".equals(maps.get(strKey))){
						int n = Utility.toSafeInt(strKey.split("_")[4]);
						positions[n] = (String) maps.get(strKey);
					}else if(strKey.startsWith("category_label_3000_") && !"-1".equals(maps.get(strKey))){
						strComponents += (String) maps.get(strKey) + ",";
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
						strComponents += nId+",";
					}
				}
			}
			this.setTempCustomer(strFormData);
			//面料检测
			String strResult="";
			Integer businessUnit=CurrentInfo.getCurrentMember().getBusinessUnit();
			// 凯妙用户
			if (CDict.BRAND_KAIMIAO.getID().equals(businessUnit)) {
				
			}else if (CDict.BRAND_HONGLING.getID().equals(businessUnit) || CDict.BRAND_RUIPU.getID().equals(businessUnit)){
				
			}else{
				strResult=checkFabricCode();
			}
			if (strResult.length()>0) {
				output(strResult);
				return ;
			}
			Orden orden = this.updateOrdenByParam(strFormData,strComponents);
			this.setTempOrden(orden);
			List<Orden> ordens = new ArrayList<Orden>();
			orden.setLocking(1);
			ordens.add(orden);
			
			strResult = Utility.RESULT_VALUE_OK;
			int clothingID = ordens.get(ordens.size()-1).getClothingID();
			
			String str = this.checkProcessBiao(ordens);
			String strLapel = new OrdenManager().checkLapelWidth(ordens);
			String strUserOrdenNo = new OrdenManager().checkUserOrdenNo(ordens);//检查客户单号
			if(!"".equals(str) || !"".equals(strLapel) || !"".equals(strTextValue) || !"".equals(strUserOrdenNo)){
				for (int i = 0; i < ordens.size(); i++) {
					ordens.get(i).setStatusID(CDict.OrdenStatusSaving.getID());
				}
				if(!"".equals(strUserOrdenNo)){
					for (int i = 0; i < ordens.size(); i++) {
						ordens.get(i).setUserordeNo("");
					}
				}
				strResult = str +" "+ strLapel +" "+strTextValue+" "+strUserOrdenNo;
			}else{
				for (int i = 0; i < ordens.size(); i++) {
					ordens.get(i).setStatusID(CDict.OrdenStatusStayPayments.getID());
				}
			}
			String strTempResult = new OrdenManager().submitOrdens(this.getTempCustomer(), ordens);
			if(!"".equals(strTempResult)){
				strResult = strTempResult;
			}
			try{
				this.clearTempOrdens();
				HttpContext.setSessionValue(CDict.SessionKey_ClothingID, clothingID);
			}
			catch(Exception e){}
			if(Utility.RESULT_VALUE_OK.equals(strResult)){
				output(Utility.RESULT_VALUE_OK+new Alipay().Charge(Utility.toSafeString(ordens.get(0).getOrdenID()), Utility.toSafeString(ordens.get(0).getOrdenPrice())));
			}else{
				output(strResult);
			}
		} catch (Exception err) {
			err.printStackTrace();
			LogPrinter.debug(err.getMessage());
		}
	}
}