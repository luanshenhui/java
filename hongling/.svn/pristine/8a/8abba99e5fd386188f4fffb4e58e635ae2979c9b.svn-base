package centling.service.delivery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDeliveryManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class BlSaveYunDanId extends BaseServlet {
	private static final long serialVersionUID = -4575579442237489166L;
	
	/**
	 * 更新运单号
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			// 得到发货ID
			String deliveryId = getParameter("deliveryId");
			// 得到运单号
			String yundanId = getParameter("yundanId");
			// 保存运单号
			new BlDeliveryManager().updateYunDanIdByDeliveryId(deliveryId, yundanId);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.error("BlSaveYunDanId_err"+e.getMessage());
		}
	}
}