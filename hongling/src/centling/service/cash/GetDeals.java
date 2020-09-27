package centling.service.cash;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDealManager;
import centling.dto.DealDto;
import centling.util.BlDateUtil;
import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetDeals extends BaseServlet{
	
	private static final long serialVersionUID = -9003977917437600880L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strFormData = getParameter("formData");
			String from = getParameter("from");
			List<DealDto> data = null;
			Long nCount = null;
			String blmemberid = "";
			if (from!=null && "front".equals(from)){
				blmemberid = CurrentInfo.getCurrentMember().getID();
			}
			if (from!=null && "hou".equals(from)){
				blmemberid = EntityHelper.getValueByKey(strFormData, "blmemberid").toString();
			}

			String blKeyword = EntityHelper.getValueByKey(strFormData, "blKeyword").toString();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			Date blFromDate = null;
			Date blToDate = null;
			
			String strFromDate = getParameter("blFromDate");
			String strToDate = getParameter("blToDate");
			
			if(strFromDate != null && !"".equals(strFromDate)) {
				blFromDate = BlDateUtil.parseDate(strFromDate, "yyyy-MM-dd");
			}
			
			if (strToDate != null && !"".equals(strToDate)) {
				blToDate = BlDateUtil.parseDate(strToDate, "yyyy-MM-dd");
			}
			
			data = new BlDealManager().getDeals(nPageIndex, CDict.PAGE_SIZE, blmemberid, blKeyword, blFromDate, blToDate);
			nCount = new BlDealManager().getDealsCount(blmemberid, blKeyword, blFromDate, blToDate);
			
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetDeals_err"+e.getMessage());
		}
	}
}
