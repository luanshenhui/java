package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.OrdenManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SaveOrdenJhrq extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strResult=Utility.RESULT_VALUE_OK;
			String strFormData = getParameter("formData");
			String strOrdenID = Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "ID"));
			String strNewJhrq = Utility.toSafeString(EntityHelper.getValueByKey(strFormData, "jhrq"));
			strResult = new OrdenManager().saveJhrq(strOrdenID,strNewJhrq);
			output(strResult);
			
		} catch (Exception err) {
			output("error:" + err.getMessage());
		}
	}
	
}