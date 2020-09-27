package chinsoft.service.dict;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.CVersion;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class DictToResource  extends BaseServlet{

	private static final long serialVersionUID = -7827405090831445911L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();

			DictManager.DictToResource(CVersion.Cn.getID());
//			DictManager.DictToResource(CVersion.Ja.getID());
//			DictManager.DictToResource(CVersion.En.getID());
//			DictManager.DictToResource(CVersion.De.getID());
//			DictManager.DictToResource(CVersion.Fr.getID());

			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
