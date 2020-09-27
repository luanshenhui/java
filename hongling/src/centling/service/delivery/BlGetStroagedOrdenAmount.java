package centling.service.delivery;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.DeliveryManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Delivery;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class BlGetStroagedOrdenAmount extends BaseServlet {
	private static final long serialVersionUID = -3204868675914696267L;

	/**
	 * 获取用户已入库订单数量
	 */
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strDeliveryId = getParameter("id");
			Delivery delivery = new DeliveryManager().getDeliveryByID(strDeliveryId);
			List<Orden> ordens = delivery.getOrdens();
			
			long nCount = 0;
			
			// 判断订单类型
			if (ordens.size() > 0) {
				Orden orden = ordens.get(0);
				if (CDict.ClothingChenYi.getID().equals(orden.getClothingID())) {
					nCount = new OrdenManager().getStoragedOrdenAmount(delivery.getPubMemberID(),"shirt");
				} else {
					nCount = new OrdenManager().getStoragedOrdenAmount(delivery.getPubMemberID(),"nonshirt");
				}
			}
			output(nCount);
		} catch (Exception e) {
			LogPrinter.debug("BlGetStroagedOrdenAmount_err"+e.getMessage());
		}
	}
}
