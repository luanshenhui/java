package chinsoft.service.fabric;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CDictCategory;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetFabricCategoryByTop extends BaseServlet {
	private static final long serialVersionUID = 1108752109869365411L;
	@Override
	public void service(HttpServletRequest request,	HttpServletResponse response) {
		
		try {
			super.service();
			List<Dict> fabricCategoryList=DictManager.getDicts(CDictCategory.FabricCategory.getID(), 0);
			for (int i = 0; i < fabricCategoryList.size(); i++) {
				if (CDict.LININGID.equals(fabricCategoryList.get(i).getID())) {
					fabricCategoryList.remove(i);
				}
			}
			output(fabricCategoryList);
		} catch (Exception e) {
			LogPrinter.debug("GetFabricCategoryByTop_err"+e.getMessage());
		}
		
	}
}
