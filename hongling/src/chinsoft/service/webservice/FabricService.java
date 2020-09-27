package chinsoft.service.webservice;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import net.sf.json.JSONObject;
import chinsoft.business.CDict;
import chinsoft.business.FabricManager;
import chinsoft.business.XmlManager;
import chinsoft.core.ConfigHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.Encryption;

public class FabricService {
	private String WebService_Erp_Address = Utility.toSafeString(ConfigHelper
			.getContextParam().get("WebService_Erp_Address"));
	private String WebService_NameSpace = Utility.toSafeString(ConfigHelper
			.getContextParam().get("WebService_NameSpace"));

	public double getFabricStock(String strCode) {
		Object[] params = new Object[] { strCode };
		double dblResult = 0.0;
		try {
			dblResult = Utility.toSafeDouble(XmlManager.invokeService(
					WebService_Erp_Address, WebService_NameSpace,
					"getFabricStock", params, new Class[] { String.class }));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		dblResult = Utility.toSafeDouble(new java.text.DecimalFormat("#.00")
				.format(dblResult));
		return dblResult;
	}

	// @WebParam(name = "加密参数")
	public String getOccupyFabric( String param) {
		String str = "";
		try {
			String strjson = Encryption.decrypt(param, CDict.DES_KEY);
			System.out.println(strjson);
			JSONObject jsonobject = JSONObject.fromObject(strjson);
			Iterator<?> iter = jsonobject.keys();
			String key;
			Object value;
			Map<String, Object> map = new HashMap<String, Object>();
			while (iter.hasNext()) {
				key = (String) iter.next();
				value = jsonobject.get(key);
				map.put(key, value);
			}
			String username = Utility.toSafeString(map.get("username"));
			String code = Utility.toSafeString(map.get("code"));
			String memo = Utility.toSafeString(map.get("memo"));
			String amount = Utility.toSafeString(map.get("amount"));
			str = this.getOccupyFabric(username, code, amount, memo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return str;
	}

	private String getOccupyFabric(String strUsername, String strCode,
			String strAmount, String strMemo) {
		String fabric = "";
		String dd = "";
		FabricManager manager=new FabricManager();
		String result =manager.occupyFabric(strUsername, strCode,strAmount, strMemo);
		dd =Utility.toSafeString(manager.getFabricInventory(strCode));
		if (result == "OK") {

			fabric = "{\"result\":\"TRUE\",\"xtyzsl\":\"" + dd + "\"}";
		} else {
			fabric = "{\"result\":\"FALSE\",\"xtyzsl\":\"" + dd + "\"}";
		}
		return fabric;
	}
}
