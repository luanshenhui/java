package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ActionServlet extends HttpServlet {

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		String uri = request.getRequestURI();
		String action = uri.substring(uri.lastIndexOf("/"),
				uri.lastIndexOf("."));
		if(action.equals("/check_username")){
			String username = 
				request.getParameter("username");
			System.out.println("username:" 
					+ username);
			try {
				//模拟服务器正在进行一项比较耗时的操作
				Thread.sleep(6000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
//			if(1 == 2){
//				throw new ServletException(
//						"模拟一个系统异常");
//			}
			if("方法".equals(username)){
				out.println("用户名已经被占用");
			}else{
				out.println("可以使用");
			}
		}else if(action.equals("/regist")){
			//仍然要检查用户名是否存在
			String username = 
				request.getParameter("username");
			if("zs".equals(username)){
				request.setAttribute("regist_error",
						"用户名已经存在");
				request.getRequestDispatcher("regist.jsp")
				.forward(request, response);
			}else{
				System.out.println("插入用户注册的信息...");
			}
		}
		
	}

}
