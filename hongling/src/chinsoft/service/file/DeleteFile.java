package chinsoft.service.file;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.AttachmentManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class DeleteFile extends BaseServlet {
	private static final long serialVersionUID = 1L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response){
		try {
			super.service();
			new AttachmentManager().removeAttachmentByID(getParameter("ID"),getParameter("File"));
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
