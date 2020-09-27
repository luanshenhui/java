package chinsoft.service.repair;

import hongling.bean.CustomerPeriodAssessBean;
import hongling.business.CustomerAssessManager;
import hongling.util.DateUtils;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import chinsoft.bean.RepairOrdenBean;
import chinsoft.business.RepairOrdenManager;
import chinsoft.core.PagingData;
import chinsoft.service.core.BaseServlet;

public class GetOrderOne extends BaseServlet{
	private static final long serialVersionUID = 1L;
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		String category = getParameter("searchKeyword");  //获取品类名称
		String begintime=getParameter("dealDate");        //获取时间
		Date begindate=null;
		if(StringUtils.isNotBlank(begintime)){
			begindate=DateUtils.parse(begintime, "yyyy-MM-dd");
		}
		List<RepairOrdenBean> repairOrdenBean=new RepairOrdenManager().getOrdenOneReport(category, begindate);
		PagingData pagingData = new PagingData();
		pagingData.setCount(repairOrdenBean.size());
		pagingData.setData(repairOrdenBean);
		output(pagingData);
	}

}
