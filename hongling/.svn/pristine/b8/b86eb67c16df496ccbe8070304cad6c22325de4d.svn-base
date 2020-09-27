package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;
import hongling.entity.FabricWareroom;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import chinsoft.business.DictManager;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetFabricWareroomById extends BaseServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		try {
			super.service();
			String id=getParameter("id");
			FabricWareroom fabricWareroom=new FabricWareroom();
			fabricWareroom=new FabricWareroomManager().getFabricWareroomByID(id);
			if(fabricWareroom != null){
				fabricWareroom.setPropertyName(DictManager.getDictNameByID(Utility.toSafeInt(fabricWareroom.getProperty())));
			}
			output(fabricWareroom);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
