package rcmtm.member;

import java.security.interfaces.RSAPrivateKey;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import rcmtm.business.ConfigSR;
import rcmtm.business.RcmtmManager;
import rcmtm.encrypt.CCBRsaUtil;
import rcmtm.entity.OrdenPay;
import chinsoft.business.CurrentInfo;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;
import flexjson.JSONSerializer;

public class BatchPaymentOrders extends BaseServlet {

	private static final long serialVersionUID = -3852715900655015773L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strCompany = Utility.toSafeString(CurrentInfo.getCurrentMember().getCompanyID());
			//根据订单号生成批次号
			String strOrdenId =Utility.toSafeString(getParameter("ordenIds"));
			String[] strOrdenIds=Utility.getStrArray(strOrdenId);
			List<Orden> ordens = new ArrayList<Orden>();
			String strResult = "";
			for(String strId : strOrdenIds){
				Orden orden = this.getOrdenByID(strId);
				ordens.add(orden);
			}
			
			String strBatchNo = (String)HttpContext.getSessionValue("SessionKey_NewSrBatchNo");
			HttpContext.setSessionValue("SessionKey_NewSrBatchNo","");
			if(strBatchNo == null || "".equals(strBatchNo)){
				strBatchNo =  new RcmtmManager().ordensGenerateBatchNo(ordens);//生成批次号
			}
			HttpContext.setSessionValue("SessionKey_SrBatchNo", strBatchNo);
			String strSrUserID = (String) HttpContext.getSessionValue("SessionKey_srUserID");//善融账号
			OrdenPay orden = new RcmtmManager().ordenInfo(strSrUserID, strBatchNo, strOrdenId,strCompany);//订单信息
			
			String json=new JSONSerializer().exclude("*.class").deepSerialize(orden).toString();
			System.out.println(new Date()+"订单批量支付--订单信息红领传递(加密前)"+json);
			
			//私钥加密
			RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
			String enStr = new CCBRsaUtil().encryptByPriKey(privk,json);
	        StringBuffer para=new StringBuffer();
	        para.append("cpcode=").append(strCompany).append("&uniondata=").append(enStr);
	        System.out.println("订单批量支付--订单信息红领传递(加密后)"+para.toString());
	        
	        strResult = new RcmtmManager().ordenInfoHtml(ConfigSR.URL_ORDER, enStr,strCompany);

	        output(strResult);
			
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("OrdenSecondPayToSr" + e.getMessage());
		}
	}
	
}