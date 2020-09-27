package chinsoft.service.dict;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;

public class SaveDict extends HttpServlet {
	private static final long serialVersionUID = -6227330543943682499L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String formData = request.getParameter("formData");
		formData = new String(formData.getBytes("ISO-8859-1"), "UTF-8");
		//formData=java.net.URLDecoder.decode(formData,"gb2312");
		LogPrinter.debug(formData);
	}
}
