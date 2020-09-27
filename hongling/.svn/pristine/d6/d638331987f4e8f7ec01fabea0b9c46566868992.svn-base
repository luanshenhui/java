package hongling.service.styleUI;

import hongling.business.StyleUIManager;
import hongling.entity.Assemble;
import hongling.entity.KitStyle;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class intoOrden extends BaseServlet {
	private static final long serialVersionUID = -7892754396898316619L;
	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		super.service();
		try {
			String strClothingID = getParameter("clothingID");//服装分类
			String styleID = getParameter("id");//款式ID
			String fabric = getParameter("fabric");//款式ID
			String strProcess = "";
			String strSpecialProcess = "";
			
			if(Utility.toSafeInt(strClothingID)>2){//单件
//				Assemble assemble = new StyleUIManager().getAllAssemblesByClothingID(strClothingID,"",styleID).get(0);
				Assemble assemble = new StyleUIManager().getStyleByCode(styleID,fabric);
				strProcess = assemble.getProcess();
				strSpecialProcess = assemble.getSpecialProcess();
			}else{//套装
			    KitStyle kitStyle = new StyleUIManager().getAllKitStylesByClothingID(strClothingID,styleID,"").get(0);
				String[] strCodes = kitStyle.getCategoryID().split(",");
				for(String code : strCodes){
//					Assemble assemble = new StyleUIManager().getAssembleByCode(code);
					Assemble assemble = new StyleUIManager().getStyleByCode(code,fabric);
					strProcess += assemble.getProcess()+",";
					strSpecialProcess += assemble.getSpecialProcess();
				}
			}
			
			String[] strComponentIDs = Utility.getStrArray(strProcess);
			String[] strComponentTexts = Utility.getStrArray(strSpecialProcess.substring(1, strSpecialProcess.length()));
			for(String id : strComponentIDs){
				Dict dict = DictManager.getDictByID(Utility.toSafeInt(id));
				Dict dictParent = DictManager.getDictByID(dict.getParentID());
				if("10001".equals(Utility.toSafeString(dict.getStatusID()))){
					this.setTempComponentID(Utility.toSafeInt(id));
				}else if("10002".equals(Utility.toSafeString(dict.getStatusID()))){
					if("10050".equals(Utility.toSafeString(dictParent.getIsSingleCheck()))){
						this.setTempComponentID(Utility.toSafeInt(id));
					}else{
						this.setTempParameterID(Utility.toSafeInt(id));
					}
				}else if("10008".equals(Utility.toSafeString(dict.getStatusID()))){
					this.setTempComponentID(Utility.toSafeInt(id));
				}
			}
			for(String texts : strComponentTexts){
				this.setTempComponentText(texts);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("intoOrden_err" + "----" + e.getMessage());
		}
	}
}
