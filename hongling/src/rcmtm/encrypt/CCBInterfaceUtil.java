package rcmtm.encrypt;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.security.interfaces.RSAPrivateKey;

import rcmtm.business.ConfigSR;
public class CCBInterfaceUtil {
	public static CCBInterfaceUtil instance = null;

	public static synchronized CCBInterfaceUtil getInstance() {
		if (instance == null) {
			instance = new CCBInterfaceUtil();
		}
		return instance;
	}

	@SuppressWarnings("static-access")
	public String sendData(String interfaceUrl, String para)
			throws Exception {
		// 开启连接
		URL uploadServlet = new URL(interfaceUrl);
		URLConnection servletConnection = uploadServlet.openConnection();
		// 设置连接参数
		HttpURLConnection hc = (HttpURLConnection) servletConnection;
		hc.setRequestMethod("POST");
		hc.setUseCaches(false);
		hc.setDoOutput(true);
		hc.setDoInput(true);
		// 开启流，写入JSON数据
		PrintWriter output = new PrintWriter(new OutputStreamWriter(
				hc.getOutputStream(), "UTF-8"));
		output.println(para);
		output.close();
		hc.getInputStream();
		try {
			// 接收返回参数
			StringBuffer backJsonBuffer = new StringBuffer();
			BufferedReader in = new BufferedReader(new InputStreamReader(
					hc.getInputStream(), "UTF-8"));
			String inputLine;
			while ((inputLine = in.readLine()) != null) {
				backJsonBuffer.append(inputLine);
			}
			in.close();
			System.out.println("sendData请求(加密后)："+ para);
			System.out.println("sendData返回(解密前)："+ backJsonBuffer.toString());
			//测试 -删除
//			return backJsonBuffer.toString();
			
			//返回值解密
			RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
			String backJson = new CCBRsaUtil().decryptByPirvKey(privk,backJsonBuffer.toString());
			System.out.println("sendData返回(解密后)："+backJson);
			
			return backJson;
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	public static void main(String[] args){
		try {
//			StringBuffer stringBuffer = new StringBuffer();
			//账号绑定
//			String json = "{\"cpcode\":\"1002\",\"loginid\":\"\",\"loginname\":\"红领集团\",\"userid\":\"5537158\",\"timestamp\":\"20130322102614\",\"auth\":\"7f8a4224251d477801823e9039adbee2\"}";

			//订单支付
//			String json = "{\"cpcode\":\"1001\",\"orderid\":\"ID1303181040999\",\"loginid\":\"DC1204045\",\"userid\":\"5537158\",\"title\":\"达内集团\",\"amount\":1,\"amountmoney\":2784,\"unit\":\"元\",\"price\":0,\"thumb\":\"\",\"buyeraddress\":\"\",\"buyername\":\"\",\"buyerpostcode\":\"\",\"buyerphone\":\"\",\"note\":\"\"}";
						
			//发货确认
//			String json = "{\"cpcode\":\"1001\",\"orderid\":\"ID1303251641081\",\"remark\":\"\"}";
			
			//收货确认
//			String json = "{\"cpcode\":\"1001\",\"orderid\":\"ID1303251641081\",\"amountmoney\":1137}";
//			
//			RSAPrivateKey privk =CCBRsaUtil.getRSAPrivateKeyPair("redcollar_priv");
			//私钥加密 data为待加密字符串
//			String enStr = CCBRsaUtil.encryptByPriKey(privk,json);
//			String enStr = "bf50aa1801ce59479bb07edb28c88efa1e6d2034ec6496d82bbce710629ecc60543df3d17161418b1c4240410147ae1b8bb3c8abdd4aca168842b525b63625bf71f469e12d477c26b6cd9fb4072f792ab7b72465cf05baae5d0ecf56304ef4ddc949ce2535491613c7e1955985b9ba6e84d48fc2db971e9f1a33de8377bfa54d644f628e22506fc916ae541ceb3cc3a3e1d5e7dd6a113910f554c8822a28757f213825e985ea5c4f741914cf46c3cc747b4354de1fa2b232e6581fd312297b5ecc40230d0e208adb2f19e6f6c17bde37e6fc06acf0daa3c4fa6d60037dcdae26c5c9a5eeab3fcd17fe70b797ba2199a158cfa741afc3b60544291c7ce3dc421f";
//			stringBuffer.append("cpcode=").append("1002").append("&uniondata=").append(enStr);
//			stringBuffer.append("para=").append("b65916151a2ab253ae321cc8766384e142b6e5fd720bca89f190a573e423910206cdbb2062fbbc5bb1f3ae0e0546b4d5a1368a8af6a4d67a9b7e6b4ad74ace3e4dc1812fe4da9dc9ff9b541c52ee3f1f8e0114d39afb7bf538e1ecfebe0fa346e19895f0c3000e2ba21e4b273256f538bebbcbfd9ecb93223209aa3c21bcf44c");

			//账号绑定
//			CCBInterfaceUtil.getInstance().sendData("http://121.32.89.133:85/alliance/alliance_bind.php", stringBuffer.toString());
			
			//订单支付
//			CCBInterfaceUtil.getInstance().sendData("http://121.32.89.133:85/alliance/order.php", stringBuffer.toString());

			//发货确认
//			CCBInterfaceUtil.getInstance().sendData("http://121.32.89.133:85/alliance/consignment.php", stringBuffer.toString());
			
			//收货确认
//			CCBInterfaceUtil.getInstance().sendData("http://121.32.89.133:85/alliance/confirmpay.php", stringBuffer.toString());
			
			//测试
//			String resultJson = CCBInterfaceUtil.getInstance().sendData("http://121.32.89.133:85/alliance/testencode.php", stringBuffer.toString());
			
			//------>订单结果同步
//			String result = CCBInterfaceUtil.getInstance().sendData("http://219.143.213.104/b2bsrvs/v1/ccb/pay","b65916151a2ab253ae321cc8766384e142b6e5fd720bca89f190a573e423910206cdbb2062fbbc5bb1f3ae0e0546b4d5a1368a8af6a4d67a9b7e6b4ad74ace3e4dc1812fe4da9dc9ff9b541c52ee3f1f8e0114d39afb7bf538e1ecfebe0fa346e19895f0c3000e2ba21e4b273256f538bebbcbfd9ecb93223209aa3c21bcf44c");
//			System.out.println("返回："+result);
			
			//------>打款结果确认
//			CCBInterfaceUtil.getInstance().sendData("http://219.143.213.104//b2bsrvs/v1/ccb/receive", "");
					
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}