package centling.service.fabric;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.FabricPriceManager;
import centling.entity.FabricPrice;
import chinsoft.business.CDict;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

/**
 * 根据面料编号，查询面料列表
 * @author Dirk
 *
 */
public class GetFabricPriceByCode extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			// 得到当前页数
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			
			// 得到面料编号
			String fabricCode = getParameter("code");
			
			// 得到面料价格列表
			List<FabricPrice> list = new FabricPriceManager().getFabricPriceList(nPageIndex, CDict.PAGE_SIZE, fabricCode);
			
			// 得到总条数 
			long nCount = new FabricPriceManager().getFabricPriceCount(fabricCode);
			
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(list);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.error("GetFabricPriceByCode_err"+e.getMessage());
		}
	}
}