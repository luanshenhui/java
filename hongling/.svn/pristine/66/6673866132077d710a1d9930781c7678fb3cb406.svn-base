package hongling.service.assemble;

import hongling.business.AssembleManager;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

/**
 * 获取 服装分类
 * 
 * @author Administrator
 * 
 */
public class GetClothCategorys extends BaseServlet {
	private static final long serialVersionUID = -6903233945158722276L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			super.service();

			List<Dict> dicts = new AssembleManager().findClothCategorys();

			output(dicts);
		} catch (Exception e) {
			LogPrinter.debug("GetClothCategorys_err" + e.getMessage());
		}
	}
}
