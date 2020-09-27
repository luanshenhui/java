package centling.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.FabricPriceManager;
import centling.entity.FabricPrice;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

/**
 * 根据主键查询面料价格
 * @author Dirk
 *
 */
public class GetFabricPriceById extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strFabricPriceId = getParameter("id");
			FabricPrice fabricPrice = new FabricPriceManager().getFabricPriceById(strFabricPriceId);
			fabricPrice.setAreaName(DictManager.getDictNameByID(fabricPrice.getAreaId()));
			output(fabricPrice);
		} catch (Exception e) {
			LogPrinter.debug("GetFabricPriceById_err" + e.getMessage());
		}
	}
}
