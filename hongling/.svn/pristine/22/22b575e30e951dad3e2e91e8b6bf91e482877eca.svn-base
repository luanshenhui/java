package centling.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.FabricDiscountManager;
import centling.entity.FabricDiscount;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetFabricDiscountById extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			// 得到主键
			String id = getParameter("id");
			FabricDiscount fabricDiscount = new FabricDiscountManager().getFabricDiscountById(id);
			output(fabricDiscount);
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}
	}
}