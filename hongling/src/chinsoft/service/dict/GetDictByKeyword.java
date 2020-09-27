package chinsoft.service.dict;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetDictByKeyword extends BaseServlet{
	private static final long serialVersionUID = 2374662218021169009L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nParentID = Utility.toSafeInt(request.getParameter("parentID"));
			String strKeyword=request.getParameter("q");
			output( new DictManager().getDictByKeyword(nParentID, strKeyword));
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug(e.getMessage());
		}
	}
}
