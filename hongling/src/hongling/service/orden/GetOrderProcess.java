package hongling.service.orden;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.business.DictManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.service.core.BaseServlet;

public class GetOrderProcess extends BaseServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String ordenID=request.getParameter("orderNo");
		Orden orden=this.getOrdenByID(ordenID);
		List<OrdenDetail> ordenDetails =orden.getOrdenDetails();
		Dict dict= DictManager.getDictByID(orden.getClothingID());
		String[] arr = dict.getExtension().split(","); 
		int clothingID = Utility.toSafeInt(arr[0]);
		for(OrdenDetail ordenDetail: ordenDetails){
			if(clothingID==orden.getClothingID()){
				List<Dict> defaultComponents = null;
				List<Dict> singleDesignedComponents = new ClothingManager().getOrderProcess(orden, clothingID);
				if(singleDesignedComponents.size()>0){
					defaultComponents = new OrdenManager().GetComponent(singleDesignedComponents, clothingID, orden.getFabricCode());
				}else{
					defaultComponents = new ClothingManager().getDefaultComponent(clothingID, orden.getFabricCode());
				}
				ordenDetail.setSingleComponents(new OrdenManager().getTempSingleDesignedComponentsName(singleDesignedComponents,defaultComponents));
			}
		}
		//replace <span> </span> <label></label> ""
		String dom="";
		Map map=new HashMap();
		Map processMap=new HashMap();
		for (int i = 0; i < ordenDetails.size(); i++) {
			dom+=ordenDetails.get(i).getSingleComponents().replace("<span>", "").replace("</span>", "");
		}
		String[] domkey=dom.split("<label>");
		for (int i = 0; i < domkey.length; i++) {
			map.put(i, domkey[i].replace("</label>", "").replace("<font color='#FFBB77'>", "").replace("</font>", "").replace("</div>", "").replace("<div class='process_Class'>", ""));
		}
		map.remove(0);
		for (Object key : map.keySet()) {
			processMap.put(map.get(key).toString().split(":")[0],map.get(key).toString().split(":")[1]);
		}
		if(map.size()%3==1){
			processMap.put("&copy;", "");
			processMap.put("&nbsp;", "");
		}
		if(map.size()%3==2){
			processMap.put(" ", "");
		}

		response.setCharacterEncoding("UTF-8");
		request.setAttribute("processmap", processMap);
	}

}
