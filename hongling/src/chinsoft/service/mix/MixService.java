package chinsoft.service.mix;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.MixManager;
import chinsoft.service.core.BaseServlet;

public class MixService extends BaseServlet{
	private static final long serialVersionUID = 1L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		output(new MixManager().getAllMixcodes());
	}
}
