package chinsoft.service.repair;

import hongling.util.DateUtils;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import chinsoft.business.RepairOrdenTwoManager;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

/**
 *  @author lizuoqi
 *  返修2级报表
 *  @time 2015.4.09
 * */
public class GetOrdenTwo extends BaseServlet {

	private static final long serialVersionUID = 1L;
	
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		
		//按 服装品类查询
		String cloth = getParameter("searchClothingID");
		//按 客户名称分类
		String memberName = getParameter("memberName");
		//按时间查询
		String begintime = getParameter("dealDate");
		String pageIndex = getParameter("pageindex");
		
		//处理日期
		Date begindate = null;
		if(StringUtils.isNotBlank(begintime)){
			begindate = DateUtils.parse(begintime, "yyyy-MM-dd");
		}
		
		//得到返修列表集合
		List repairOrdenAssessBean = new RepairOrdenTwoManager().getRepairInfo(begindate, cloth, memberName,Utility.toSafeInt(pageIndex),15);
		List repairOrdenAssess = new RepairOrdenTwoManager().getRepairInfo(begindate, cloth, memberName,0,0);
		
		PagingData pagingData = new PagingData();
		pagingData.setCount(repairOrdenAssess.size());
		pagingData.setData(repairOrdenAssessBean);
		output(pagingData);
	}



}
