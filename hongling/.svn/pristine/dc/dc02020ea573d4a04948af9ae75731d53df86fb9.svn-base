package chinsoft.service.orden;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.ClothingManager;
import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetParameterCategory extends BaseServlet {

	private static final long serialVersionUID = -1759095870257433218L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nParentID  = Utility.toSafeInt(getParameter("parentid"));
			String strComponentIDs = this.getTempComponentIDs();
			
			List<Dict> parameterCategorys = new ClothingManager().getParameterCategory(nParentID);
			List<Dict> validCategorys = new ArrayList<Dict>();
			for(Dict parameterCategory:parameterCategorys){
				if(!new ClothingManager().disabledByOther(strComponentIDs, parameterCategory)){
					if(!CDict.YES.getID().equals(parameterCategory.getNotShowOnFront())){
						validCategorys.add(parameterCategory);
					}
				}
			}

			output(CurrentInfo.getAuthorityFunction(validCategorys));
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}	
}

