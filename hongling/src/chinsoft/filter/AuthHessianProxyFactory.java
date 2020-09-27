package chinsoft.filter;

import java.io.IOException;
import java.net.URL;
import java.net.URLConnection;

import com.caucho.hessian.client.HessianProxyFactory;

/** 
 * @ClassName: AuthHessianProxyFactory 
 * @Description: Hessian 增加权限 
 * @author <a href="MailTo:data55.126.com">杨磊</a> 
 * @date 2014-4-16 下午4:53:33 
 * @version 1.0-SNAPSHOT
 */
public class AuthHessianProxyFactory extends HessianProxyFactory{
	@Override
	protected URLConnection openConnection(URL url) throws IOException {
		URLConnection conn = super.openConnection(url);   
        conn.setRequestProperty("AUTH", "RCMTM001");   
        return conn;    
	}

}

