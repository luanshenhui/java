package hongling.service.orden;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;

public class GetDressStyleByOrdenID extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String typeValues=request.getParameter("typeValues");
		String dress="";
		Map typemap=new HashMap();
		List<Dict> dicts=new DictManager().getDicts(32);
		for (Dict dict : dicts) {
			typemap.put(dict.getID(), dict.getName());
		}
		if(!"".equals(typeValues)){
				for (Object key : typemap.keySet()) {
					if(typeValues.contains(Utility.toSafeString(key))){
						dress=Utility.toSafeString(typemap.get(key));
						break;
					}
				}
		}
		request.setCharacterEncoding("UTF-8");
		request.setAttribute("dress",dress);
	}

}
