package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;
import hongling.entity.FabricWareroom;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import chinsoft.business.CDict;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetFabricWareroomList extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			super.service();
			int pageNo=Utility.toSafeInt(getParameter("pageindex"));
			String fabricNo=getParameter("searchFabricNo");
			String property=getParameter("searchProperty");
			String brands=getParameter("searchBrands");
			String category=getParameter("searchCategory");
			String belong=getParameter("belong");
			String status=getParameter("status");
			if("--请选择--".equals(belong)){
				belong="";
			}
			if("-1".equals(brands)){
				brands="";
			}
			if("-1".equals(category)){
				category="";
			}
			List<FabricWareroom> fabricwarerooms=new FabricWareroomManager().getFabricWarerooms(pageNo, CDict.PAGE_SIZE, fabricNo, property, brands, category,belong,status);
			int count=new FabricWareroomManager().getCount(fabricNo, property, brands, category,belong,status);
			PagingData page=new PagingData();
			page.setCount(count);
			page.setData(fabricwarerooms);
			output(page);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
