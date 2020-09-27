package chinsoft.service.receiving;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.ReceivingManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.entity.Receiving;
import chinsoft.service.core.BaseServlet;

public class GetReceivings extends BaseServlet {
	
	private static final long serialVersionUID = -4094386997484831938L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));

			int nClothingID = Utility.toSafeInt(getParameter("searchClothingID"));
//			String strMemberCode=Utility.toSafeString(getParameter("searchClientID"));
			String strOwnedStore=Utility.toSafeString(getParameter("searchClientID"));//门店
			String strMemberCode= CurrentInfo.getCurrentMember().getCode();//当前用户Code

			String fromDate = null;
			if (getParameter("fromDate") != null && !"".equals(getParameter("fromDate"))) {
				fromDate = Utility.toSafeString(getParameter("fromDate"));
			}
			String toDate = null;
			if (getParameter("toDate") != null && !"".equals(getParameter("toDate"))) {
				toDate = Utility.toSafeString(getParameter("toDate"));
			}
			List<Receiving> Receivings = new ReceivingManager().getReceivings(nPageIndex,CDict.PAGE_SIZE,strMemberCode,strOwnedStore,nClothingID, fromDate, toDate);
			long nCount = new ReceivingManager().getReceivingsCount(strMemberCode,strOwnedStore,nClothingID,fromDate, toDate);
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(Receivings);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdens_err"+e.getMessage());
		}
	}
}
