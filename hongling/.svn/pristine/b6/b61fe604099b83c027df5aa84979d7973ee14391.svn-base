package chinsoft.service.orden;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.HttpContext;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class SaveOrden extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String strFormData = getParameter("formData");
			if(strFormData.contains("2000part_label_10108")){
				strFormData=strFormData.replaceAll("2000part_label_10108", "part_label_10108");
			}
			//面料检测
			String strResult="";
			Integer businessUnit=CurrentInfo.getCurrentMember().getBusinessUnit();
			// 凯妙用户
			if (CDict.BRAND_KAIMIAO.getID().equals(businessUnit)) {
//				strResult=checkFabricCode();
			}else if (CDict.BRAND_HONGLING.getID().equals(businessUnit) || CDict.BRAND_RUIPU.getID().equals(businessUnit)
					|| CDict.BRAND_DIANSHANG.getID().equals(businessUnit)){
				
			}else{
				strResult=checkFabricCode();
			}
			if (strResult.length()>0) {
				output(strResult);
				return ;
			}
			Orden orden =null;
			try{
				orden = this.updateOrdenByParam(strFormData,"");
			}catch(Exception e){
				output(e.getMessage());
			}
			orden.setBxlb(Utility.toSafeString(HttpContext.getSessionValue("SESSION_BXLB")));
			orden.setStatusID(CDict.OrdenStatusSaving.getID());
			
			if(orden.getComponents() != null && !"".equals(orden.getComponents())){
				String newComponts=orden.getComponents()+",";
				String[] compont = orden.getComponents().split(",");
				Map<String,String> map = new HashMap<String,String>();
				map.put("1222","397");//上衣外珠边
				map.put("1224","1228");//上衣内珠边
				map.put("2530","2206");//西裤珠边明线
				map.put("4641","4130");//马夹珠边明线
				map.put("6609","6375");//大衣珠边明线
				Set<String> key = map.keySet();
				String strComponents = this.getTempComponentIDs();
		        for (Iterator it = key.iterator(); it.hasNext();) {
		            String mapkey = (String) it.next();
		            String mapvalue = (String) map.get(mapkey);
		            if(Utility.contains(strComponents, mapkey)){
		            	for(int i=0;i<compont.length;i++){
							Dict dict = DictManager.getDictByID(Utility.toSafeInt(compont[i]));
							if(mapvalue.equals(Utility.toSafeString(dict.getParentID()))){
								newComponts=newComponts.replace(compont[i]+",", "");
							}
						}
		            }
		        }
		        
				if(!"".equals(newComponts) && ",".equals(newComponts.substring(newComponts.length()-1))){
					orden.setComponents(newComponts.substring(0, newComponts.length()-1));
				}else{
					orden.setComponents(newComponts);
				}
			}
			
			this.setTempOrden(orden);
			new OrdenManager().Embroid(orden);
			output(Utility.RESULT_VALUE_OK);
			
		} catch (Exception err) {
			err.printStackTrace();
//			output("error:" + err.getMessage());
		}
	}

	
}