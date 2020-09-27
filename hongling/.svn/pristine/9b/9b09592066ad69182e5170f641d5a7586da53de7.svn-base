package hongling.service.orden;

import java.io.IOException;
import java.util.HashMap;
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
import chinsoft.entity.Embroidery;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.service.core.BaseServlet;

public class GetEmbroidery extends BaseServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
			request.setCharacterEncoding("UTF-8");
			String ordenID=request.getParameter("ordenNo");
			Orden orden=this.getOrdenByID(ordenID);
			List<OrdenDetail> ordenDetails =orden.getOrdenDetails();
			Dict dict= DictManager.getDictByID(orden.getClothingID());
			String[] arr = dict.getExtension().split(","); 
			int clothingID = Utility.toSafeInt(arr[0]);
			for(OrdenDetail ordenDetail: ordenDetails){
				List<Embroidery> emberoidery = new ClothingManager().getEmbroideryLoaction(orden, clothingID);
				ordenDetail.setSingleEmbroiderys(new OrdenManager().getTempSingleDesignedEmbroiderysName(emberoidery));	
			}
			String dom="";
			for (int i = 0; i < ordenDetails.size(); i++) {
				dom+=ordenDetails.get(i).getSingleEmbroiderys().replace("<div class='depthDesign_Class'>", "").replace("</div>", "").replace("<font color='#FFBB77'>", "").replace("</font>", "");
			}
			Map embmap=new HashMap();
			String[] embs=dom.split("<label>");
			for (int i = 0; i < embs.length; i++) {
				System.out.println(embs[i].replace("</label>", "").trim());
				if(embs[i].replace("</label>", "").trim().contains(":")){
					embmap.put(embs[i].replace("</label>", "").trim().substring(0, embs[i].replace("</label>", "").trim().indexOf(":")), embs[i].replace("</label>", "").trim().substring(embs[i].replace("</label>", "").trim().indexOf(":")+1, embs[i].replace("</label>", "").trim().length()));
				}
			}
			request.setCharacterEncoding("UTF-8");
			request.setAttribute("embmap", embmap);
	}

}
