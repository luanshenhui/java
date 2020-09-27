package hongling.service.kitStyle;

import java.util.Date;

import hongling.business.KitStyleManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class RemoveKitStyles extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015725L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String removedIDs = getParameter("removedIDs");
			String name=CurrentInfo.getCurrentMember().getName();
			Date nTime=new Date();
			output(new KitStyleManager().removeKitStyles(removedIDs,name,nTime));
		} catch (Exception err) {
			LogPrinter.debug("RemoveOrdens_err"+err.getMessage());
		}
	}
}