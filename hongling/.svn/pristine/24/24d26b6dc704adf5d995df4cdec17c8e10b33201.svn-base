package hongling.service.fabrictrader;


import hongling.business.FabricTraderManager;
import hongling.util.DateUtils;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetFabricInfoReport extends BaseServlet{
	private static final long serialVersionUID = 1L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response){
		String username = getParameter("searchKeyword");
		String begintime=getParameter("dealDate");
		String pageIndex=getParameter("pageindex");
		String fpareaId=getParameter("fpareaid");
		Date begindate=null;
		if(StringUtils.isNotBlank(begintime)){
			begindate=DateUtils.parse(begintime, "yyyy-MM-dd");
		}
		List list=new FabricTraderManager().getFabricReport(username, Utility.toSafeInt(pageIndex), 15, begindate , fpareaId);
		List listcount=new FabricTraderManager().getFabricReport(username, 0, 0, begindate, fpareaId);
		PagingData pagingData = new PagingData();
		pagingData.setCount(listcount.size());
		pagingData.setData(list);
		output(pagingData);
		
	}

	
}
