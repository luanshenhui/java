package chinsoft.service.orden;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetMenu extends BaseServlet {

	private static final long serialVersionUID = -1759095870257433218L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nParentID = Utility.toSafeInt(getParameter("parentid"));
			List<Dict> dicts = new ClothingManager().getMenu(nParentID);
			
			List<Dict> showDicts = new ClothingManager().NotShowOnFront(dicts);
			
			List<Dict> validDicts = new ArrayList<Dict>();
			
			List<Dict> tempComponents = new ClothingManager().getComponentsByIDs(this.getTempComponentIDs());
			
			for(Dict dict :showDicts){
				if(!new ClothingManager().disabledByOther(this.getTempComponentIDs(), dict) &&
						new ClothingManager().allowedByOther(tempComponents, dict)){
					validDicts.add(dict);
				}
			}
			
			output(validDicts);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
	
}

