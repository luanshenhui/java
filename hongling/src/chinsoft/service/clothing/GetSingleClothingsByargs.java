package chinsoft.service.clothing;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetSingleClothingsByargs extends BaseServlet {
	@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		
		try {
			super.service();
			String clothingId=getParameter("categoryid");
			List<Dict> singleClothings = new ClothingManager().getSingleClothings(Utility.toSafeInt(clothingId));
			output(singleClothings);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//System.out.println(clothingId);
		
	}
}
