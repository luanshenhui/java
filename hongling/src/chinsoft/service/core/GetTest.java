package chinsoft.service.core;



import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.OrdenManager;
import chinsoft.business.XmlManager;
import chinsoft.entity.Orden;

public class GetTest extends BaseServlet {

	private static final long serialVersionUID = -1759096872257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
//			output(Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_Erp_Address")));
//			output(this.getTempComponentIDs());
//			Orden orden = new OrdenManager().getOrdenByID("XXXX12110047");
//			String strXml = new XmlManager().getXmlFromOrden(orden);
//			System.out.print( strXml);
			System.out.println(request.getParameter("orders"));
//			String strResult = new XmlManager().submitToErp(orden);
//			output(strResult);
		} catch (Exception e) {
			System.out.println(e.getLocalizedMessage());
		}
	}
}

