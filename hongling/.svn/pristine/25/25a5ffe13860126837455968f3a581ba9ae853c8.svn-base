package chinsoft.service.member;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.MemberManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Fabricconsume;
import chinsoft.service.core.BaseServlet;

public class SaveFabricConsume extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015724L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strFormData = getParameter("formData");
			Fabricconsume fabricconsume=new Fabricconsume();
			fabricconsume.setSort(EntityHelper.getValueByKey(strFormData, "sort").toString());
			fabricconsume.setFabricsize(Utility.toSafeDouble(EntityHelper.getValueByKey(strFormData, "fabricsize")));
			fabricconsume.setUsername(EntityHelper.getValueByKey(strFormData, "username").toString());
		    new MemberManager().saveFabricconsume(fabricconsume);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			err.printStackTrace();
			LogPrinter.debug(err.getMessage());
		}
	}
}