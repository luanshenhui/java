package chinsoft.service.fabric;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FabricManager;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetPropertyByCategory extends BaseServlet {
	@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			super.service();
			String categoryID=getParameter("categoryid");
			String propertyID="";
			if("8001".equals(categoryID)){
				propertyID="8341";
			}
			if("8050".equals(categoryID)){
				propertyID="8343";
			}
			if("8030".equals(categoryID)){
				propertyID="8342";
			}
			List<Dict> dicts=new FabricManager().getProperty(Utility.toSafeInt(propertyID));
			output(dicts);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
