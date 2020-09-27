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

import chinsoft.business.DictManager;
import chinsoft.core.Utility;

public class GetPartValues extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		Map map=new HashMap();
		Map partmap=new HashMap();
		partmap.put("领围", "");
		partmap.put("胸围", "");
		partmap.put("中腰", "");
		partmap.put("臀围", "");
		partmap.put("上臀围", "");
		partmap.put("总肩宽", "");
		partmap.put("左袖长", "");
		partmap.put("右袖长", "");
		partmap.put("前肩宽", "");
		partmap.put("后腰节长", "");
		partmap.put("后衣长", "");
		partmap.put("裤腰围", "");
		partmap.put("腿根围", "");
		partmap.put("通裆", "");
		partmap.put("后腰高", "");
		partmap.put("前腰高", "");
		partmap.put("左裤长", "");
		partmap.put("右裤长", "");
		partmap.put("膝围", "");
		partmap.put("脚口", "");
		partmap.put("左腕围", "");
		partmap.put("右腕围", "");
		partmap.put("袖肥", "");
		partmap.put("横档", "");
		partmap.put("左袖口", "");
		partmap.put("前衣长", "");
		partmap.put("首扣据肩", "");
		partmap.put("腰围", "");
		partmap.put("肩宽", "");
		partmap.put("前腰节", "");
		partmap.put("右袖口", "");
		partmap.put("大衣后衣长", "");
		partmap.put("马甲后衣长", "");
		String partValues=request.getParameter("partValues");
		System.out.println(partValues);
		//10115:40,10114:50,10113:50,10111:40,10172:38,10110:34,10129:,10127:80,10128:,10108:112,112,10105:88,10102:112,10120:112,10101:54,10122:50,10124:12,10123:60,10126:80,10125:12,10116:36,10117:60
		
		if(!"".equals(partValues)){
			if(partValues.contains(",")){
				String[] partValue=partValues.split(",");
				List list=new ArrayList();
				for (int i = 0; i < partValue.length; i++) {
					if(partValue[i].contains(":")){
						list.add(partValue[i]);
					}
				}
				for (int i = 0; i < list.size(); i++) {
					map.put(new DictManager().getDictByID(Utility.toSafeInt(list.get(i).toString().substring(0, list.get(i).toString().indexOf(":")))).getName(), list.get(i).toString().substring(list.get(i).toString().indexOf(":")+1,list.get(i).toString().length()));
				}	
			}
			else
			{
				String[] values=partValues.split(":");
				map.put(new DictManager().getDictByID(Utility.toSafeInt(values[0])).getName(), values[1]);
			}
			System.out.println(map);
			for (Object key : partmap.keySet()) {
				for (Object k : map.keySet()) {
					if(Utility.toSafeString(k).equals(Utility.toSafeString(key))){
						partmap.put(key, map.get(k));
					}
				}
			}
		}
		request.setCharacterEncoding("UTF-8");
		request.setAttribute("partmap", partmap);
	}

}
