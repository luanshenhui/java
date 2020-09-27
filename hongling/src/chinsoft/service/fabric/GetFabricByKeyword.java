package chinsoft.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class GetFabricByKeyword extends BaseServlet {
	private static final long serialVersionUID = 6177371136167941106L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {

			// 获取登陆用户的经营单位
			Member loginUser = CurrentInfo.getCurrentMember();
			int clothingID = Utility.toSafeInt(this.getTempClothingID());
			// 取得检索关键字
			// String strKeyword = getParameter(request,"q");
			String strKeyword = Utility.toUtf8(request.getParameter("q"));
			Integer limit = Utility.toSafeInt(request.getParameter("limit"));
			String strClothingid = request.getParameter("categortid");
			output(new FabricManager().getFabricByKeyword(clothingID,strKeyword,
					strClothingid, loginUser.getBusinessUnit(),limit));
		} catch (Exception e) {
			LogPrinter.debug("GetFabricByKeyword_err" + e.getMessage());
		}
	}
}
