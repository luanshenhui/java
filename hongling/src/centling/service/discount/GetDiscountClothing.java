package centling.service.discount;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlClothingManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetDiscountClothing extends BaseServlet{
	private static final long serialVersionUID = -7603604741749580815L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			
			List<Dict> dicts = new BlClothingManager().getDiscountClothing();
			output(dicts);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
