package chinsoft.service.orden;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CDictCategory;
import chinsoft.business.ClothingManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetParameters extends BaseServlet {

	private static final long serialVersionUID = -1759095870257433218L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nParentID = Utility.toSafeInt(getParameter("parentid"));

			String strComponentIDs = this.getTempComponentIDs();
			
			List<Dict> parameters = DictManager.getDicts(CDictCategory.ClothingCategory.getID(),nParentID);

			List<Dict> validParameters = new ArrayList<Dict>();
			List<Dict> components = new ClothingManager().getComponentsByIDs(strComponentIDs);
			for(Dict parameter:parameters){
				if(!new ClothingManager().disabledByOther(strComponentIDs, parameter) && new ClothingManager().allowedByOther(components, parameter)){
					if(parameter != null){
						if(!CDict.YES.getID().equals(parameter.getNotShowOnFront())){
							validParameters.add(parameter);
						}
					}
				}
			}
			
			output(CurrentInfo.getAuthorityFunction(validParameters));
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

