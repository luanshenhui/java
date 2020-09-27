package centling.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.FabricDiscountManager;
import centling.entity.FabricDiscount;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;


/**
 * 保存面料打折促销
 * @author Dirk
 *
 */
public class SaveFabricDiscount extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			String strFormData = getParameter("formData");
			FabricDiscount fabricDiscount = new FabricDiscount();
			fabricDiscount = (FabricDiscount)EntityHelper.updateEntityFromFormData(fabricDiscount, strFormData);
			String memberIds = getParameter("memberId");
			new FabricDiscountManager().save(fabricDiscount, memberIds);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}
	}
}