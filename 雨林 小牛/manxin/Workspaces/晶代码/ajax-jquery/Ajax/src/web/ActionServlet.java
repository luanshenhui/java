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
				//ģ����������ڽ���һ��ȽϺ�ʱ�Ĳ���
				Thread.sleep(6000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
//			if(1 == 2){
//				throw new ServletException(
//						"ģ��һ��ϵͳ�쳣");
//			}
			if("����".equals(username)){
				out.println("�û����Ѿ���ռ��");
			}else{
				out.println("����ʹ��");
			}
		}else if(action.equals("/regist")){
			//��ȻҪ����û����Ƿ����
			String username = 
				request.getParameter("username");
			if("zs".equals(username)){
				request.setAttribute("regist_error",
						"�û����Ѿ�����");
				request.getRequestDispatcher("regist.jsp")
				.forward(request, response);
			}else{
				System.out.println("�����û�ע�����Ϣ...");
			}
		}
		
	}

}
