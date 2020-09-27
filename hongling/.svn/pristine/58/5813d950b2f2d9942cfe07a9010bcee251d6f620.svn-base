package chinsoft.service.orden;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class GetOrdenSize extends BaseServlet {
	private static final long serialVersionUID = -4591305344336387704L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			
			@SuppressWarnings("unchecked")
			List<Orden> ordens =  (List<Orden>)HttpContext.getSessionValue(CDict.SessionKey_Ordens);
			if(ordens == null){
				ordens = new ArrayList<Orden>();
			}
			Orden designingOrden = new Orden();
			for(Orden o : ordens){
				if(CDict.OrdenStatusDesigning.getID().equals(o.getStatusID())){
					designingOrden = o;
				}
			}
			output(designingOrden);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdenSize_err" + e.getMessage());
		}
	}
}
