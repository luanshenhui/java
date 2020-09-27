package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class SaveOrdenSize extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String strFormData = getParameter("formData");
			Orden orden =null;
			try{
				orden = this.updateOrdenByParam(strFormData,"");
			}catch(Exception e){
				output(e.getMessage());
			}
			orden.setStatusID(CDict.OrdenStatusDesigning.getID());
			this.setTempOrden(orden);
			output(Utility.RESULT_VALUE_OK);
			
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}

	
}