package chinsoft.service.size;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class GetSizePart extends BaseServlet{

private static final long serialVersionUID = -2024608370373953119L;

@Override
protected void service(HttpServletRequest request,	HttpServletResponse response) {
	try {
		super.service();
		//new SizeManager().getSizePart(1, 2);
	} catch (Exception e) {
		LogPrinter.debug("GetSizePart_err"+e.getMessage());
	}
}
}
