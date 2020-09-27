package chinsoft.service.orden;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class GetBlOrdens extends BaseServlet{
	private static final long serialVersionUID = -6898384861459365043L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			
			String strKeyword = getParameter("blKeyword");		
			String strMemberCode = CurrentInfo.getCurrentMember().getCode();

			int nStatusID = Utility.toSafeInt(getParameter("blSearchStatusID"));
			String strPubMemberID = getParameter("blSearchClientID");
			
			int nClothingID = Utility.toSafeInt(getParameter("blSearchClothingID"));

			// 得到下单开始日期
			Date fromDate = null;
			if (getParameter("blFromDate")!=null && !"".equals(getParameter("blFromDate"))) {
				fromDate = Utility.toSafeDateTime(getParameter("blFromDate"));
			}
			
			// 得到下单结束日期
			Date toDate = null;
			if (getParameter("blToDate") !=null && !"".equals(getParameter("blToDate"))) {
				toDate = Utility.toSafeDateTime(getParameter("blToDate"));
			}
			
			// 得到交货开始日期
			Date dealDate = null;
			if (getParameter("blDealDate") != null && !"".equals(getParameter("blDealDate"))) {
				dealDate = Utility.toSafeDateTime(getParameter("blDealDate"));
			}
			
			// 得到交货结束日期
			Date dealToDate = null;
			if (getParameter("blDealToDate")!=null && !"".equals(getParameter("blDealToDate"))) {
				dealToDate = Utility.toSafeDateTime(getParameter("blDealToDate"));
			}
			
			List<Orden> ordens = new OrdenManager().getOrdens(nPageIndex, CDict.PAGE_SIZE, strKeyword, strMemberCode, nStatusID, nClothingID, dealDate, dealToDate,fromDate, toDate, strPubMemberID);
			long nCount = new OrdenManager().getOrdensCount(strKeyword, strMemberCode, nStatusID, nClothingID, dealDate, dealToDate, fromDate, toDate, strPubMemberID);
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(ordens);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetBlOrdens_err"+e.getMessage());
		}
		
	}
}
