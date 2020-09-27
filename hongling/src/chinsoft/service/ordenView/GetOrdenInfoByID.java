package chinsoft.service.ordenView;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.business.DictManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Embroidery;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.service.core.BaseServlet;

public class GetOrdenInfoByID extends BaseServlet {
	private static final long serialVersionUID = -4591305344336387654L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String strOrdenID = getParameter("ordenID");
			int nClothingID = Utility.toSafeInt(getParameter("clothingID"));
			Orden orden = this.getOrdenByID(strOrdenID);
			List<OrdenDetail> ordenDetails =orden.getOrdenDetails();
			if(nClothingID == -1){
				Dict dict= DictManager.getDictByID(orden.getClothingID());
				String[] arr = dict.getExtension().split(","); 
				nClothingID = Utility.toSafeInt(arr[0]);
			}
			
			for(OrdenDetail ordenDetail: ordenDetails){
				if(nClothingID==ordenDetail.getSingleClothingID()){
					//尺寸+特体
					String strSizePartNames=new OrdenManager().getTempSizePartName(orden,ordenDetail.getSingleClothingID());
					String strBodyName=new OrdenManager().getTempBodyName(orden.getSizeBodyTypeValues());
					orden.setSizePartNames(strSizePartNames+strBodyName);
					//工艺
					List<Dict> defaultComponents = null;
					List<Dict> singleDesignedComponents = new ClothingManager().getOrderProcess(orden, nClothingID);
					if(singleDesignedComponents.size()>0){
						defaultComponents = new OrdenManager().GetComponent(singleDesignedComponents, nClothingID, orden.getFabricCode());
					}else{
						defaultComponents = new ClothingManager().getDefaultComponent(nClothingID, orden.getFabricCode());
					}
					ordenDetail.setSingleComponents(new OrdenManager().getTempSingleDesignedComponentsName(singleDesignedComponents,defaultComponents));
					//刺绣
					List<Embroidery> emberoidery = new ClothingManager().getEmbroideryLoaction(orden, nClothingID);
					ordenDetail.setSingleEmbroiderys(new OrdenManager().getTempSingleDesignedEmbroiderysName(emberoidery));
				}
			}
			
			String domSmall="";
			if(orden.getClothingID() == 1 || orden.getClothingID() == 2){
				domSmall= "<ul>";
				if(orden.getOrdenDetails() != null){
					for(OrdenDetail od : orden.getOrdenDetails()){
						domSmall +="<li onclick=$.csOrdenInfoView.showInformation('"+od.getSingleClothingID()+"','"+strOrdenID+"')><img src='../../process/component/orden/"+od.getSingleClothingID()+"/"+orden.getFabricCode()+"_img.png'/></li>";
					}
				}
				domSmall += "</ul>";
			}
			
		    orden.setMemo(domSmall);
		    
			output(orden);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdenById_err" + e.getMessage());
		}
	}
}
