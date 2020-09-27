package chinsoft.service.fix;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.core.EntityHelper;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SetTempComponentID extends BaseServlet {

	private static final long serialVersionUID = -1759095871257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			HttpContext.setSessionValue("orden_type", "fix");
			String strFormData = getParameter("formData");
			Map<String, Object> maps = EntityHelper.jsonToMap(strFormData);
			Object[] keys = maps.keySet().toArray();
			for (Object key : keys){
				String strKey = Utility.toSafeString(key);
				String strValues = Utility.toSafeString(maps.get(strKey));
				String[] strComponentID = strValues.split("_");
				for(String str :strComponentID){
					int nComponentID = Utility.toSafeInt(str);
					if(nComponentID>0){
						this.setTempComponentID(nComponentID);
					}
				}
			}
			String strType = getParameter("type");
			String strComponentIDs = getParameter("id");
			
			if("mrgy_val".equals(strType)){//默认工艺
				String[] ids = strComponentIDs.split(";");
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
			}else if("khzd".equals(strType)){//客户指定
				String[] ids = strComponentIDs.split(":");
				this.setTempParameterID(Utility.toSafeInt(ids[0]));
				this.setTempComponentText(ids[0] + ":" + ids[1]);
			}else{//可选工艺
				String[] ids = strComponentIDs.split(",");
				for(int i=0;i<ids.length;i++){
					if(!"".equals(ids[i])){
						this.setTempComponentID(Utility.toSafeInt(ids[i]));
					}
				}
			}
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.info("error" + e.getMessage());
		}
	}
}

