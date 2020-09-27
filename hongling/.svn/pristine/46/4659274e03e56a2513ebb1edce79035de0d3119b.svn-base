package chinsoft.service.orden;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlOrdenManager;
import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetStatusStatistic extends BaseServlet{
	private static final long serialVersionUID = -6898385961459365043L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			// 得到关键字
			String strKeyword = getParameter("keyword");	
			// 得到服装种类
			int nClothingID = Utility.toSafeInt(getParameter("searchClothingID"));
			
			// 得到下单人
			String strPubMemberID = getParameter("searchClientID");
			
			// 得到下单开始日期
			Date fromDate = null;
			if (getParameter("fromDate")!=null && !"".equals(getParameter("fromDate"))) {
				fromDate = Utility.toSafeDateTime(getParameter("fromDate"));
			}
			
			// 得到下单结束日期
			Date toDate = null;
			if (getParameter("toDate") !=null && !"".equals(getParameter("toDate"))) {
				toDate = Utility.toSafeDateTime(getParameter("toDate"));
			}
			
			// 得到交货开始日期
			Date dealDate = null;
			if (getParameter("dealDate") != null && !"".equals(getParameter("dealDate"))) {
				dealDate = Utility.toSafeDateTime(getParameter("dealDate"));
			}
			
			// 得到交货结束日期
			Date dealToDate = null;
			if (getParameter("dealToDate")!=null && !"".equals(getParameter("dealToDate"))) {
				dealToDate = Utility.toSafeDateTime(getParameter("dealToDate"));
			}
			
			String strMemberCode = CurrentInfo.getCurrentMember().getCode();
			List<Dict> data = new BlOrdenManager().getStatusStatistic(strKeyword, nClothingID, strPubMemberID, fromDate, 
					toDate, dealDate, dealToDate, strMemberCode);
			output(data);
		} catch (Exception e) {
			LogPrinter.debug("GetStatusStatistic"+e.getMessage());
		}
	}
}
