package hongling.service.assemble;

import hongling.business.AssembleManager;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetStyleListByType extends BaseServlet {
	@Override
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		try {
			super.service();
			String type=getParameter("formData");
			int styleId=0;
			if("3".equals(type)){
				styleId=30884;
			}
			if("2000".equals(type)){
				styleId=40185;
			}
			if("4000".equals(type)){
				styleId=4657;
			}
			List<Dict> styles=new AssembleManager().getStyleListByType(styleId);
			output(styles);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
}
