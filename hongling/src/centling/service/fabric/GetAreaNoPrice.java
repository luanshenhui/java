package centling.service.fabric;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

/**
 * 获取没有关联指定面料价格的经营单位
 * @author Dirk
 *
 */
public class GetAreaNoPrice extends BaseServlet {
	private static final long serialVersionUID = 1L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			// 得到面料号
			String code = getParameter("code");
			List<Dict> list = new DictManager().getAreaNoPrice(code);
			output(list);
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}
	}
}
