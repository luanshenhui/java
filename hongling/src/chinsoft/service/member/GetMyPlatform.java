package chinsoft.service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class GetMyPlatform extends BaseServlet {

	private static final long serialVersionUID = -1759095872257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			String strMyPlatformUrl = "orden.jsp";//专业版
			if(CurrentInfo.isAdmin()){
				strMyPlatformUrl = "backend.htm";//后台管理
			}
			Member member =CurrentInfo.getCurrentMember();
			if(member.getHomePage() == 20118){
//				strMyPlatformUrl = "../fashion/fashion.htm";
				strMyPlatformUrl = "../fix/fix.jsp";//时尚版
			}else if(member.getHomePage() == 20121){
//				strMyPlatformUrl = "orden_page.jsp";
				strMyPlatformUrl = "/hongling/orden/dordenPage.do";//快速下单
			}
			output(strMyPlatformUrl);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

