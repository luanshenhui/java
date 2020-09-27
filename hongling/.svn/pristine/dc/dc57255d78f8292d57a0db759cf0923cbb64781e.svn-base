package chinsoft.service.orden;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetComponentText extends BaseServlet {

	private static final long serialVersionUID = -1759095870257433218L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nParentID = Utility.toSafeInt(getParameter("parentid"));

			List<Dict> texts = new ClothingManager().getComponentText(nParentID);

			output(texts);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}	
}

