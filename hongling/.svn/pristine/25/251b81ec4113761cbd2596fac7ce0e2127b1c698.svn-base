package chinsoft.service.receiving;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ReceivingManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class RemoveReceivings extends BaseServlet {
	private static final long serialVersionUID = 4070031573008246786L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		// TODO Auto-generated method stub
		try {
			super.service();
			String removedIDs = getParameter("removedIDs");
			output(new ReceivingManager().removeReceivings(removedIDs));
		} catch (Exception err) {
			err.printStackTrace();
			LogPrinter.debug("RemoveOrdens_err" + err.getMessage());
		}
	}

}
