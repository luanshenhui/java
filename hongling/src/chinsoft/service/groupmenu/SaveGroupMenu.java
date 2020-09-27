package chinsoft.service.groupmenu;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.GroupMenuManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.GroupMenu;
import chinsoft.service.core.BaseServlet;

public class SaveGroupMenu extends BaseServlet{
	private static final long serialVersionUID = -6192897803965485696L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		super.service();
		try {
			int nGroupID = Utility.toSafeInt(getParameter("groupid"));
			String strMenuIDs = getParameter("menus");
			GroupMenu groupMenu = new GroupMenu();
			groupMenu.setID(nGroupID);
			
			if ("qorder".equals(getParameter("flag"))) {
				groupMenu.setQorderMenuIDs(strMenuIDs);
			} else {
				groupMenu.setMenuIDs(strMenuIDs);
			}

            new GroupMenuManager().saveGroupMenu(groupMenu);
            output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.info("SaveAuthority_err   "+e.getMessage());
		}
	}
}
