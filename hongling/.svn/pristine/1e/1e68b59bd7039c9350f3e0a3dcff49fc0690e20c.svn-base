package chinsoft.service.orden;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetAccordion extends BaseServlet {

	private static final long serialVersionUID = -1759095870257533210L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nParentID = Utility.toSafeInt(getParameter("parentid"));
			setTempClothingID(nParentID);
			List<Dict> dicts = new ClothingManager().getAccordion(nParentID);
			HttpContext.setSessionValue("orden_type", "quick");
			output(dicts);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

