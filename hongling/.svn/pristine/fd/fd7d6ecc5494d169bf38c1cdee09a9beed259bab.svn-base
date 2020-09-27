package centling.service.delivery;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.Constant;
import centling.util.BlDateUtil;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class BlCheckDeliveryDate extends BaseServlet{
	private static final long serialVersionUID = 775145834295413632L;
	
	/**
	 * 判断日期是否合理
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		super.service();
		// 设置标志位
		int retFlag = 0;
		// 得到发货日期
		String deliveryDate = getParameter("date");
		
		// 得到最早发货日期
		String earlyDeliveryDate = BlDateUtil.formatDate(BlDateUtil.addWorkDay(new Date(), Constant.BL_DELIVERY_DAYS), "yyyy-MM-dd");
		
		// 判断发货与最早发货日期大小
		// 如果发货日期早于最早发货日期
		if (deliveryDate.compareTo(earlyDeliveryDate) < 0) {
			retFlag = 1;
		} else {
			// 判断发货日期是否为周日
			try {
				Date deliDate = BlDateUtil.parseDate(deliveryDate, "yyyy-MM-dd");
				// 如果是周日
				if (BlDateUtil.getWeekDay(deliDate)==1) {
					retFlag = 2;
				}
			} catch (Exception e) {
				LogPrinter.error("BlCheckDeliveryDate_err"+e.getMessage());
			}
		}
		
		output(retFlag);
	}
}