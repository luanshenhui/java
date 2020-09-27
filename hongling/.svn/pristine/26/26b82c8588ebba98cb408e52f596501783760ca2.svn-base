package chinsoft.service.cash;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CashManager;
import chinsoft.business.MemberManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Cash;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class SaveCash extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String strFormData = getParameter("formData");
			String strCashID = EntityHelper.getValueByParamID(strFormData);
			String strUsername = getParameter("username");
			Cash cash = null;
			if(!strCashID.equals("")){
				cash = new CashManager().getCashByID(strCashID);
			}
			
			if(cash == null){
				cash = new Cash();
				Member member = new MemberManager().getMemberByUsername(strUsername);
				if(member != null){
					cash.setPubMemberID(member.getID());
				}
				cash.setPubDate(new Date());
			}
			
			cash = (Cash) EntityHelper.updateEntityFromFormData(cash, strFormData);
			
			if (cash.getNum()==null){
				cash.setNum(Double.valueOf(0));
			}
			new CashManager().saveCash(cash);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}