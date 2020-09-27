package chinsoft.service.dict;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetDictsByParent extends BaseServlet{
	private static final long serialVersionUID = 5434333432826474384L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			String categoryID=getParameter("categoryid");
			String parentID=getParameter("parentid");
			List<Dict> dicts =DictManager.getDicts(Utility.toSafeInt(categoryID), Utility.toSafeInt(parentID));
			output(dicts);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
