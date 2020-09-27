package chinsoft.service.fabric;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetColorByCategory extends BaseServlet{

	private static final long serialVersionUID = 8386556300167190420L;
	@Override
	public void service(HttpServletRequest request,	HttpServletResponse response) {
		super.service();
		try {
			String categoryID=getParameter("categoryid");
			List<Dict> dicts=new FabricManager().getColor(Utility.toSafeInt(categoryID));
			output(dicts);
		} catch (Exception e) {
			LogPrinter.debug("GetSeriesByCategory+err"+e.getMessage());
		}
	}
}
