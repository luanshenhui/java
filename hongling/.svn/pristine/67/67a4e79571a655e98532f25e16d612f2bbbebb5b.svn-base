package hongling.service.customerassessment;
import hongling.business.CustomerAssessManager;
import hongling.util.DateUtils;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang.StringUtils;
import chinsoft.core.PagingData;
import chinsoft.service.core.BaseServlet;

public class GetAssessReportWithClothcategory extends BaseServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		String category = getParameter("searchKeyword");
		String begintime=getParameter("dealDate");
		Date begindate=null;
		if(StringUtils.isNotBlank(begintime)){
			begindate=DateUtils.parse(begintime, "yyyy-MM-dd");
		}
		List customerPeriodAssessBean=new CustomerAssessManager().getCategoryPeriodAppraiseReport(category, begindate);
		PagingData pagingData = new PagingData();
		pagingData.setCount(customerPeriodAssessBean.size());
		pagingData.setData(customerPeriodAssessBean);
		output(pagingData);
	}

}
