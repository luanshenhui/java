package chinsoft.service.dictprice;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictPriceManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dictprice;
import chinsoft.service.core.BaseServlet;

public class SaveDictPrice extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String strFormData = getParameter("formData");
			String strDictpriceID = EntityHelper.getValueByParamID(strFormData);
			Dictprice dictprice = null;
			if(!strDictpriceID.equals("")){
				dictprice = new DictPriceManager().getDictPriceByID(strDictpriceID);
			}
			
			if(dictprice == null){
				dictprice = new Dictprice();
			}
			
			dictprice = (Dictprice) EntityHelper.updateEntityFromFormData(dictprice, strFormData);
			
			new DictPriceManager().saveDictPrice(dictprice);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}