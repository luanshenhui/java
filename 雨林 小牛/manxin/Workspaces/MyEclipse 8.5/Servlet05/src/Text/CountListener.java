package Text;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class CountListener implements HttpSessionListener{
	private int count = 0;//计数器
	//当session对象被创建之后，容器会调用这个方法
	public void sessionCreated(HttpSessionEvent arg0) {
		System.out.println("sessionCreated...");
		count ++;
		//将在线人数(count)绑定到servlet上下文
		HttpSession session = arg0.getSession();
		ServletContext sctx = session.getServletContext();
		sctx.setAttribute("count", count);
	}
	//当session对象被销毁之后，容器会调用这个方法
	public void sessionDestroyed(HttpSessionEvent arg0) {
		System.out.println("sessionDestroyed...");
		count --;
		HttpSession session = arg0.getSession();
		ServletContext sctx = session.getServletContext();
		sctx.setAttribute("count", count);
		
	}
	
}
