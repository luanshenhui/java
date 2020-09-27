package chinsoft.service.realmname;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.RealmNameManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.RealmName;
import chinsoft.service.core.BaseServlet;

public class GetRealmNames extends BaseServlet {

	private static final long serialVersionUID = 8773652529479474459L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			String strKeyword = getParameter("keyword");
			List<RealmName> data = new RealmNameManager().getRealmNames(nPageIndex, CDict.PAGE_SIZE, strKeyword);
			long nCount = new RealmNameManager().getRealmNamesCount(strKeyword);

			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetRealmNames_err" + e.getMessage());
		}
	}
}
