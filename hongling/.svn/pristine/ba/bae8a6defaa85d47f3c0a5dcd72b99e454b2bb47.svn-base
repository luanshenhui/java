package centling.service.cash;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDealItemManager;
import centling.entity.DealItem;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SaveDealItem extends BaseServlet {
	
	private static final long serialVersionUID = 8135118140567212236L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			Integer bldealitemid = Utility.toSafeInt(getParameter("ID"));
			String blDealItemName = getParameter("name");
			Integer blIOFlag = Utility.toSafeInt(getParameter("ioFlag"));
			String blMemo = getParameter("memo");
			String blEn = getParameter("en");

			DealItem dealItem = null;
			if (bldealitemid!=null && bldealitemid!=-1){
				dealItem = new BlDealItemManager().getDealItemByID(bldealitemid);
			} else {
				dealItem = new DealItem();
			}
			dealItem.setName(blDealItemName);
			dealItem.setIoFlag(blIOFlag);
			dealItem.setMemo(blMemo);
			dealItem.setEn(blEn);
			new BlDealItemManager().saveDealItem(dealItem);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}
