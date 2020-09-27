package chinsoft.service.realmname;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.RealmNameManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.RealmName;
import chinsoft.service.core.BaseServlet;

public class SaveRealmName extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String strFormData = getParameter("formData");
			String strID = EntityHelper.getValueByParamID(strFormData);

			RealmName realmName = new RealmName();
			if(strID.length() > 0){
				realmName = new RealmNameManager().getRealmNameByID(strID);
			}
			realmName = (RealmName) EntityHelper.updateEntityFromFormData(realmName, strFormData);
			new RealmNameManager().saveRealmName(realmName);
			
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			System.out.println(err.getMessage());
			LogPrinter.debug(err.getMessage());
		}
	}
}