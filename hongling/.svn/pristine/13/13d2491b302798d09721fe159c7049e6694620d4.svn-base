package chinsoft.service.logistic;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import net.sf.json.JSONObject;
import net.sf.json.xml.XMLSerializer;
import net.ytoec.kernel.HttpClient;
import net.ytoec.kernel.Md5Encryption;
import chinsoft.service.logistic.bean.BasicControls;
import chinsoft.service.logistic.sf.CommonServiceService;
import chinsoft.service.logistic.sf.CommonServiceServiceLocator;
import chinsoft.service.logistic.sf.IService;
import sun.misc.BASE64Encoder;
import chinsoft.core.DEncrypt;

public class LogistcManager {
	
	/**
	 * 获得顺丰物流路由信息
	 * @param logisticNo 物流单号
	 * @return JSON
	 */
	public String getMsgBySF(String logisticNo) {
//		JSONObject root=JSONObject.fromObject(BasicControls.getIniValueByKey("SFKD", "Request"));
//		root.put("Head", BasicControls.getIniValueByKey("SFKD", "Head"));
		JSONObject root=JSONObject.fromObject("{\"@service\":\"RouteService\",\"@lang\":\"zh-CN\",\"Head\":[],\"Body\":{\"RouteRequest\":{\"@tracking_type\":\"1\",\"@tracking_number\":\"\"}}}");
		root.put("Head", "307cf785a5f64b7eb67794e4adf90fe3,a1e2965dbdca431fbd4a8f45a44aa967");
		JSONObject body=root.getJSONObject("Body");
		JSONObject routeRequest=body.getJSONObject("RouteRequest");
		routeRequest.put("@tracking_number",logisticNo);
		
		XMLSerializer serializer= new XMLSerializer();
		serializer.setRootName("Request");
		serializer.setTypeHintsEnabled(false);
		String xml=serializer.write(root);
		xml=xml.substring(xml.indexOf("\n")+1);
		
		CommonServiceService serviceService = new CommonServiceServiceLocator();
		String result = "";
		try {
			IService service = serviceService.getCommonServicePort();
			result = service.sfexpressService(xml);
		} catch (Exception e) {
			e.printStackTrace();
			result = "ERROR";
		}
		return result;
	}
	
	/**
	 * 获得圆通物流路由信息
	 * @param logisticNo 物流单号
	 * @return JSON
	 */
	public String getMsgByYT(String logisticNo) {
//		String parternId = BasicControls.getIniValueByKey("YTKD", "ParternId");// 商家密钥
//		String clientId =  BasicControls.getIniValueByKey("YTKD", "ClientId");
		String parternId = "CANGPEITONG123456";// 商家密钥
		String clientId =  "CANGPEITONG";
		
//		JSONObject root=JSONObject.fromObject(BasicControls.getIniValueByKey("YTKD", "BatchQueryRequest"));
//		root.put("clientID", BasicControls.getIniValueByKey("YTKD", "ClientId"));
		JSONObject root=JSONObject.fromObject("{\"logisticProviderID\":\"YTO\",\"clientID\":[],\"orders\":{\"order\":{\"mailNo\":[]}}}");
		root.put("clientID", "CANGPEITONG");
		JSONObject orders=root.getJSONObject("orders");
		JSONObject order=orders.getJSONObject("order");
		order.put("mailNo", logisticNo);
		
		XMLSerializer xmlSerializer = new XMLSerializer();
		xmlSerializer.setRootName("BatchQueryRequest");
		xmlSerializer.setTypeHintsEnabled(false);
		String xml = xmlSerializer.write(root);
		xml=xml.substring(xml.indexOf("\n")+1);
		
//		HttpClient httpClient = new HttpClient();
		String params="";
		try {
			params = "logistics_interface="
					+ URLEncoder.encode(xml.toString(), HttpClient.UTF8_CHARSET)
					+ "&"
					+ "data_digest="
					+ URLEncoder.encode(Md5Encryption.MD5Encode(xml + parternId),
							HttpClient.UTF8_CHARSET) + "&clientId="
					+ URLEncoder.encode(clientId, HttpClient.UTF8_CHARSET);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return "ERROR";
		}
//		httpClient.setUrlString(BasicControls.getIniValueByKey("Logistics", "Url_YT"));
		/*httpClient.setUrlString("http://service.yto56.net.cn/CommonOrderServlet.action");
		httpClient.setRequestMethod(HttpClient.POST_REQUEST_METHOD);
		httpClient.setRequestParams(params);
		String result="";
		try {
			result = httpClient.send();
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		
		String result=BasicControls.sendPost("http://service.yto56.net.cn/CommonOrderServlet.action", params.toString());
		
		return result;
	}
	
	/**
	 * 获得元智物流路由信息
	 * @param logisticNo 物流单号
	 * @return JSON
	 */
	@SuppressWarnings("deprecation")
	public String getMsgByYZ(String logisticNo) {

//		JSONObject root=JSONObject.fromObject(BasicControls.getIniValueByKey("YZKD", "BatchQueryRequest"));
		JSONObject root=JSONObject.fromObject("{\"logisticProviderID\":\"ND\",\"orders\":{\"order\":{\"mailNo\":[]}}}");
		JSONObject orders=root.getJSONObject("orders");
		JSONObject order=orders.getJSONObject("order");
		order.put("mailNo", logisticNo);
		
		XMLSerializer xmlSerializer = new XMLSerializer();
		xmlSerializer.setRootName("BatchQueryRequest");
		xmlSerializer.setTypeHintsEnabled(false);
		String xml = xmlSerializer.write(root);
		xml=xml.substring(xml.indexOf("\n")+1);
		StringBuffer bfPostParam = new StringBuffer(xml);
//		bfPostParam.append(BasicControls.getIniValueByKey("YZKD", "Key"));//正式hlsyncKI9FdhV
		bfPostParam.append("hlsyncKI9FdhV");//正式hlsyncKI9FdhV
		String strEncode =URLEncoder.encode(new BASE64Encoder().encode(DEncrypt.md5(bfPostParam.toString()).getBytes()));

		StringBuffer urlParam = new StringBuffer("logistics_interface=");
		urlParam.append(xml);
		urlParam.append("&data_digest=");
		urlParam.append(strEncode);

//		String result=BasicControls.sendPost(BasicControls.getIniValueByKey("Logistics", "Url_YZ"), urlParam.toString());
		String result=BasicControls.sendPost("http://www.star360.com.cn/kd/hongxin/fineex/batchQuery", urlParam.toString());
		return result;
	}
	
	/**
	 * 获得邮政物流路由信息
	 * @param logisticNo 物流单号
	 * @return JSON
	 */
	public String getMsgByEMS(String logisticNo) {
//		StringBuffer url=new StringBuffer(BasicControls.getIniValueByKey("Logistics", "Url_EMS"));
		StringBuffer url=new StringBuffer("http://211.156.193.140:8000/cotrackapi/api/track/mail/");
		url.append(logisticNo);
		String result = "";
		try {
			result=BasicControls.sendGet(url.toString(),"");
		} catch (Exception e) {
			e.printStackTrace();
			result = "ERROR";
		}
		return result;
	}
}
