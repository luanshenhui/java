package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class ValidateStyleProc extends BaseServlet {
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strID = getParameter("dictID");// 款式号
			int clothingID = Utility.toSafeInt(getParameter("clothingID"));// 服装大类
			String procInputs = getParameter("procInputs");// 已经输入的工艺
			if (null == procInputs || "".equals(procInputs)) {
				output(false);
				return;
			}
			while(procInputs.startsWith(",")) {
				procInputs = procInputs.substring(1,
						procInputs.length());
			}
			while(procInputs.endsWith(",")){
				procInputs = procInputs.substring(0,
						procInputs.lastIndexOf(","));
			}
			
			boolean isConflict = new OrdenManager().validateStyleProc(
					procInputs, strID, clothingID);
			output(isConflict);
		} catch (Exception err) {
			err.printStackTrace();
			LogPrinter.debug(err.getMessage());
		}
	}
}
