package rcmtm.member;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import rcmtm.business.RcmtmManager;
import rcmtm.entity.ErrorInfo;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class RemoveOrdens extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015725L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String result ="";
			String removedIDs = getParameter("removedIDs");
			Orden o = new Orden();
			o.setOrdenID(removedIDs);
			List<Orden> ordens = new ArrayList<Orden>();
			ordens.add(o);
			//善融待删除批次号
			result = new RcmtmManager().deleteBatchNo(ordens);
			output(result);
		} catch (Exception err) {
			LogPrinter.debug("RemoveOrdens_err"+err.getMessage());
		}
	}

}