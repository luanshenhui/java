package hongling.service.distribution;


import hongling.business.LogisticsManager;
import hongling.entity.Logistics;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class GetDistributionList extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			super.service();
			
			int pageNo=Utility.toSafeInt(getParameter("pageindex"));
			String sendto=getParameter("sendtos");
			String sendend=getParameter("sendends");
			String sendmode=getParameter("sendmodes");
			String status=getParameter("statuss");
			String companyid=getParameter("searchCompanyID");
			if("-1".equals(companyid)){
				companyid="";
			}
			if("0".equals(sendmode)){
				sendmode="";
			}
			if("1".equals(sendmode)){
				sendmode="1";
			}
			if("2".equals(sendmode)){
				sendmode="2";
			}
			if("3".equals(sendmode)){
				sendmode="3";
			}
			if("0".equals(status)){
				status="0";
			}
			if("1".equals(status)){
				status="1";
			}
			if("2".equals(status)){
				status="2";
			}
			List<Logistics> logisticses=new LogisticsManager().getLogisticses(pageNo, CDict.PAGE_SIZE, sendto, sendend, sendmode,status,companyid);
			int count=new LogisticsManager().getLogisticsesCount(sendto, sendend, sendmode,status,companyid);
			PagingData page=new PagingData();
			page.setCount(count);
			page.setData(logisticses);
			output(page);
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetDistributionList_err"+e.getMessage());
		}
		
	}
}
