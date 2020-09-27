package centling.service.delivery;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDeliveryManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class BlAddDeliveryDetail extends BaseServlet {
	private static final long serialVersionUID = 6511010352451859230L;
	
	/**
	 *  增加发货单明细
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			// 得到发货单ID
			String strDeliveryId = getParameter("deliveryId");
			
			// 待添加的菜单ID
			String ordenIds = getParameter("ordenIds");
			
			// 更新发货单明细
			new BlDeliveryManager().updateDeliveryDetail(strDeliveryId, ordenIds);
			
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.error("BlAddDeliveryDetail_err"+e.getMessage());
		}
	}
}