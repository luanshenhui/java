package chinsoft.service.member;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Userdictprice;
import chinsoft.service.core.BaseServlet;

public class GetDictPrice extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));

			// 得到工艺代码
			String code = getParameter("code");
			String strMemberName = null;
			if (getParameter("username") != null && !"".equals(getParameter("username"))) {
				strMemberName = getParameter("username");
			}
			List<Userdictprice> userdictprices = new DictManager().getDictPrices(nPageIndex, CDict.PAGE_SIZE, strMemberName, code);
			long nCount = new DictManager().getDictPriceCount(strMemberName, code);
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(userdictprices);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetDictPrice_err" + e.getMessage());
		}
	}
}
