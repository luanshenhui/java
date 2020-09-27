package chinsoft.service.file;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.AttachmentManager;
import chinsoft.entity.Attachment;
import chinsoft.service.core.BaseServlet;


public class UploadFile extends BaseServlet {
	private static final long serialVersionUID = -3096800116651263134L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			Attachment attachment = new AttachmentManager().saveAttachment(request);
			attachment.setHiddenID(request.getParameter("dataid"));
			output(attachment);
		} catch (Exception e) {
		}
	}
}