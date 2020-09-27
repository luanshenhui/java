package chinsoft.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class GetFabricByClothingID extends BaseServlet {
	private static final long serialVersionUID = 6177371136167941106L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			// 获取登陆用户的经营单位
			Member loginUser = CurrentInfo.getCurrentMember();
			int clothingID = Utility.toSafeInt(this.getTempClothingID());
			output(new FabricManager().getFabricByClothingID(clothingID,loginUser.getBusinessUnit()));
		} catch (Exception e) {
			LogPrinter.debug("GetFabricByKeyword_err" + e.getMessage());
		}
	}
}
