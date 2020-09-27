package chinsoft.service.orden;


import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import chinsoft.business.Alipay;
import chinsoft.business.OrdenManager;
import chinsoft.business.Paypal;
import chinsoft.business.SubmitToOrden;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.service.core.BaseServlet;

public class AlipayOrdens extends BaseServlet {

	//saveOrden -> submitOrdens
	private static final long serialVersionUID = -3752715900655015793L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
				
				String strFormData = getParameter("formData");
				String strClothingID = getParameter("clothingID");
				String strFabricCode = getParameter("fabricCode");
				String strPrice ="";
				if("".equals(strClothingID) && "".equals(strFabricCode)){//前台提交
					strPrice = new SubmitToOrden().submitOrdens(strFormData);
				}else{//编辑提交
					strPrice = new SubmitToOrden().submitOrden(strFormData,Utility.toSafeInt(strClothingID),strFabricCode);
				}
				HttpContext.setSessionValue("SESSION_ORDENFEE", strPrice);
				//支付
				String strType = getParameter("type");
				if("1".equals(strType)){//支付宝
					output(new Alipay().Charge(HttpContext.getSessionValue("SESSION_ORDENID").toString(), strPrice));
				}else if("2".equals(strType)){//paypal
					output(new Paypal().Charge(HttpContext.getSessionValue("SESSION_ORDENID").toString(), strPrice));
				}
			
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}