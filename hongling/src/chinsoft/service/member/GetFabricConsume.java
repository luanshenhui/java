package chinsoft.service.member;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.MemberManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Fabricconsume;
import chinsoft.service.core.BaseServlet;

public class GetFabricConsume extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			String strMemberName = getParameter("username");
			List<Fabricconsume> userdictprices = new MemberManager().GetFabricConsume(nPageIndex, CDict.PAGE_SIZE, strMemberName);
			
			long nCount = new MemberManager().getDictPriceCount(strMemberName);
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(userdictprices);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetDictPrice_err" + e.getMessage());
		}
	}
}
