package chinsoft.service.orden;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class GetOrdensByDeliveryID extends BaseServlet{

	private static final long serialVersionUID = -6898384861459365043L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strDeliveryID = getParameter("deliveryid");
			List<Orden> data = new OrdenManager().getOrdensByDeliveryID(strDeliveryID);
			output(data);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdens_err"+e.getMessage());
		}
	}
}
