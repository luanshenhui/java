package chinsoft.service.orden;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.OrdenManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Companys;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

/**
 * 保存/提交订单
 * 
 * @author Dirk
 * 
 */
public class SubmitOrden extends BaseServlet {

	private static final long serialVersionUID = -3852715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String strFormData = getParameter("formData");
			if (strFormData.contains("2000part_label_10108")) {
				strFormData = strFormData.replaceAll("2000part_label_10108",
						"part_label_10108");
			}
			int type = Utility.toSafeInt(request.getParameter("type"));

			this.clearTempDesigns();

			this.setTempClothingID(Utility
					.toSafeInt(getParameter("clothingID")));
			String fabricCode =getParameter("fabricCode");
			this.setTempFabricCode(fabricCode);
			
			Map<String, Object> maps = EntityHelper.jsonToMap(strFormData);
			Integer clothID = Utility.toSafeInt((String)maps.get("clothingID"));
			
			Object[] keys = maps.keySet().toArray();
			String strIds = "";
			String strTextValue = "";
			String strComponents = "";
			for (Object key : keys) {
				String strKey = Utility.toSafeString(key);
				if (strKey.startsWith("temp_")) {
					int nId = Utility.toSafeInt(strKey.substring(strKey
							.lastIndexOf("_") + 1));
					strIds += nId + ",";
				}
			}
			
			// 刺绣信息
			String[] clothArr;
			//1把套件的服装分开
			switch (clothID) {
			case 1:
				clothArr = new String[]{"3","2000"};
				break;
			case 2:
				clothArr = new String[]{"3","2000","4000"};
				break;
			case 4:
				clothArr = new String[]{"4000","2000"};
				break;
			case 5:
				clothArr = new String[]{"90000","2000"};
				break;
			case 6:
				clothArr = new String[]{"3","4000"};
				break;
			case 7:
				clothArr = new String[]{"95000","98000"};
				break;
			default:
				clothArr = new String[]{clothID.toString()};
				break;
			}
			//2 按套件进行 拼接
			StringBuffer embroideryBuffer = new StringBuffer();
			for(int i = 0;i<clothArr.length;i++){
				String EmbroideryRegex = "^(category_label_){1}"+clothArr[i]+"(_Color).+$";
				String noStr = "";
				for(Object key : keys){
					String strKey = Utility.toSafeString(key);
					if(strKey.matches(EmbroideryRegex)){
						int n = Utility.toSafeInt(strKey.split("_")[4]);
						noStr += n + ",";
					}
				}
				if(noStr.trim().length() <= 0){
					continue;
				}
				String[] noArr = noStr.split(",");
				Arrays.sort(noArr);
				for(String tempNo: noArr){
					// 位置
					if (null != maps.get("category_label_" + clothArr[i] + "_Position_"	+ tempNo)
							&& !"".equals((String) maps.get("category_label_" + clothArr[i] + "_Position_" + tempNo))) {
						embroideryBuffer.append(","+(String) maps.get("category_label_" + clothArr[i] + "_Position_" + tempNo));
					}
					
					// 颜色
					if (null != maps.get("category_label_" + clothArr[i] + "_Color_"	+ tempNo)
							&& !"".equals((String) maps.get("category_label_" + clothArr[i] + "_Color_" + tempNo))) {
						embroideryBuffer.append("_"+(String) maps.get("category_label_" + clothArr[i] + "_Color_" + tempNo));
					}
					
					// 字体
					if (null != maps.get("category_label_" + clothArr[i] + "_Font_"	+ tempNo)
							&& !"".equals((String) maps.get("category_label_" + clothArr[i] + "_Font_" + tempNo))) {
						embroideryBuffer.append("_"+(String) maps.get("category_label_" + clothArr[i] + "_Font_" + tempNo));
					}
					
					// 字体大小
					if (null != maps.get("category_label_" + clothArr[i] + "_Size_"	+ tempNo)
							&& !"".equals((String) maps.get("category_label_" + clothArr[i] + "_Size_" + tempNo))) {
						embroideryBuffer.append("_"+(String) maps.get("category_label_" + clothArr[i] + "_Size_" + tempNo));
					}
				}
			}
			strComponents = embroideryBuffer.toString();
			
			if(strComponents.startsWith(",")){
				strComponents = strComponents.substring(1,strComponents.length());
			}
			//无刺绣信息 处理
			if(strComponents.trim().length()>0){
				strComponents += ",";
			}
			for (Object key : keys) {
				String strKey = Utility.toSafeString(key);
				if (strKey.startsWith("category_textbox_")) {
					String strLabel = strKey.replace("category_textbox_", "");
					String strValue = Utility.toSafeString(maps.get(strKey));
					if (!"".equals(strValue)) {
						for (String str : Utility.getStrArray(strValue)) {
							if ("".equals(str)) {
								strValue = strValue.replace(",,", ",");
							}
						}
						if (strValue.startsWith(",")) {
							strValue = strValue.substring(1, strValue.length());
						} else if (strValue.endsWith(",")) {
							strValue = strValue.substring(0,
									strValue.length() - 1);
						}
						strValue = strValue.replace(",", "_");
						this.setTempComponentText(strLabel + ":" + strValue);
						if("3000".equals(clothID.toString()) && strValue.equals(fabricCode)){
							strTextValue = ResourceHelper.getValue("Orden_CheckTextFabric");//指定料不能和订单所选面料相同
						}
					} else {
						this.setTempComponentText(strLabel + ":");
						if (!CDict.CUSTORMERTEXT.contains("," + strLabel + ",")) {// 客户指定内容不为空
							strTextValue = ResourceHelper.getValue("Orden_CheckText");
						}
					}
				} else if (strKey.startsWith("component_")) {
					int nId = Utility.toSafeInt(strKey.substring(strKey.lastIndexOf("_") + 1));
					if (strIds.indexOf(nId + "") < 0
							&& !Utility.contains(strComponents,Utility.toSafeString(nId))) {
						strComponents += nId + ",";
					}
				}
			}

			// 获取固化款式中的衬类型
			String[] strProcess = strComponents.split(",");
			boolean bValue = true;
			for (String str : strProcess) {
				if (Utility.contains(CDict.CHEN3, str)) {
					bValue = false;
				}
			}
			if (bValue) {
				for (Object key : keys) {
					String strKey = Utility.toSafeString(key);
					if (strKey.startsWith("styleText_")) {
						String strValue = Utility.toSafeString(maps.get(strKey));
						if ("00C2".equals(strValue)) {
							if ("1".equals(getParameter("clothingID"))
									|| "2".equals(getParameter("clothingID"))
									|| "3".equals(getParameter("clothingID"))) {// 上衣
								strComponents += "30134,";// 中档粘合衬
								break;
							}
						}
					}
				}
			}

			this.setTempCustomer(strFormData);
			// 面料检测
			String strResult = "";
			Integer businessUnit = CurrentInfo.getCurrentMember()
					.getBusinessUnit();
			// 凯妙用户
			if (CDict.BRAND_KAIMIAO.getID().equals(businessUnit)) {
//				strResult = checkFabricCode();
			} else if (CDict.BRAND_HONGLING.getID().equals(businessUnit)
					|| CDict.BRAND_RUIPU.getID().equals(businessUnit)
					|| CDict.BRAND_DIANSHANG.getID().equals(businessUnit)) {

			} else {
//				strResult = checkFabricCode();
			}
			if (strResult.length() > 0) {
				output(strResult);
				return;
			}
			Orden orden =null;
			try{
				orden = this.updateOrdenByParam(strFormData, strComponents);
			}catch(Exception e){
				output(e.getMessage());
			}
			this.setTempOrden(orden);
			List<Orden> ordens = new ArrayList<Orden>();
			ordens.add(orden);
			
			// String str = new OrdenManager().checkEmbroidery(ordens);// 检查刺绣
			String strUserOrdenNo = new OrdenManager().checkUserOrdenNo(ordens);// 检查客户单号
			String str = new OrdenManager().checkEmbroideryContent(ordens);// 检查刺绣内容长度
			str += new OrdenManager().checkNameLabel(ordens);//录客户名牌必录刺绣信息
			str += this.checkProcessBiao(ordens);//检查面料标商标信息
			str += new OrdenManager().checkSemiFinished(ordens);//半成品试衣
			str += new OrdenManager().checkFabricCategroy(ordens);//检查面料类型\面料编码长度不能小于4\禁用面料不能下单
//			str += new OrdenManager().checkLapelWidth(ordens);//检查驳头宽是否在可选范围
			str += strTextValue;//客户指定内容不为空
			strResult = str + strUserOrdenNo;
			if (type > 0) {//保存
				for(Orden o : ordens){
					o.setStatusID(10035);
					if (!"".equals(strUserOrdenNo)) {
						o.setUserordeNo("");
					}
				}
			} else {//制版
				//查询面料是否有库存
//				int nAutoID = Utility.toSafeInt(maps.get("autoID"));
//				if(nAutoID != 10325 && nAutoID != 10326){
//					Double fabricSize =0.0;
//					for (Orden o :ordens) {
//						fabricSize = new FabricManager().getFabricInventory(o.getFabricCode());
//						if (fabricSize <= 0.0){
//							strResult += ResourceHelper.getValue("Bl_Error_230");
//						}
//					}
//				}
				if (!"".equals(strResult)) {
					for(Orden o : ordens){
						o.setStatusID(10035);
						if (!"".equals(strUserOrdenNo)) {
							o.setUserordeNo("");
						}
					}
				} else {
					// 保存企业代码
					Companys companys = (Companys) request.getSession().getAttribute("company");
					for(Orden o : ordens){
						o.setStatusID(10030);
						if (companys != null) {
							o.setCompanysCode(companys.getCompanycode());
						}
					}
				}
			}
			//订单保存时，面料状态为保存并托管-->预提交
			/*if("10035".equals(Utility.toSafeString(ordens.get(0).getStatusID())) 
					&& !"5000".equals(Utility.toSafeString(ordens.get(0).getClothingID()))){
				int nAutoID = Utility.toSafeInt(maps.get("autoID"));
				if(nAutoID == 10325){
					String err = new OrdenManager().preSubmitOrdens(this.getTempCustomer(), ordens,"","","","save");
					if(!"成功了".equals(err.trim()) && !"go!".equals(err.trim())){
						strResult += err;
					}
				}
			}*/
			
			String strTempResult = new OrdenManager().submitOrdens(this.getTempCustomer(), ordens);
			
			if (!"".equals(strTempResult)) {
				strResult += strTempResult;
			}
			if("".equals(strResult)){
				strResult = Utility.RESULT_VALUE_OK;
			}else{
				String backString = strResult;
				if(ordens.size() ==1){
					try {
						String ordenID = ordens.get(0).getOrdenID();
						strResult = ("ordenID:"+ordenID +"&")+strResult;
					} catch (Exception err) {
						strResult = backString;
						LogPrinter.debug(err.getMessage());
					}
				}
			}
			int clothingID = ordens.get(ordens.size() - 1).getClothingID();
			try {
				this.clearTempOrdens();
				HttpContext.setSessionValue(CDict.SessionKey_ClothingID,clothingID);
			} catch (Exception e) {
			}

			output(strResult);
		} catch (Exception err) {
			err.printStackTrace();
			LogPrinter.debug(err.getMessage());
		}
	}
}