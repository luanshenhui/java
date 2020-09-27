package centling.service.delivery;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDeliveryManager;
import centling.dto.DeliveryOrdenDetailDto;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class BlGetDeliveryDetailByDeliveryId extends BaseServlet {
	private static final long serialVersionUID = -7547289258771875810L;
	
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			// 得到发货单号
			String strDeliveryID = getParameter("deliveryid");
			List<DeliveryOrdenDetailDto> data = new BlDeliveryManager().getDeliveryDetailByDeliveryId(strDeliveryID);
			output(data);
		} catch (Exception e) {
			LogPrinter.error("BlGetDeliveryDetailByDeliveryId_err"+e.getMessage());
		}
	}
}