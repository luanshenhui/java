package chinsoft.service.orden;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class GetTempOrdens extends BaseServlet {

	private static final long serialVersionUID = -1759095872257453214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			List<Orden> ordens = this.getTempOrdens();
			List<Orden> savingOrdens = new ArrayList<Orden>();
			for(Orden o : ordens){
				if(CDict.OrdenStatusSaving.getID().equals(o.getStatusID())){
					savingOrdens.add(o);
				}
			}
			PagingData pagingData = new PagingData();
			pagingData.setData(savingOrdens);

			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
	
}

