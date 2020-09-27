package chinsoft.service.orden;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.ClothingManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Embroidery;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.service.core.BaseServlet;

public class GeTemptOrdenViewByID extends BaseServlet {
	private static final long serialVersionUID = -4591305344336387654L;
	@SuppressWarnings("unchecked")
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			Orden ordenTemp = new Orden();
			int nClothingID = Utility.toSafeInt(getParameter("clothingID"));
			String strOrdenID = getParameter("ordenID");
			List<Orden> ordens =  (List<Orden>)HttpContext.getSessionValue(CDict.SessionKey_Ordens);
			for(Orden orden:ordens){
				if(strOrdenID.equals(orden.getOrdenID())){
					List<OrdenDetail> ordenDetails =orden.getOrdenDetails();
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
					ordenTemp = orden;
				}
			}
			output(ordenTemp);
		} catch (Exception e) {
			LogPrinter.debug("GetOrdenById_err" + e.getMessage());
		}
	}
}
