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

public class GetCustomerOrdenAssessInfo extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		String username = getParameter("searchKeyword");
		String jhrqstart = getParameter("dealDate");
		String jhrqstop = getParameter("dealToDate");
		if(StringUtils.isNotBlank(jhrqstop)){
			Date d=DateUtils.dateAddDay(DateUtils.parse(jhrqstop, "yyyy-MM-dd"), 1) ;
			jhrqstop=DateUtils.formatDate(d, "yyyy-MM-dd");
		}
		
		String pageIndex=getParameter("pageindex");
		List list=new CustomerAssessManager().getAppraiseReport(username, jhrqstart, jhrqstop,Utility.toSafeInt(pageIndex), 15);
		List listcount=new CustomerAssessManager().getAppraiseReport(username, jhrqstart, jhrqstop,0, 0);
		PagingData pagingData = new PagingData();
		pagingData.setCount(listcount.size());
		pagingData.setData(list);
		output(pagingData);
	}
}
