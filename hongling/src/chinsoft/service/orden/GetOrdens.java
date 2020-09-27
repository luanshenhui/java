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

public class GetOrdens extends BaseServlet{
	private static final long serialVersionUID = -6898384861459365043L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			
			String strKeyword = getParameter("keyword");		
			String strMemberCode = CurrentInfo.getCurrentMember().getCode();

			int nStatusID = Utility.toSafeInt(getParameter("searchStatusID"));
			String strPubMemberID = getParameter("searchClientID");
			
			int nClothingID = Utility.toSafeInt(getParameter("searchClothingID"));

			Date fromDate = null;
			if (getParameter("fromDate") != null && !"".equals(getParameter("fromDate"))) {
				fromDate = Utility.toSafeDateTime(getParameter("fromDate"));
			}
			Date toDate = null;
			if (getParameter("toDate") != null && !"".equals(getParameter("toDate"))) {
				toDate = Utility.toSafeDateTime(getParameter("toDate"));
			}
			Date dealDate = null;
			Date dealToDate = null;
			if(getParameter("dealDate") != null &&!"".equals(getParameter("dealDate"))){
				dealDate = Utility.toSafeDateTime(getParameter("dealDate"));
			}
			if (getParameter("dealToDate")!=null && !"".equals(getParameter("dealToDate"))) {
				dealToDate = Utility.toSafeDateTime(getParameter("dealToDate"));
			}
			
			List<Orden> ordens = new OrdenManager().getOrdens(nPageIndex, CDict.PAGE_SIZE, strKeyword, strMemberCode, nStatusID, nClothingID, dealDate, dealToDate,fromDate, toDate, strPubMemberID);
			long nCount = new OrdenManager().getOrdensCount(strKeyword, strMemberCode, nStatusID, nClothingID, dealDate, dealToDate, fromDate, toDate, strPubMemberID);
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(ordens);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdens_err"+e.getMessage());
		}
		
	}
}
