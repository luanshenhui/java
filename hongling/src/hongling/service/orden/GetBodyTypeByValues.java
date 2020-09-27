package hongling.service.orden;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictCategoryManager;
import chinsoft.business.DictManager;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.DictCategory;

public class GetBodyTypeByValues extends HttpServlet {

	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		String bodyValues=request.getParameter("bodytype");
		Map map=new HashMap();
		Map bodymap=new HashMap();
		Dict dict=null;
		DictCategory dictc=null;
		bodymap.put("凸肚", "");
		bodymap.put("溜肩(左)", "");
		bodymap.put("溜肩(右)", "");
		bodymap.put("耸肩(右)", "");
		bodymap.put("耸肩(左)", "");
		bodymap.put("驼背", "");
		bodymap.put("手臂", "");
		bodymap.put("臀", "");
		bodymap.put("腰高低", "");
		bodymap.put("着装风格", "");
		bodymap.put("前冲后掰肩", "");
		bodymap.put("前弓后仰体", "");
		if(!"".equals(bodyValues)){
			if(bodyValues.contains(",")){
				String[] values=bodyValues.split(",");
				for (int i = 0; i < values.length; i++) {
					dict=new DictManager().getDictByID(Utility.toSafeInt(values[i]));
					dictc=new DictCategoryManager().getDictCategoryByID(dict.getCategoryID());
					map.put(dictc.getName(),dict.getName());
				}
			}
			else
			{
				dict=new DictManager().getDictByID(Utility.toSafeInt(bodyValues));
				dictc=new DictCategoryManager().getDictCategoryByID(dict.getCategoryID());
				map.put(dictc.getName(),dict.getName());
			}
			for (Object key : bodymap.keySet()) {
				for (Object k : map.keySet()) {
					if(Utility.toSafeString(k).equals(Utility.toSafeString(key))){
						bodymap.put(key, map.get(k));
					}
				}
			}
		}
		request.setCharacterEncoding("UTF-8");
		request.setAttribute("bodymap", bodymap);
	}

}
