package chinsoft.service.dict;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import work.business.DictMG;

import chinsoft.core.HttpContext;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;
import chinsoft.vo.ProductDictVO;

public class GetProductProcess extends BaseServlet {
	private static final long	serialVersionUID	= 1L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		// TODO Auto-generated method stub
		super.service();
		String productId = request.getParameter("productId");
		String strType = Utility.toSafeString(request.getParameter("strType"));
		String strLanguage = Utility.toSafeString(HttpContext.getSessionValue(Utility.SessionKey_Version));
		if (strLanguage.length() <= 0) {
			strLanguage = "1";
		}
		Map<String, List<ProductDictVO>>  map=new DictMG().getAllDictVO(productId,strType);
		output(map);
	}
}
