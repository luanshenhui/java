package chinsoft.service.information;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.InformationManager;
import chinsoft.core.CVersion;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Information;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class GetInformations extends BaseServlet {

	private static final long serialVersionUID = 8773652529479474459L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			String strKeyword = getParameter("keyword");
			Member member=CurrentInfo.getCurrentMember();
			List<Information> data = new InformationManager().getInformations(nPageIndex, CDict.PAGE_SIZE, strKeyword,CVersion.getCurrentVersionID(),member);
			long nCount = new InformationManager().getInformationsCount(strKeyword,CVersion.getCurrentVersionID(),member);

			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("getinformations_err" + e.getMessage());
		}
	}
}
