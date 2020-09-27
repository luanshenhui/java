package Text;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CommentFilter1 implements Filter{
	private FilterConfig config;
	
	public CommentFilter1(){
		System.out.println("Filter1's constructor...");
	}
	/**
	 * 容器在删除过滤器之前 会调用destory方法
	 */
	public void destroy(){
		System.out.println("Filter's destory...");
	}
	/**
	 * 容器会调用doFilter方法来处理请求
	 * 容器会将request对象和response对象作为参数传给doFilter方法
	 * FilterChain对象有一个doFilter方法，如果该方法调用了，表示让容器继续向后调用后续的过滤器或者servlet
	 */
	public void doFilter(ServletRequest arg0, ServletResponse arg1,
			FilterChain arg2) throws IOException, ServletException {
		System.out.println("Filter's doFilter begin...");
		HttpServletRequest request = (HttpServletRequest)arg0;
		HttpServletResponse response = (HttpServletResponse)arg1;
		request.setCharacterEncoding("utf-8");
		String content = request.getParameter("content");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		//读过滤器的初始化参数
		String illegalStr = config.getInitParameter("illegalStr");
		if(content.indexOf(illegalStr) != -1){
			out.println("评论中包含了敏感字");
		}else{
			//调用后续的过滤器或者servlet
			arg2.doFilter(arg0, arg1);
		}
		System.out.println("Filter's doFilter end...");
		
	}
	/**
	 * 容器启动后，会立即创建过滤器对象
	 * 接下来，会调用init方法，在调用init方法之前
	 * 容器会先创建好一个符合FilterConfig接口要求的对象，
	 * 该对象可以用来访问过滤器的初始化参数(getInitParameter(String paraname))
	 */
	public void init(FilterConfig arg0)throws ServletException{
		System.out.println("Filter's init...");
		config = arg0;
	}
	
}
