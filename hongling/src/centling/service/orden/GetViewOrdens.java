package centling.service.orden;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlOrdenManager;
import centling.dto.DeliveredOrdenDto;
import chinsoft.business.CDict;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetViewOrdens extends BaseServlet{
	private static final long serialVersionUID = 711546053430760457L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			
			String strKeyword = getParameter("searchKeywords");		

//			int nStatusID = CDict.STATUS_DELIVERED.getID();//已发货
			int nStatusID = Utility.toSafeInt(getParameter("searchStatus"));
			String strPubMemberID = getParameter("searchClientID");
			
			int nClothingID = Utility.toSafeInt(getParameter("searchClothingID"));

			Date pubDate = null;
			Date pubToDate = null;
			if(!"".equals(getParameter("pubDate")) && !"".equals(getParameter("pubToDate"))){
				pubDate = Utility.toSafeDateTime(getParameter("pubDate"));
				pubToDate = Utility.toSafeDateTime(getParameter("pubToDate"));
			}
			Date deliveryDate = null;
			Date deliveryToDate = null;
			if(!"".equals(getParameter("deliveryDate")) && !"".equals(getParameter("deliveryToDate"))){
				deliveryDate = Utility.toSafeDateTime(getParameter("deliveryDate"));
				deliveryToDate = Utility.toSafeDateTime(getParameter("deliveryToDate"));
			}
			Date dealDate = null;
			Date dealToDate = null;
			if(!"".equals(getParameter("dealDate")) && !"".equals(getParameter("dealToDate"))){
				dealDate = Utility.toSafeDateTime(getParameter("dealDate"));
				dealToDate = Utility.toSafeDateTime(getParameter("dealToDate"));
			}
			List<DeliveredOrdenDto> blDeliveredOrdenDtos = new BlOrdenManager().getBlDeliveredOrdenDtos(
					nPageIndex, CDict.PAGE_SIZE, strKeyword, nStatusID, 
					nClothingID, pubDate, pubToDate, deliveryDate, deliveryToDate,dealDate, dealToDate, strPubMemberID);
			long nCount = new BlOrdenManager().getBlDeliveredOrdenDtosCount(strKeyword, nStatusID, nClothingID, 
					pubDate, pubToDate, deliveryDate, deliveryToDate, dealDate, dealToDate, strPubMemberID);
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(blDeliveredOrdenDtos);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdens_err"+e.getMessage());
		}
	}
}
