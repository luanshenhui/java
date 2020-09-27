package centling.service.delivery;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.Constant;
import centling.util.BlDateUtil;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class BlGetDefaultDeliveryDate extends BaseServlet{
	private static final long serialVersionUID = 4408618824863846137L;

	/**
	 * 获取默认发货日期
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			Date date = BlDateUtil.addWorkDay(new Date(), Constant.BL_DELIVERY_DAYS);
			String defaultDate = BlDateUtil.formatDate(date, "yyyy-MM-dd");
			output(defaultDate);
		} catch (Exception e) {
			LogPrinter.error("BlGetDefaultDeliveryDate_err"+e.getMessage());
		}
	}
}