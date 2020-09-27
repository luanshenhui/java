package chinsoft.service.file;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.AttachmentManager;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetAttachmentByIDs extends BaseServlet{
	private static final long serialVersionUID = 1L;
	
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			String strAttachmentIDs = getParameter("IDs");
			output(new AttachmentManager().getAttachmentByIDs(strAttachmentIDs));
		} catch (Exception e) {
			LogPrinter.error("SelectAttachments:" + e.getMessage());
		}
	}
}
