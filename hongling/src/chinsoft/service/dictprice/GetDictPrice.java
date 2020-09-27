package chinsoft.service.dictprice;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.DictPriceManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Dictprice;
import chinsoft.service.core.BaseServlet;

public class GetDictPrice extends BaseServlet {

	private static final long serialVersionUID = 8773652529479474459L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			String strKeyword = getParameter("keyword");
			List<Dictprice> data = new DictPriceManager().getDictPrices(nPageIndex, CDict.PAGE_SIZE, strKeyword);
			long nCount = new DictPriceManager().getDictPricesCount(strKeyword);

			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("getdictPrices_err" + e.getMessage());
		}
	}
}
