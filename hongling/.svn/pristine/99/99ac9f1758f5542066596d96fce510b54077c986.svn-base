package chinsoft.test;

import javax.xml.namespace.QName;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;

public class TestGetXMLService {
	public static void main(String[] args) {
		String sResult = null;
		String sTargetEndpointAddress = "http://localhost:8080/hongling/services/XmlService?wsdl";
		Service service = new Service();
		Call call = null;
		try {
			call = (Call) service.createCall();
			call.setTargetEndpointAddress(sTargetEndpointAddress);
			call.setOperationName(new QName("http://service",	"submitOrder"));
			sResult = (String) call.invoke(new Object[] { "发送给服务器的XML" });
			System.out.println(sResult);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
