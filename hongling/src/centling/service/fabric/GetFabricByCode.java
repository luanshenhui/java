package centling.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Fabric;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

/**
 * 根据面料号得到面料信息
 * 
 * @author Dirk
 * 
 */
public class GetFabricByCode extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {

			Member loginUser = CurrentInfo.getCurrentMember();
			// 得到面料号
			String code = getParameter("code");
			Fabric fabric = new FabricManager().getFabricByCode(code);
			// 添加验证
//			if (!new FilterAreaFabric().isOurFabric(
//					loginUser.getBusinessUnit(), fabric)) {
//				// 如果不是 当前登陆用户 所在经销商维护面料价格的 面料 则不显示
//				return;
//			}
			
			output(fabric);
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}
	}
}
