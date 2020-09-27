package chinsoft.service.fabric;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Fabric;
import chinsoft.service.core.BaseServlet;

public class SaveFabric extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String strFormData = getParameter("formData");
			int nFabricID = Utility.toSafeInt(EntityHelper.getValueByParamID(strFormData));

			Fabric fabric = new Fabric();
			if(nFabricID > 0){
				fabric = new FabricManager().getFabricByID(nFabricID);
			}
			
			fabric = (Fabric)EntityHelper.updateEntityFromFormData(fabric, strFormData);
			new FabricManager().saveFabric(fabric);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}