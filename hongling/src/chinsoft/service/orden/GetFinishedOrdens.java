package chinsoft.service.orden;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class GetFinishedOrdens extends BaseServlet{
	private static final long serialVersionUID = -6898385861459365043L;
	/**
	 * 手动申请发货列表
	 */
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strMemberID = CurrentInfo.getCurrentMember().getID();
			List<Orden> data = new OrdenManager().getFinishedOrdens(strMemberID);
			long nCount = 1;
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(data);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdens_err"+e.getMessage());
		}
	}
}
