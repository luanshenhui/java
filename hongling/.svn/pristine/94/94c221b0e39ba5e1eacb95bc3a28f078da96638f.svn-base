package centling.service.cash;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDealItemManager;
import centling.dto.DealItemDto;
import chinsoft.business.CDict;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetDealItems extends BaseServlet{
	private static final long serialVersionUID = -7815492112670073625L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String from = getParameter("from");
			if (from!=null && "BlAddDeal.js".equals(from)){
				output(BlDealItemManager.getAllDealItems());
			} else if (from!=null && "BlDealItemList.js".equals(from)){
				int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
				String blKeyword = getParameter("blKeyword");
				
				List<DealItemDto> data = new BlDealItemManager().getDealItems(nPageIndex, CDict.PAGE_SIZE, blKeyword);
				Long nCount = new BlDealItemManager().getDealItemsCount(blKeyword);
				
				PagingData pagingData = new PagingData();
				pagingData.setCount(nCount);
				pagingData.setData(data);

				output(pagingData);
			}
		} catch (Exception e) {
			LogPrinter.debug("GetDealItems_err"+e.getMessage());
		}
	}
}
