package chinsoft.service.member;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Userdictprice;
import chinsoft.service.core.BaseServlet;

public class SaveDictPrice extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015724L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strFormData = getParameter("formData");
			Userdictprice userdictprice=new Userdictprice();
			userdictprice.setCode(EntityHelper.getValueByKey(strFormData, "code").toString());
			userdictprice.setPrice(Utility.toSafeDouble(EntityHelper.getValueByKey(strFormData, "price")));
			userdictprice.setUsername(EntityHelper.getValueByKey(strFormData, "username").toString());
		    new DictManager().saveDictPrice(userdictprice);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			err.printStackTrace();
			LogPrinter.debug(err.getMessage());
		}
	}
}