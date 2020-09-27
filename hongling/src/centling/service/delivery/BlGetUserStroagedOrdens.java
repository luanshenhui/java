package centling.service.delivery;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.DeliveryManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.entity.Delivery;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class BlGetUserStroagedOrdens extends BaseServlet {
	private static final long serialVersionUID = 6124115841780231249L;

	/**
	 * 获取用户已入库的订单
	 */
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strDeliveryId = getParameter("deliveryid");
			Delivery delivery = new DeliveryManager().getDeliveryByID(strDeliveryId);
            List<Orden> ordens = delivery.getOrdens();
			
            List<Orden> data = new ArrayList<Orden>();
            
			// 判断订单类型
			if (ordens.size() > 0) {
				Orden orden = ordens.get(0);
				if (CDict.ClothingChenYi.getID().equals(orden.getClothingID())) {
					data = new OrdenManager().getStoragedOrdens(delivery.getPubMemberID(),"shirt");
				} else {
					data = new OrdenManager().getStoragedOrdens(delivery.getPubMemberID(),"nonshirt");
				}
			}
			
			long nCount = 1;
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("BlGetUserStroagedOrdens_err"+e.getMessage());
		}
	}
}