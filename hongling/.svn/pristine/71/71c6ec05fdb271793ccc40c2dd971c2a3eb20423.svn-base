package chinsoft.service.cash;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.dto.CashDto;
import centling.util.BlDateUtil;
import chinsoft.business.CDict;
import chinsoft.business.CashManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetCashs extends BaseServlet {

	private static final long serialVersionUID = 8773652529479474459L;

	@Override
	protected void service(HttpServletRequest request,	HttpServletResponse response) {
		try {
			super.service();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			String strKeyword = getParameter("keyword");	
			String strFromDate = getParameter("fromDate");
			String strToDate = getParameter("toDate");
			Date fromDate = null;
			Date toDate = null;
			
			if(strFromDate != null && !"".equals(strFromDate)) {
				fromDate = BlDateUtil.parseDate(strFromDate, "yyyy-MM-dd");
			}
			
			if (strToDate != null && !"".equals(strToDate)) {
				toDate = BlDateUtil.parseDate(strToDate, "yyyy-MM-dd");
			}
			
			List<CashDto> data = new CashManager().getCashs(nPageIndex, CDict.PAGE_SIZE,strKeyword,fromDate,toDate);
			long nCount = new CashManager().getCashsCount(strKeyword,fromDate,toDate);

			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("getcashs_err" + e.getMessage());
		}
	}
}
