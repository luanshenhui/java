package hongling.service.customerassessment;
import java.util.Date;
import java.util.List;
import hongling.business.CustomerAssessManager;
import hongling.util.DateUtils;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang.StringUtils;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetAssessReportWithCustomername extends BaseServlet{

	private static final long serialVersionUID = 1L;
	
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		String username=getParameter("searchKeyword");
		String begintime=getParameter("dealDate");
		String pageIndex=getParameter("pageindex");
		Date begindate=null;
		if(StringUtils.isNotBlank(begintime)){
			begindate=DateUtils.parse(begintime, "yyyy-MM-dd");
		}
		List  customerPeriodAssessBean=new CustomerAssessManager().getCustomerPeriodAppraiseReport(username,begindate,Utility.toSafeInt(pageIndex),15);
		List  totalcustomerPeriodAssess=new CustomerAssessManager().getCustomerPeriodAppraiseReport(username,begindate,0,0);
		PagingData pagingData = new PagingData();
		pagingData.setCount(totalcustomerPeriodAssess.size());
		pagingData.setData(customerPeriodAssessBean);
		output(pagingData);
	}
	
}
