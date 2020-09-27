package chinsoft.service.orden;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetOrdenStatistic extends BaseServlet{
	private static final long serialVersionUID = -6898385861459365043L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			List<?> data = getOrdenStatistic(request);
			output(data);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdenStatisticerr"+e.getMessage());
		}
	}
	public List<?> getOrdenStatistic(HttpServletRequest request) {
		String strMemberID = getParameter("memberid");
		int moneySignID=Utility.toSafeInt(getParameter("moneySignid"));
		int statusID=Utility.toSafeInt(getParameter("ordenStatusID"));
		boolean bAll = false;
		if("-1".equals(strMemberID)){
			strMemberID = CurrentInfo.getCurrentMember().getID();
			bAll = true;
		}
		Date from = Utility.toSafeDateTime(getParameter("from"));
		Date to = Utility.toSafeDateTime(getParameter("to"));
		List<?> data = new OrdenManager().getOrdenStatistic(bAll, strMemberID, from ,to,moneySignID,statusID);
		return data;
	}
}
