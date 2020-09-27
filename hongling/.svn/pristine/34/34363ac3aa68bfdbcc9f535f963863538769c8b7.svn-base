package chinsoft.service.orden;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.OrdenManager;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class OrdenFabricMessage extends BaseServlet {
	private static final long serialVersionUID = -4591305344336387796L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String strType = Utility.toSafeString(request.getParameter("strType"));
			String strOrdenID = Utility.toSafeString(request.getParameter("strOrdenID"));
			String strSysCode = Utility.toSafeString(request.getParameter("strSysCode"));
			String strFabricType = Utility.toSafeString(request.getParameter("strFabricType"));
			String strBigFabricLen = Utility.toSafeString(request.getParameter("strBigFabricLen"));
			String strSmallFabricLen = Utility.toSafeString(request.getParameter("strSmallFabricLen"));
			String strFabricCode = Utility.toSafeString(request.getParameter("strFabricCode"));
			String strNewFabricCode = Utility.toSafeString(request.getParameter("strNewFabricCode"));
			System.out.println("strType:"+strType+";strOrdenID:"+strOrdenID+";strSysCode:"+strSysCode+";strFabricType:"+strFabricType+";strBigFabricLen:"+strBigFabricLen+";strSmallFabricLen:"+strSmallFabricLen+";strFabricCode:"+strFabricCode+";strFabricCode:"+strNewFabricCode);
			if("".equals(strSysCode) || strSysCode == null){//零检料不传SysCode
				strSysCode = new OrdenManager().getordenByOrderId(strOrdenID).getSysCode();
			}
			//语言
			if("CS".equals(strSysCode.substring(0, 2))){
				Locale arg=new Locale("en");
				request.getSession().setAttribute("WW_TRANS_I18N_LOCALE", arg);
				HttpContext.setSessionValue(Utility.SessionKey_Version, "2");
			}else{
				Locale arg=new Locale("zh");
				request.getSession().setAttribute("WW_TRANS_I18N_LOCALE", arg);
				HttpContext.setSessionValue(Utility.SessionKey_Version, "1");
			}
			
			//CAD返回--面料不够
			String returns = new OrdenManager().ordenFabric(strType,strOrdenID,strSysCode,strFabricType,strBigFabricLen,strSmallFabricLen,strFabricCode,strNewFabricCode);
			try
			{
				// 写回客户端
//				response.getWriter().write("$.csMessage.success_jsonpCallback('" + returns + "')");
				response.getWriter().write(returns);
			}
			catch (Exception ex)
			{
				ex.printStackTrace();
			}

		} catch (Exception e) {
			LogPrinter.debug("GetOrdenById_err" + e.getMessage());
		}
	}
	
}
