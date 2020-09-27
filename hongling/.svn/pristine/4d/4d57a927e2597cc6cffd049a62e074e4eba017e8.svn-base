package chinsoft.service.orden;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



import chinsoft.business.CDict;
import chinsoft.business.ClothingManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.service.core.BaseServlet;

public class SubmitMoreOrden extends BaseServlet {

	private static final long serialVersionUID = -3852715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			//super.service();
			String strOrdenId = Utility.toSafeString(getParameter("ordenIds"));
			String strType = Utility.toSafeString(getParameter("type"));
			String tg ="";
			String tgkd ="";
			String fk="";
			if("2".equals(strType)){
				tg =Utility.toSafeString(getParameter("tg"));
				tgkd =Utility.toSafeString(getParameter("tgkd"));
				fk=Utility.toSafeString(getParameter("fk"));
			}
			String[] strOrdenIds=Utility.getStrArray(strOrdenId);
			List<Orden> ordens = new ArrayList<Orden>();
			for(String strId : strOrdenIds){
				if(!"".equals(strOrdenId)){
					Orden orden = this.getOrdenByID(strId);
					if(!CDict.OrdenStatusPlateMaking.getID().equals(orden.getStatusID())){
						orden.setStatusID(CDict.OrdenStatusPlateMaking.getID());
						List<OrdenDetail> ordenDetails = new ArrayList<OrdenDetail>();
						List<Dict> singleClothings = new ClothingManager().getSingleClothings(orden.getClothingID());
						for(Dict singleClothing: singleClothings){
							OrdenDetail ordenDetail = new OrdenDetail();
							if(orden.getClothingID()<3 || singleClothing.getID()==2000){
								if((singleClothing.getID()==3 && orden.getMorePants()==10050)){
									ordenDetail.setAmount(1);
								}else if(singleClothing.getID()==2000 && orden.getMorePants()==10050){
									ordenDetail.setAmount(2);
								}else if(orden.getMorePants() == 10051){
									ordenDetail.setAmount(1);
								}else{
									ordenDetail.setAmount(orden.getMorePants());
								}
							}else{
								ordenDetail.setAmount(orden.getMorePants());
							}
							ordenDetail.setSingleClothingID(singleClothing.getID());
							ordenDetails.add(ordenDetail);
						}
						ordenDetails = new OrdenManager().getDetailsByOrdenID(strId,ordenDetails);
						orden.setOrdenDetails(ordenDetails);
						new OrdenManager().setPrice(orden);
						ordens.add(orden);
					}
				}
			}
			
			String str = new OrdenManager().checkEmbroideryContent(ordens);
			str += this.checkProcessBiao(ordens);
			str += new OrdenManager().checkLapelWidth(ordens);
			if(!"".equals(str)){
				for(Orden orden : ordens){
					orden.setStatusID(CDict.OrdenStatusSaving.getID());
				}
			}
			
			String strResult = "";
			if(ordens.size()>0){
				String strTempResult = "";
				if("0".equals(strType)){
					strTempResult = new OrdenManager().submitOrdens(this.getTempCustomer(), ordens);
				}else if("1".equals(strType)){//红领料
					strTempResult = new OrdenManager().preSubmitOrdens(this.getTempCustomer(), ordens,"","","","pre");
				}else if("2".equals(strType)){//客供料
					strTempResult = new OrdenManager().preSubmitOrdens(this.getTempCustomer(), ordens,tg,tgkd,fk,"pre");
				}
//				String strTempResult = new OrdenManager().submitOrdens(this.getTempCustomer(), ordens);
				if(!"".equals(strTempResult)){
					strResult = strTempResult;
				}
			}
			
			output(strResult);
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}