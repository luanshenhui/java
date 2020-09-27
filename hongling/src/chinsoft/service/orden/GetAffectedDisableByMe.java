package chinsoft.service.orden;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetAffectedDisableByMe extends BaseServlet {

	private static final long serialVersionUID = -1759095872257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			Integer nDictID  = Utility.toSafeInt(request.getParameter("id"));
			List<Dict> dicts = new ClothingManager().getAffectedDisableByMe(nDictID);
			output(dicts);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
	
}

