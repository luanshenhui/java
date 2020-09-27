package hongling.service.styleUI;

import java.util.List;
import hongling.business.StyleUIManager;
import hongling.entity.Assemble;
import hongling.entity.KitStyle;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetStyleMenus extends BaseServlet {
	private static final long serialVersionUID = -7892754396898316791L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		super.service();
		try {
			String strClothingID = getParameter("clothingID");
			if(Utility.toSafeInt(strClothingID)>2){
//				List<Assemble> assembles = new StyleUIManager().getAllAssemblesByClothingID(strClothingID,"","");
				List<Assemble> assembles = new StyleUIManager().getAllStyleByClothingID(strClothingID,"","");
				output(assembles);
			}else{
				List<KitStyle> kitStyles = new StyleUIManager().getAllKitStylesByClothingID(strClothingID,"","");
				output(kitStyles);
			}
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetStyleMenus_err" + "----" + e.getMessage());
		}
	}
}
