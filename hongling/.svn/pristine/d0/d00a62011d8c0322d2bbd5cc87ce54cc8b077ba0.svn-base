package chinsoft.service.orden;

import hongling.business.StyleProcessManager;
import hongling.entity.StyleProcess;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import chinsoft.business.CDict;
import chinsoft.business.DictManager;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;
import chinsoft.service.core.Encryption;

public class BackOrder extends BaseServlet {
	private static final long serialVersionUID = -4591305344336387404L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		super.service();
		
		String strParam = Utility.toSafeString(request.getParameter("param"));
		try {
			//解密
			String strUniondata = Encryption.decrypt(strParam, CDict.DES_KEY);
//			String strUniondata = "{\"categoryID\":\"3000\",\"fabricNo\":\"SDA117A\",\"processCode\":\"YSL000025\"}";
//			String strUniondata = "{\"categoryID\":\"1\",\"fabricNo\":\"DSA001A\",\"processCode\":\"KSZ000002,FSZ000001\"}";
			
			//解析JSON
			JSONObject jsonObj = JSONObject.fromObject(strUniondata);
			String strCategoryID = jsonObj.getString("categoryID");//服装分类
			String strFabricNo = jsonObj.getString("fabricNo");//面料
			String strProcessCode = jsonObj.getString("processCode");//工艺款式
			
			//设置
			this.setTempClothingID(Utility.toSafeInt(strCategoryID));//服装分类
			this.setTempFabricCode(strFabricNo);//面料
//			this.setTempFabricCode("MTDshirt");//面料
//			this.setTempFabricCode("MTDsuit");//面料
			
			String[] strAllProcessCode =strProcessCode.split(",");
			for(String code : strAllProcessCode){
				//根据
				StyleProcess sp = new StyleProcessManager().getStyleProcessByCode(code,strFabricNo);
				String strProcessID = sp.getProcess();
				String strProcessContent = sp.getSpecialProcess();
				
				//普通工艺
				if(!"".equals(strProcessID) && strProcessID != null){
					String strProcess[] = strProcessID.split(",");
					for(String str : strProcess){
						Dict dict = DictManager.getDictByID(Utility.toSafeInt(str));
						Dict dictParent = DictManager.getDictByID(Utility.toSafeInt(dict.getID()));
						if("10001".equals(Utility.toSafeString(dict.getStatusID())) //单选工艺
								|| "10050".equals(Utility.toSafeString(dictParent.getIsSingleCheck()))){
							this.setTempComponentID(Utility.toSafeInt(str));
						}else if("10002".equals(Utility.toSafeString(dict.getStatusID()))
								|| "10008".equals(Utility.toSafeString(dict.getStatusID()))){//多选工艺
							this.setTempParameterID(Utility.toSafeInt(str));
						}
					}
				}
				
				//指定工艺
				if(!"".equals(strProcessContent) && strProcessContent != null){
					String strSpecials[] = strProcessContent.split(",");
					for(String str : strSpecials){
						if(!"".equals(str)){
							this.setTempComponentText(str);
						}
					}
				}
			}
			
			//页面跳转
				response.sendRedirect("/hongling/pages/common/orden.jsp");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
	}
}
