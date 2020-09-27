package hongling.service.assemble;

import hongling.business.AssembleManager;
import hongling.entity.Assemble;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sun.management.counter.Units;

import chinsoft.business.CDict;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class ListAssembleByType extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		try {
			super.service();
			String strFormData = getParameter("formData");
			//{'searchKeywords':'','searchCode':'','searchStyleID':'','pageindex':'0','type':'3'}
			String code=getParameter("searchCode");
			String style=getParameter("searchStyleID");
			int pageNo=Utility.toSafeInt(getParameter("pageindex"));
			int type=Utility.toSafeInt(getParameter("type"));
			if("-1".equals(style)){
				style="";
			}
			
			//System.out.println(keywords+"-"+style+"-"+code+"-"+style+"-"+pageNo+"-"+type);
			List<Assemble> assembles=new AssembleManager().getListAssembleByType(pageNo, CDict.PAGE_SIZE,  code, style, type);
			int count=new AssembleManager().getCount(code, style, type);
			PagingData page = new PagingData();
			page.setCount(count);
			page.setData(assembles);
			output(page);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
