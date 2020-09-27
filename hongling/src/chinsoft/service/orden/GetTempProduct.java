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
import chinsoft.service.core.BaseServlet;

public class GetTempProduct extends BaseServlet {

	private static final long serialVersionUID = -1759095872257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			String strComponentIDs = this.getTempComponentIDs();

			String strFabricCode = getTempFabricCode();
			
			int nViewID  = Utility.toSafeInt(getParameter("viewid"));
			int nCurrentComponentID = Utility.toSafeInt(HttpContext.getSessionValue(CDict.SessionKey_CurrentComponentID));
			
			Dict singleClothing = new ClothingManager().getSingleClothingByComponentID(nCurrentComponentID);
			if(singleClothing == null){
				singleClothing = getSingleClothingByClothingID();
			}
			List<Detail> d = new ClothingManager().getProduct(strFabricCode, strComponentIDs, nViewID, singleClothing);

			List<Detail> details = trimDetails(d);
			
			for(Detail detail:details){
				checkDetail(request, detail);
			}
			List<Detail> result = trimDetails(details);

			output(result);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}

	private Dict getSingleClothingByClothingID() {
		Dict singleClothing = null;
		Dict clothing = DictManager.getDictByID(Utility.toSafeInt(this.getTempClothingID()));
		if(clothing != null){
			if(clothing.getExtension() != null && !"".equals(clothing.getExtension())){
				String[] clothings = Utility.getStrArray(clothing.getExtension());
				if(clothings.length > 0){
					singleClothing = DictManager.getDictByID(Utility.toSafeInt(clothings[0]));
				}
			}
		}
		return singleClothing;
	}
}

