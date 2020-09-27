package centling.service.expresscom;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlExpressComManager;
import centling.entity.ExpressCom;
import chinsoft.business.CDict;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

/**
 * 
 * 快递公司Servlet
 */
public class BlExpressComQuery extends BaseServlet {
	private static final long serialVersionUID = 1L;
	
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			String strKeyword = this.getParameter("keyword");
			List<ExpressCom> data = new BlExpressComManager().getExpressComs(nPageIndex, CDict.PAGE_SIZE, strKeyword);
			long count = new BlExpressComManager().getExpressComCount(strKeyword);
			PagingData pagingData = new PagingData();
			pagingData.setCount(count);
			pagingData.setData(data);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.error("getExpressCom_err" + e.getMessage());
		}
	}
}
