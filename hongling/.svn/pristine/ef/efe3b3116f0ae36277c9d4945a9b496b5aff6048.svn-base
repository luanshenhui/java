package chinsoft.service.core;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CoderManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetCode extends BaseServlet {

	private static final long serialVersionUID = 8254527345115894391L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strCode ="";
			String strType = getParameter("type");
			if("bom".equals(strType)){//查询技术BOM
				String strModel = getParameter("model2T");
				String strFabric = getParameter("fabricsT");
				strCode = strModel +","+strFabric;
			}else if("redCode".equals(strType)){//红领编号->客供面料编号
				strCode = getParameter("redCodeT");
			}else if("retailerCode".equals(strType)){//客供面料编号->红领编号
				strCode = getParameter("retailerCodeT");
			}else if("basiscoding".equals(strType)){//基本编号->市场款式
				strCode = getParameter("basiscodingT");
			}else if("model".equals(strType)){//市场款式->基本编号
				strCode = getParameter("modelT");
			}
			String str = new CoderManager().getBom(strType, strCode);
			output(str);
		} catch (Exception e) {
			LogPrinter.error("GetMessageByID_err" + e.getMessage());
		}
	}
}