package chinsoft.wsdl;

import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.jws.soap.SOAPBinding.Style;

/**
 * <p>Title: IServiceToRcmtm</p>
 * <p>Description: 新下单系统接口 </p>
 * <p>Company: RCMTM</p> 
 * @author   杨磊
 * @date       2013-6-28
 * @version 1.0
 */
@WebService
@SOAPBinding(style = Style.RPC)
public interface IServiceToRcmtm {
//	public String doUpdateOrderStatus(String strCode, String strStatus);
	
	
	/**
	 * <p>获得所有的面料价格</p>
	 * @return String strJSON
	 */
	public String getFabricPrice();
	
	/**
	 * <p>获得所有的面料</p>
	 * @return String strJSON
	 */
	public String getFabric();
}
