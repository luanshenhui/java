package centling.service.discount;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDiscountManager;
import centling.dto.DiscountDto;
import chinsoft.business.CDict;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetDiscounts extends BaseServlet{
	private static final long serialVersionUID = 3398974581487369013L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			List<DiscountDto> data = null;
			Long nCount = null;
			
			String strFormData = getParameter("formData");
			String blmemberid = getParameter("memberid");
			String blKeyword = EntityHelper.getValueByKey(strFormData, "searchKeywords").toString();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			
			data = new BlDiscountManager().getDiscounts(nPageIndex, CDict.PAGE_SIZE, blmemberid, blKeyword);
			nCount = new BlDiscountManager().getDiscountsCount(blmemberid, blKeyword);
			
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetDiscounts_err"+e.getMessage());
		}
	}
}
