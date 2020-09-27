package chinsoft.service.ordenView;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.business.CDict;
import chinsoft.business.ClothingManager;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Detail;
import chinsoft.entity.Dict;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class GetOrdenImageByID extends BaseServlet {
	private static final long serialVersionUID = -4591305344336387654L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			int nSingleClothingID = Utility.toSafeInt(getParameter("singleClothingID"));
			String strOrdenID = getParameter("ordenID");
			String strFabricCode = "";
			String strComponentIDs = "";
			Orden orden = this.getOrdenByID(strOrdenID);
			if(nSingleClothingID == -1){
				Dict dict= DictManager.getDictByID(orden.getClothingID());
				String[] arr = dict.getExtension().split(","); 
				nSingleClothingID = Utility.toSafeInt(arr[0]);
			}
			strFabricCode = orden.getFabricCode();
			strComponentIDs = orden.getComponents()==null?"":orden.getComponents();
			Dict singleClothing = DictManager.getDictByID(nSingleClothingID);
			int nViewID = CDict.ViewFront.getID();
			List<Dict> defaultComponent = new ClothingManager().getDefaultComponent(nSingleClothingID, strFabricCode);
			if("".equals(strComponentIDs)){
				for (Dict component : defaultComponent) {
					strComponentIDs += component.getID()+",";
				}
				strComponentIDs = strComponentIDs.substring(0, strComponentIDs.length()-1);
			}
			String[] strTemps = strComponentIDs.split(",");
			int componentParentID = 0;
			int parentID = 0;
			String tmp = "";
			
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
