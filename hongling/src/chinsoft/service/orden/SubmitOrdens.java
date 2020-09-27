package chinsoft.service.orden;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.FabricManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Companys;
import chinsoft.entity.Fabric;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class SubmitOrdens extends BaseServlet {

	//saveOrden -> submitOrdens
	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strFormData = getParameter("formData");
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
			String strResult = Utility.RESULT_VALUE_OK;
			List<Orden> ordens = this.getTempOrdens();
			int clothingID = ordens.get(ordens.size()-1).getClothingID();
			for (int i = 0; i < ordens.size(); i++) {
				ordens.get(i).setUserordeNo(Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "userNo")));
			}
			
			String str = new OrdenManager().checkEmbroidery(ordens);//检查刺绣
			str += new OrdenManager().checkNameLabel(ordens);//录客户名牌必录刺绣信息
			str += new OrdenManager().checkEmbroideryContent(ordens);// 检查刺绣内容长度
			str += this.checkProcessBiao(ordens);//检查面料标商标信息
			String strcheckUserOrdenNo= new OrdenManager().checkUserOrdenNo(ordens);//检查客户单号
			str += strcheckUserOrdenNo;
			if(!"".equals(str)){
				for (int i = 0; i < ordens.size(); i++) {
					ordens.get(i).setStatusID(CDict.OrdenStatusSaving.getID());
					ordens.get(i).setComponents(this.processBiao(ordens.get(i)));
					if(!"".equals(strcheckUserOrdenNo)){
						ordens.get(i).setUserordeNo("");
					}
				}
				strResult = str;
			}else{
				for (int i = 0; i < ordens.size(); i++) {
					ordens.get(i).setStatusID(CDict.OrdenStatusPlateMaking.getID());
					ordens.get(i).setComponents(this.processBiao(ordens.get(i)));
					
					//保存企业代码
					Companys companys = (Companys) request.getSession().getAttribute("company");
					if(companys != null){
						ordens.get(i).setCompanysCode(companys.getCompanycode());
					}
					
				}
			}
			ordens= new OrdenManager().embroideContents(ordens);
			String strTempResult = new OrdenManager().submitOrdens(this.getTempCustomer(), ordens);
			if (!"".equals(strTempResult)) {
				strResult += strTempResult;
			}
			try{
				this.clearTempOrdens();
				HttpContext.setSessionValue(CDict.SessionKey_ClothingID, clothingID);
				this.fixCameoDefaultComponents(clothingID);
			}
			catch(Exception e){}
			output(strResult);
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}