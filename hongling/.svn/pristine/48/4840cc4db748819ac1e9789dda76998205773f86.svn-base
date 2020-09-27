package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetDisabledByOther extends BaseServlet{
	private static final long serialVersionUID = -6898384861459365043L;
	@Override
	protected void service(HttpServletRequest request,	HttpServletResponse response) {
		try {
			String strComponentIDs=request.getParameter("ids");
			int nDictID=Utility.toSafeInt(request.getParameter("id"));
			Dict component=DictManager.getDictByID(nDictID);
			Boolean data=new ClothingManager().disabledByOther(strComponentIDs, component);
			output(data);
		} catch (Exception e) {
			System.out.println(e.getLocalizedMessage());
			LogPrinter.debug("GetOrdens_err"+e.getMessage());
		}
	}
}
