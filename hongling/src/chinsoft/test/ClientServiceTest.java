package chinsoft.test;

import javax.xml.namespace.QName;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;

public class ClientServiceTest {
	public static void main(String[] args) {
		String sResult = null;
		String sTargetEndpointAddress = "http://webservice.webxml.com.cn/WebServices/IpAddressSearchWebService.asmx?wsdl";
		Service service = new Service();
		Call call = null;
		try {
			call = (Call) service.createCall();
			call.setTargetEndpointAddress(sTargetEndpointAddress);
			call.setOperationName(new QName("http://WebXml.com.cn/xsd/",	"getCountryCityByIp"));
			sResult = (String) call.invoke(new Object[] { "202.102.134.68" });
			System.out.println(sResult);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
