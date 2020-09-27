package chinsoft.service.orden;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;


public class GetClothing extends BaseServlet{
	private static final long serialVersionUID = 2374662018001169009L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			List<Dict> dicts = new ClothingManager().getClothing();
			output(dicts);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
