package centling.service.delivery;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DeliveryManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.entity.Delivery;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class BlGetUserFinshedOrdens extends BaseServlet {
	private static final long serialVersionUID = 4703894127007211977L;
	/**
	 * 获取用户已入库或生产中的订单
	 */
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strDeliveryId = getParameter("deliveryid");
			Delivery delivery = new DeliveryManager().getDeliveryByID(strDeliveryId);
			List<Orden> data = new OrdenManager().getFinishedOrdens(delivery.getPubMemberID());
			long nCount = 1;
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdens_err"+e.getMessage());
		}
	}
}
