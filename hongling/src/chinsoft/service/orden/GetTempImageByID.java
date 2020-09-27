package chinsoft.service.orden;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.business.CDict;
import chinsoft.business.ClothingManager;
import chinsoft.business.DictManager;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Detail;
import chinsoft.entity.Dict;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class GetTempImageByID extends BaseServlet {
	private static final long serialVersionUID = -4591305344336387654L;
	@SuppressWarnings("unchecked")
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nSingleClothingID = Utility.toSafeInt(getParameter("singleClothingID"));
			String strOrdenID = getParameter("ordenID");
			String strFabricCode = "";
			String strComponentIDs = "";
			Dict singleClothing = new  Dict();
			List<Orden> ordens =  (List<Orden>)HttpContext.getSessionValue(CDict.SessionKey_Ordens);
			for(Orden orden:ordens){
				if(strOrdenID.equals(orden.getOrdenID())){
					strFabricCode = orden.getFabricCode();
					strComponentIDs = orden.getComponents();
					singleClothing = DictManager.getDictByID(nSingleClothingID);
				}
			}
			int nViewID = CDict.ViewFront.getID();
			
			String[] strTemps = strComponentIDs.split(",");
			int componentParentID = 0;
			int parentID = 0;
			String tmp = "";
			List<Dict> defaultComponent = new ClothingManager().getDefaultComponent(nSingleClothingID, strFabricCode);
			if(nSingleClothingID == CDict.ClothingShangYi.getID() && !"".equals(strComponentIDs)){
				for(int i=0;i<strTemps.length;i++){
					componentParentID = DictManager.getDictByID(Utility.toSafeInt(strTemps[i])).getParentID();
					for(int j=0;j<strTemps.length;j++){
						int tmpParentID = DictManager.getDictByID(Utility.toSafeInt(strTemps[j])).getParentID();
						parentID = DictManager.getDictByID(Utility.toSafeInt(tmpParentID)).getParentID();
						if(componentParentID == parentID){
							tmp = strTemps[j];//common lapel 
						}
					}
				}
				strComponentIDs = strComponentIDs.replace(tmp, "");
			}
			for(int i=0;i<strTemps.length;i++){
				if(!"".equals(strTemps[i])){
					componentParentID = DictManager.getDictByID(Utility.toSafeInt(strTemps[i])).getParentID();
					for(int j=0;j<defaultComponent.size();j++){
						if(componentParentID == defaultComponent.get(j).getParentID()){
							defaultComponent.remove(j);
						}
					}
				}
			}
			for(int i=0;i<strTemps.length;i++){
				if(!"".equals(strTemps[i])){
					componentParentID = DictManager.getDictByID(Utility.toSafeInt(strTemps[i])).getParentID();
					for(int j=0;j<defaultComponent.size();j++){
						if(nSingleClothingID == CDict.ClothingShangYi.getID()){
							parentID = DictManager.getDictByID(Utility.toSafeInt(componentParentID)).getParentID();
							if(parentID ==defaultComponent.get(j).getParentID()){
								defaultComponent.remove(j);//fix lapel
							}
						}
					}
				}
			}
			for (Dict component : defaultComponent) {
				strComponentIDs +=","+component.getID();
			}
			List<Detail> details = new ClothingManager().getProduct(strFabricCode, strComponentIDs, nViewID, singleClothing);
			output(details);
			
		} catch (Exception e) {
			LogPrinter.debug("GetOrdenById_err" + e.getMessage());
			System.out.println(e.getMessage());
		}
	}
}
