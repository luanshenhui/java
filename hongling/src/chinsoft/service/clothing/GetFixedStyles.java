package chinsoft.service.clothing;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.FixedStyleManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.FixedStyle;
import chinsoft.service.core.BaseServlet;

public class GetFixedStyles extends BaseServlet {
	private static final long serialVersionUID = -1759095870257433218L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nClothingID = Utility.toSafeInt(getParameter("singleClothingID"));
			//根据id(Clothing==FixedId)获取固定款式样式
			List<FixedStyle> fixedStyles = new FixedStyleManager().getFixStylesBySingleClothingID(nClothingID);
			output(fixedStyles);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}