package rcmtm.member;

import java.security.interfaces.RSAPrivateKey;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import rcmtm.business.ConfigSR;
import rcmtm.business.RcmtmManager;
import rcmtm.encrypt.CCBRsaUtil;
import rcmtm.entity.OrdenPay;
import chinsoft.business.CurrentInfo;
import chinsoft.core.HttpContext;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;
import flexjson.JSONSerializer;


public class OrdenPayToSr extends BaseServlet {
	private static final long serialVersionUID = 7391943684655884485L;
	
	@SuppressWarnings("static-access")
	public void service(HttpServletRequest request,HttpServletResponse response) {
		
		String strCompany = Utility.toSafeString(CurrentInfo.getCurrentMember().getCompanyID());
		String strSrUserID = (String) HttpContext.getSessionValue("SessionKey_srUserID");//善融账号
		String strBatchNo = (String) HttpContext.getSessionValue("SessionKey_SrBatchNo");//订单 批次号
		String strHlOrdenID = new RcmtmManager().getOrdensByBatchNo(strBatchNo);//红领订单
		OrdenPay orden = new RcmtmManager().ordenInfo(strSrUserID, strBatchNo, strHlOrdenID,strCompany);//订单信息
		
		String json=new JSONSerializer().exclude("*.class").deepSerialize(orden).toString();
		System.out.println(new Date()+"订单提交--订单信息红领传递(加密前)"+json);
		try {
			//私钥加密
			RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
			String enStr = new CCBRsaUtil().encryptByPriKey(privk,json);
	        StringBuffer para=new StringBuffer();
	        para.append("cpcode=").append(strCompany).append("&uniondata=").append(enStr);
	        System.out.println("订单提交--订单信息红领传递(加密后)"+para.toString());
	        output(new RcmtmManager().ordenInfoHtml(ConfigSR.URL_ORDER, enStr,strCompany));
	        
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
}
