package centling.service.cash;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDealItemManager;
import centling.business.BlDealManager;
import centling.entity.Deal;
import centling.entity.DealItem;
import chinsoft.business.CDict;
import chinsoft.business.CashManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Cash;
import chinsoft.service.core.BaseServlet;

public class SaveDeal extends BaseServlet {
	private static final long serialVersionUID = 3713412403017675129L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String blcashid = getParameter("bldealcashid");
			String blmemberid = getParameter("bldealmemberid");
			Integer blDealItemId = Utility.toSafeInt(getParameter("blDealItems"));
			Double blDealNum = Utility.toSafeDouble(getParameter("blDealNum"));
			String strMemo= getParameter("blMemo");
			
			DealItem dealItem = new BlDealItemManager().getDealItemByID(blDealItemId);
			Cash cash = new CashManager().getCashByID(blcashid);
			
			Double oldNum = cash.getNum();
			Double newNum = cash.getNum();
			try{
				if("2".equals(Utility.toSafeString(blDealItemId))){//下单扣款
					new OrdenManager().updateOrder(strMemo,"10030");
				}else if("82".equals(Utility.toSafeString(blDealItemId))){//撤单退款
					new OrdenManager().updateOrder(strMemo,"10370");//状态为撤销
				}
			}catch(Exception e){}
			Deal deal = new Deal();
			deal.setDealItemId(blDealItemId);
			deal.setDealDate(new Date());
			deal.setMemo(strMemo);
			if (dealItem!=null && blDealNum!=null){
				if (dealItem.getIoFlag() == CDict.IOFLAG_I){
					deal.setAccountIn(blDealNum);
					newNum = oldNum + blDealNum;
				}
				if (dealItem.getIoFlag() == CDict.IOFLAG_O){
					deal.setAccountOut(blDealNum);
					newNum = oldNum - blDealNum;
				}
			}
			// 如果是运费,则保存运单号
			if (blDealItemId==45) {
				deal.setDeliveryId(Utility.toSafeString(getParameter("blYundanId")));
			}
			deal.setMemberId(blmemberid);
			deal.setLocalNum(newNum);
			cash.setNum(newNum);
			cash.setPubDate(new java.util.Date());
			new CashManager().saveCash(cash);
			new BlDealManager().saveDeal(deal);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}
