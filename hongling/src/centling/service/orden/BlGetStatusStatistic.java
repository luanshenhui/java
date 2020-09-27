package centling.service.orden;

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

/**
 * 获取订单状态
 *
 */
public class BlGetStatusStatistic extends BaseServlet {
	private static final long serialVersionUID = 5764904631423509846L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			// 得到关键字
			String strKeyword = getParameter("blKeyword");	
			// 得到服装种类
			int nClothingID = Utility.toSafeInt(getParameter("blSearchClothingID"));
			
			// 得到下单人
			String strPubMemberID = getParameter("blSearchClientID");
			
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
			
			String strMemberCode = CurrentInfo.getCurrentMember().getCode();
			List<Dict> data = new BlOrdenManager().getStatusStatistic(strKeyword, nClothingID, strPubMemberID, fromDate, 
					toDate, dealDate, dealToDate, strMemberCode);
			output(data);
		} catch (Exception e) {
			LogPrinter.error("BlGetStatusStatistic_err"+e.getMessage());
		}
	}	
}