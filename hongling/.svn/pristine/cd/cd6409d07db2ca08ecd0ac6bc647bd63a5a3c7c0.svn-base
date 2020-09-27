package centling.service.cash;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDealManager;
import centling.business.CDealItem;
import centling.entity.Deal;
import chinsoft.business.CashManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Cash;
import chinsoft.service.core.BaseServlet;

public class CashAddNum extends BaseServlet{

	private static final long serialVersionUID = 7722883529244303794L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strFormData = getParameter("formData");
			String ID = EntityHelper.getValueByKey(strFormData, "blId").toString();
			String memberid = EntityHelper.getValueByKey(strFormData, "memberid").toString();
			Double blAddMoneyNum = Double.valueOf(EntityHelper.getValueByKey(strFormData, "blAddMoneyNum").toString());
			
			Cash cash = new CashManager().getCashByID(ID);
			Double newNum = cash.getNum()+blAddMoneyNum;
			cash.setNum(newNum);
			Date date = new Date();
			cash.setPubDate(date);
			new CashManager().saveCash(cash);
			
			Deal deal = new Deal();
			deal.setDealItemId(CDealItem.CUSTOMERSENDMONEY);
			deal.setDealDate(new java.sql.Date(date.getTime()));
			deal.setAccountIn(blAddMoneyNum);
			deal.setMemberId(memberid);
			deal.setLocalNum(newNum);
			new BlDealManager().saveDeal(deal);
			
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.error("BlCashAddNum_err"+e.getMessage());
		}
	}

}
