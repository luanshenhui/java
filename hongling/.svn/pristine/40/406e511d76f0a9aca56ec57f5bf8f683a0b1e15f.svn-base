package rcmtm.member;

import java.security.interfaces.RSAPrivateKey;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import rcmtm.business.ConfigSR;
import rcmtm.business.RcmtmManager;
import rcmtm.encrypt.CCBInterfaceUtil;
import rcmtm.encrypt.CCBRsaUtil;
import rcmtm.entity.OrdenBatch;
import chinsoft.business.OrdenManager;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;


public class OrdenPayResults extends BaseServlet {
	private static final long serialVersionUID = 7391945794655883869L;
	
	@SuppressWarnings("static-access")
	public void service(HttpServletRequest request,HttpServletResponse response) {
		
		String strResult="";//返回信息
		String strCpcode ="";//企业编码
		String strparam = Utility.toSafeString(request.getParameter("para"));//善融返回订单支付信息
		System.out.println("订单结果善融传递的参数(解密前)："+strparam);
		try {
			
			//测试 -- 删掉
//			String strOrden ="{\"orderid\":\"cm420131101195712\",\"amountmoney\":252.0,\"status\":\"0\",\"remark\":\"\"}";
			//{"orderid":"AAAA20131025093320","amountmoney":0.1,"status":"0","remark":""}
//			String strOrden="{\"cpcode\":1002,\"orderid\":\"XXXX20131028131524\",\"amountmoney\":\"1.05\",\"status\":0,\"remark\":1}";
//			strparam ="a";
			
			
			if(!"".equals(strparam)){
				//解密
				RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
				String strOrden = new CCBRsaUtil().decryptByPirvKey(privk,strparam);
				System.out.println("订单结果善融传递的参数(解密后)："+strOrden);
				//解析JSON
				JSONObject jsonObj = JSONObject.fromObject(strOrden);
				String strBatchNo = jsonObj.getString("orderid");//支付订单号  批次号
				Double amountmoney = jsonObj.getDouble("amountmoney");//支付金额
				String strStatus = jsonObj.getString("status");//支付结果：0-成功/1-失败
				
				List<OrdenBatch> ordenBatchs = new RcmtmManager().getBatchNos(strBatchNo);//根据批次号获得订单号
				
				if(!"".endsWith(strBatchNo) && strBatchNo !=null ){
					if(!"0".equals(strStatus) || !"1".equals(strStatus)){
						if("0".equals(strStatus)){
							
							String strOrderid = "";
							for(OrdenBatch ob : ordenBatchs){
								strOrderid += ob.getOrdenIDs()+",";
							}
							
							String[] strOrdenID = Utility.getStrArray(strOrderid);
							Double price =0.00;//订单金额
							for(String ordenID : strOrdenID){
								Orden o = new OrdenManager().getordenByOrderId(ordenID);
								price += o.getOrdenPrice();
							}
							if(price.compareTo(amountmoney)!=0){
								strResult = "{\"flag\":false,\"error\":103,\"errormsg\":\"支付金额错误\"}";//返回错误信息
							}else{
								int status = ordenBatchs.get(0).getStatus();
								if(status != 1){
									//订单解锁 更新状态、交货日期
									strResult = new RcmtmManager().updateOrdenStatus(strOrdenID);
									new RcmtmManager().updateBatchNo(strBatchNo,1);
									if("".equals(strResult)){
										strResult="{\"flag\":true,\"error\":0}";//返回正确信息
										
										//根据订单号获取企业编码
										strCpcode = new RcmtmManager().getCpcode(Utility.toSafeString(strOrdenID[0]));
										String json = new RcmtmManager().ordenDetailInfo(strBatchNo, ordenBatchs,strCpcode);
										System.out.println(new Date()+"支付结果-订单明细信息红领传递(加密前)"+json);
										//私钥加密
										RSAPrivateKey privk1 = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
										String enStr = new CCBRsaUtil().encryptByPriKey(privk1,json);
								        StringBuffer para=new StringBuffer();
								        para.append("cpcode=").append(strCpcode).append("&uniondata=").append(enStr);
								        System.out.println("支付结果-订单明细信息红领传递(加密后)"+para.toString());
								        new CCBInterfaceUtil().sendData(ConfigSR.URL_TRADESET,para.toString());
									}else{
										strResult = "{\"flag\":false,\"error\":103,\"errormsg\":\"订单状态更新有误\"}";//返回错误信息
									}
								}
							}
						}
					}else{
						strResult = "{\"flag\":false,\"error\":103,\"errormsg\":\"未返回正确订单支付状态\"}";//返回错误信息
					}
				}else{
					strResult = "{\"flag\":false,\"error\":103,\"errormsg\":\"orderid为空值\"}";//返回错误信息
				}
			}else{
				strResult = "{\"flag\":false,\"error\":103,\"errormsg\":\"para为空值\"}";//返回错误信息
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//加密
		String strNewResult = strResult;
		System.out.println("订单结果红领传递的参数(加密前)："+strResult);
		try {
			 RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
			 strNewResult = new CCBRsaUtil().encryptByPriKey(privk,strNewResult);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("订单结果红领传递的参数(加密后)："+strNewResult);
		output(strNewResult);
	}
}
