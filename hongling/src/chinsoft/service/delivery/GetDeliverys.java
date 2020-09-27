package chinsoft.service.delivery;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DeliveryManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Delivery;
import chinsoft.service.core.BaseServlet;

public class GetDeliverys extends BaseServlet {

	private static final long serialVersionUID = 8773652529479474459L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			String strMemberCode = CurrentInfo.getCurrentMember().getCode();
			List<Delivery> data = new DeliveryManager().getDeliverys(nPageIndex, CDict.PAGE_SIZE, strMemberCode);
			long nCount = new DeliveryManager().getDeliverysCount(strMemberCode);

			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("getdelivery_err" + e.getMessage());
		}
	}
}
