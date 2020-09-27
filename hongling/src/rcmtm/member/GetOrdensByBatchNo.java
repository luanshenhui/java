package rcmtm.member;

import java.security.interfaces.RSAPrivateKey;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import rcmtm.business.ConfigSR;
import rcmtm.business.RcmtmManager;
import rcmtm.encrypt.CCBRsaUtil;
import rcmtm.entity.OrdenBatch;
import chinsoft.business.MemberManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class GetOrdensByBatchNo extends BaseServlet {
	private static final long serialVersionUID = -4591305344355387704L;
	
	@SuppressWarnings("static-access")
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			//私钥解密
			String strUniondata = Utility.toSafeString(request.getParameter("para"));
//			strUniondata ="92c82efa6b684f2e302661d8cd9ce7d07bfcaa1f64214080cf03170f7adff7115d97ddfb4f345952ee9bc7c5819509ba4186c46ff3cf7f50fe563e863a81ecd6a4a8922da99f281c239dff59c6264eea7fdf7dbf417f70dde4ac511b03cb768e9d2d7ed2b62bdda3227dcc6fc46e6b3251439fcf040ce7d01b132f817b99fa57";
			System.out.println(new Date()+"善融根据批次号获取订单信息传递参数(解密前)"+strUniondata);
			RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
			String strPara = new CCBRsaUtil().decryptByPirvKey(privk,strUniondata);
			System.out.println("善融根据批次号获取订单信息传递参数(解密后)"+strPara);
//			String strPara ="{\"cpcode\":1003,\"orderid\":\"cm420131101195712\"}";
//			String strPara ="{\"cpcode\":1003\",\"orderid\":\"cm420131101195712\"}";
			//解析JSON
			JSONObject jsonObj = JSONObject.fromObject(strPara);
			String strCpcode = jsonObj.getString("cpcode");//企业代码
			String strBatchNo = jsonObj.getString("orderid");//订单号 批次号
			
			StringBuffer para=new StringBuffer();
			//根据批次号获取订单号
			List<OrdenBatch> ordenBatchs = new RcmtmManager().getBatchNos(strBatchNo);
			String json = new RcmtmManager().ordenDetailInfo(strBatchNo, ordenBatchs,strCpcode);
			System.out.println(new Date()+"善融根据批次号获取订单信息-红领回传参数(加密前)"+json);
			
			//私钥加密
			String enStr = new CCBRsaUtil().encryptByPriKey(privk,json);
	        para.append("cpcode=").append(strCpcode).append("&uniondata=").append(enStr);
		        
			System.out.println("善融根据批次号获取订单信息-红领回传参数(加密后)"+para.toString());
			output(para.toString());
			
		} catch (Exception e) {
			LogPrinter.debug("GetOrdensByBatchNo_err" + e.getMessage());
		}
	}
}
