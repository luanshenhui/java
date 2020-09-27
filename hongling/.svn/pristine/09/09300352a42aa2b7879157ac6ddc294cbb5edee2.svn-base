package hongling.service.fabrictrader;

import hongling.business.FabricTraderManager;
import hongling.entity.FabricTrader;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.business.CDict;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetFabricTraderList extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		try {
			super.service();
			int pageNo=Utility.toSafeInt(getParameter("pageindex"));
			String keyword=getParameter("searchKeyword");
			List<FabricTrader> traders=new FabricTraderManager().getFabricTraderList(pageNo, CDict.PAGE_SIZE, keyword);
			int count=new FabricTraderManager().getFabricTraderCount(keyword);
			PagingData page=new PagingData();
			page.setCount(count);
			page.setData(traders);
			output(page);
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetDistributionList_err"+e.getMessage());
		}
	}
}
