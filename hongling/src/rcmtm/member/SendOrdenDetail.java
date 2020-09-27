package rcmtm.member;

import java.security.interfaces.RSAPrivateKey;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import rcmtm.business.ConfigSR;
import rcmtm.business.RcmtmManager;
import rcmtm.encrypt.CCBInterfaceUtil;
import rcmtm.encrypt.CCBRsaUtil;
import rcmtm.entity.OrdenBatch;
import chinsoft.business.CurrentInfo;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SendOrdenDetail extends BaseServlet {
	private static final long serialVersionUID = -4591305344355387704L;
	
	@SuppressWarnings("static-access")
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			
			String strCompany = Utility.toSafeString(CurrentInfo.getCurrentMember().getCompanyID());
			String strBatchNo = (String) HttpContext.getSessionValue("SessionKey_SrBatchNo");//订单 批次号
			
			//根据批次号获取订单号
			List<OrdenBatch> ordenBatchs = new RcmtmManager().getBatchNos(strBatchNo);
			String json = new RcmtmManager().ordenDetailInfo(strBatchNo, ordenBatchs,strCompany);
			System.out.println(new Date()+"订单明细信息红领传递(加密前)"+json);
			
			//私钥加密
			RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
			String enStr = new CCBRsaUtil().encryptByPriKey(privk,json);
	        StringBuffer para=new StringBuffer();
	        para.append("cpcode=").append(strCompany).append("&uniondata=").append(enStr);
	        System.out.println("订单明细信息红领传递(加密后)"+para.toString());
			
			output(new CCBInterfaceUtil().sendData(ConfigSR.URL_TRADESET,para.toString()));
			
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("SendOrdenDetail_err" + e.getMessage());
		}
	}
}
