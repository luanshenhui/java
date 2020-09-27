package chinsoft.service.orden;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Detail;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetMediumComponent extends BaseServlet {

	private static final long serialVersionUID = -1759095872257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			String strComponentIDs = this.getTempComponentIDs();
			
			String strFabricCode = getTempFabricCode();
			int nComponentID  = Utility.toSafeInt(getParameter("componentid"));
			Dict component = DictManager.getDictByID(nComponentID);
			List<Detail> details = new ClothingManager().getMediumComponents(strComponentIDs, strFabricCode, component);
			
			for(Detail detail : details){
				this.checkDetail(request, detail);
			}
			output(trimDetails(details));
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

