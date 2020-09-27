package centling.service.fabric;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.FabricDiscountManager;
import centling.entity.FabricDiscount;
import chinsoft.business.CDict;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

/**
 * 获取促销活动
 * @author Dirk
 *
 */
public class GetFabricDiscounts extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));

			// 得到面料号
			String fabricCode = getParameter("code");
			
			// 促销开始日期
			String startDate = null;
			if (getParameter("startDate") != null && !"".equals(getParameter("startDate"))) {
				startDate = getParameter("startDate");
			}
			
			// 促销结束日期
			String endDate = null;
			if (getParameter("endDate") != null && !"".equals(getParameter("endDate"))) {
				endDate = getParameter("endDate");
			}
			
			List<FabricDiscount> fabricDiscounts = new FabricDiscountManager().getFabricDiscounts(nPageIndex, CDict.PAGE_SIZE, startDate, endDate, fabricCode);
			long nCount = new FabricDiscountManager().getFabricDiscountCount(startDate, endDate, fabricCode);
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(fabricDiscounts);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetFabricDiscounts_err"+e.getMessage());
		}
	}
}