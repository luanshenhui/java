package centling.service.delivery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDeliveryManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class BlGetHintDeliveryDate extends BaseServlet {
	private static final long serialVersionUID = -2106098881904120368L;

	/**
	 * 根据用户所选的订单及订单日期，得到提示 发货日期
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			// 得到用户所选的发货日期
			String deliveryDate = getParameter("date");
			
			// 得到用户所选的订单
			String strOrdens = getParameter("ordens");
			
			// 得到提示发货日期
			String hintDeliveryDate = new BlDeliveryManager().getHintDeliveryDateByOrden(deliveryDate, strOrdens);
			
			output(hintDeliveryDate);
		} catch (Exception e) {
			LogPrinter.error("BlGetHintDeliveryDate_err"+e.getMessage());
		}
	}
} 