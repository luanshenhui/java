package chinsoft.business;

import java.rmi.RemoteException;

import javax.xml.namespace.QName;
import javax.xml.rpc.ServiceException;

import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.Options;
import org.apache.axis2.rpc.client.RPCServiceClient;

import chinsoft.core.ConfigHelper;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;

public class CoderManager {

	DataAccessObject dao = new DataAccessObject();
	private String WebService_Erp_Address = Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_Erp_Address"));
	private String WebService_NameSpace = Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_NameSpace"));
	public static Object invokeService(String strAddress, String strNameSpace, String strMethodName, Object[] params,Class<?>[] classTypes) throws ServiceException,	RemoteException {
		EndpointReference targetEPR = new EndpointReference(strAddress);
		RPCServiceClient serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		options.setTo(targetEPR);
		QName opAddEntry = new QName(strNameSpace, strMethodName);
		return serviceClient.invokeBlocking(opAddEntry, params,classTypes)[0];
	}
	//编码转换
	public String getBom(String strType,String strCode){
		String str = "";
		try {
			Object[] params = new Object[] {strType, strCode};
			Class<?>[] classTypes=new Class<?>[]{String.class,String.class};
			str = Utility.toSafeString(XmlManager.invokeService(WebService_Erp_Address, WebService_NameSpace, "getConversionCode", params,classTypes));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return str;
	}
} 