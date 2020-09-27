package chinsoft.service.dict;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import work.business.DictMG;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;
import chinsoft.vo.ProductDictVO;

public class GetDictVOByParentID extends BaseServlet {
	private static final long	serialVersionUID	= 1L;

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		// TODO Auto-generated method stub
		super.service();
		String parentID = request.getParameter("parentID");
		List<ProductDictVO>  list=new DictMG().getDictByKeyword(Utility.toSafeInt(parentID));
		output(list);
	}
}
