package centling.service.delivery;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDeliveryManager;
import centling.dto.DeliveryDto;
import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetBlDelivery extends BaseServlet {
	private static final long serialVersionUID = -1368717238877685775L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			// 得到当前页数
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			// 得到关键字
			String blKeyword = getParameter("blDetailKeyword");
			// 得到标识 （前台、后台）
			String from = getParameter("from");
			// 用户名
			String currentMemberId = "";
			// 发货开始日期
			String deliverFromDate = null;
			// 发货结束日期
			String deliverToDate = null;
			
			// 设置开始日期
			if(!"".equals(getParameter("blDeliverFromDate"))) {
				deliverFromDate = getParameter("blDeliverFromDate");
			}
			
			// 设置结束日期
			if (!"".equals(getParameter("blDeliverToDate"))){
				deliverToDate = getParameter("blDeliverToDate");
			}
			
			// 如果是前台，则设置用户名
			if (!"houtai".equals(from.trim().toLowerCase())){
				currentMemberId = CurrentInfo.getCurrentMember().getID();
			}
			
			// 得到发货列表
			List<DeliveryDto> list = new BlDeliveryManager().getBlDeliveryList(
					nPageIndex, CDict.PAGE_SIZE, currentMemberId, blKeyword, deliverFromDate, deliverToDate);
			long nCount = new BlDeliveryManager().getBlDeliveryCount(
					currentMemberId, blKeyword, deliverFromDate, deliverToDate);
			
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(list);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.error("GetBlDelivery_err"+e.getMessage());
		}
	}
}