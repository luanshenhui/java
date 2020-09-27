package centling.service.delivery;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDeliveryManager;
import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class BlCheckDeliveryDetailExists extends BaseServlet {
	private static final long serialVersionUID = 8557788527116511956L;

	/**
	 * 判断是否有符合条件的发货明细
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			// 得到参数
			String strBlKeyword = getParameter("blDetailKeyword");
			String deliveryFromDate = getParameter("blDeliverFromDate");
			String deliveryToDate = getParameter("blDeliverToDate");
			String from = getParameter("from");
			
			String currentMemberId = "";
			
			if ("qiantai".equals(from)) {
				currentMemberId = CurrentInfo.getCurrentMember().getID();
			}
			// 表头信息集合
			List<Map<String, String>> headMapList = new BlDeliveryManager().getBatchHeadMapList(currentMemberId,strBlKeyword, deliveryFromDate, deliveryToDate);
			
			if (headMapList!=null && headMapList.size() > 0) {
				output(Utility.RESULT_VALUE_OK);
			} else {
				output("failure");
			}
		} catch (Exception e) {
			LogPrinter.error("BlCheckDeliveryDetailExists_err"+e.getMessage());
		}
	}
}