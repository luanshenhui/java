package chinsoft.service.fix;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.FixManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;


public class GetFabrics extends BaseServlet{
	private static final long serialVersionUID = 2374662068001166039L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nType = Utility.toSafeInt(getParameter("id"));
			Member member = CurrentInfo.getCurrentMember();
			String strImg = new FixManager().getFabricImgByParentClothingID(nType,member.getBusinessUnit(),request);
			output(strImg);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
