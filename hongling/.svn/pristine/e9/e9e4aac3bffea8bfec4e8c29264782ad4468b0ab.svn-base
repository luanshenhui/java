package centling.service.delivery;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetApplyDeliveryDays extends BaseServlet {
	private static final long serialVersionUID = 3854823333357901755L;
	
	/**
	 * 获取发货周期，去掉周天
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			List<Dict> list = new DictManager().getApplyDeliveryDays();
			output(list);
		} catch (Exception e) {
			LogPrinter.error("GetApplyDeliveryDays_err"+e.getMessage());
		}
	}
}