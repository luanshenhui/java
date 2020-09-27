package hongling.service.kitStyle;

import hongling.business.KitStyleManager;
import hongling.entity.KitStyle;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.service.core.BaseServlet;

public class GetKitStyleByID extends BaseServlet {
	@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		
		try {
			super.service();
			String id=getParameter("id");
			KitStyle kitstyle=new KitStyleManager().getKitStyleByID(id);
			//款式风格
			String styleName = DictManager.getDictNameByID(kitstyle.getStyleID());
			kitstyle.setStyleName(styleName);
			output(kitstyle);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
}
