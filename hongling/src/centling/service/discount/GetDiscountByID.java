package centling.service.discount;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDiscountManager;
import centling.entity.Discount;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetDiscountByID  extends BaseServlet{
	private static final long serialVersionUID = -4529125818785869369L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String discountId = getParameter("ID");
			Discount discount = new BlDiscountManager().getDiscountByID(discountId);
			output(discount);
		} catch (Exception e) {
			LogPrinter.debug("GetDealItemByID_err"+e.getMessage());
		}
	}
}
