package centling.service.delivery;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDeliveryManager;
import centling.dto.DeliveryDetailDto;
import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetBlDeliveryDetail extends BaseServlet{

	private static final long serialVersionUID = -2679230862734776115L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			String blDetailKeyword = getParameter("blDetailKeyword");
			String from = getParameter("from");
			String currentMemberId = "";
			Date deliverFromDate = null;
			Date deliverToDate = null;
			
			if(!"".equals(getParameter("blDeliverFromDate")) && !"".equals(getParameter("blDeliverToDate"))){
				deliverFromDate = Utility.toSafeDateTime(getParameter("deliverFromDate"));
				deliverToDate = Utility.toSafeDateTime(getParameter("deliverToDate"));
			}
			
			if (!from.trim().toLowerCase().equals("houtai")){
				currentMemberId = CurrentInfo.getCurrentMember().getID();
			}
			List<DeliveryDetailDto> blDeliveryDetailDtos = new BlDeliveryManager().getBlDeliveryDetailList(
					nPageIndex, CDict.PAGE_SIZE, currentMemberId, blDetailKeyword, deliverFromDate, deliverToDate);
			long nCount = new BlDeliveryManager().getBlDeliveryDetailCount(currentMemberId, blDetailKeyword, deliverFromDate, deliverToDate);
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(blDeliveryDetailDtos);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetBlDeliveryDetail_err"+e.getMessage());
		}
		
	}
}
