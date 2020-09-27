package centling.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.FabricPriceManager;
import centling.entity.FabricPrice;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

/**
 * 按区域、大类(套装、衬衣)保存面料价格
 * @author Dirk
 *
 */
public class SavePriceFabric extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String strFormData = getParameter("formData");
			FabricPrice fabricPrice = new FabricPrice();
			fabricPrice = (FabricPrice)EntityHelper.updateEntityFromFormData(fabricPrice, strFormData);
			// 如果是编辑,设置区域ID
			if (fabricPrice.getID() != null && !"".equals(fabricPrice.getID())) {
				fabricPrice.setAreaId(Utility.toSafeInt(getParameter("oriAreaId")));
			}
			new FabricPriceManager().saveOrUpdate(fabricPrice);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}
	}
}
