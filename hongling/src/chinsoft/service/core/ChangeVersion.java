package chinsoft.service.core;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;

public class ChangeVersion extends BaseServlet{
	
	private static final long serialVersionUID = 88074467611947928L;
	private String strVersionID;
	
	public String getStrVersionID() {
		return strVersionID;
	}

	public void setStrVersionID(String strVersionID) {
		this.strVersionID = strVersionID;
	}

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			if (strVersionID==null) {
				strVersionID = getParameter("versionid");
			}
			if (strVersionID!=null&&"2".equals(strVersionID)) {
				Locale arg1=new Locale("en");
				request.getSession().setAttribute("WW_TRANS_I18N_LOCALE", arg1);
			}
			if (strVersionID!=null&&"3".equals(strVersionID)) {
				Locale arg1=new Locale("de");
				request.getSession().setAttribute("WW_TRANS_I18N_LOCALE", arg1);
			}
			if (strVersionID!=null&&"4".equals(strVersionID)) {
				Locale arg1=new Locale("fr");
				request.getSession().setAttribute("WW_TRANS_I18N_LOCALE", arg1);
			}
			if (strVersionID!=null&&"5".equals(strVersionID)) {
				Locale arg1=new Locale("ja");
				request.getSession().setAttribute("WW_TRANS_I18N_LOCALE", arg1);
			}
			if (strVersionID==null||"1".equals(strVersionID)) {
				Locale arg1=new Locale("zh");
				request.getSession().setAttribute("WW_TRANS_I18N_LOCALE", arg1);
			}
			HttpContext.setSessionValue(Utility.SessionKey_Version, strVersionID);
			strVersionID = null;
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
