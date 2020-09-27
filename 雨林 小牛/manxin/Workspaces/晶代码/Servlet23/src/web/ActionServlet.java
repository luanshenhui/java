package web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.AccountLimitException;
import service.AccountNotExsitException;
import service.AccountService;

public class ActionServlet extends HttpServlet {

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String uri = request.getRequestURI();
		String action = 
			uri.substring(uri.lastIndexOf("/"),
					uri.lastIndexOf("."));
		//分析请求资源路径，依据请求调用不同的模型来处理
		if(action.equals("/apply")){
			AccountService service = 
				new AccountService();
			String accountNo = 
				request.getParameter("accountNo");
			String amount = 
				request.getParameter("amount");
			try {
				String number = service.apply(
						accountNo, Double.parseDouble(
								amount));
				//依据模型返回的结果，选择合适的视图
				request.setAttribute("number", number);
				request.getRequestDispatcher("view.jsp")
				.forward(request, response);
			} catch (Exception e) {
				e.printStackTrace();
				if(e instanceof AccountNotExsitException){
					request.setAttribute("apply_error",
							"帐号不存在");
					request.getRequestDispatcher("apply_form.jsp")
					.forward(request, response);
				}else if(e instanceof AccountLimitException){
					request.setAttribute("apply_error",
					"余额不足");
			request.getRequestDispatcher("apply_form.jsp")
			.forward(request, response);
				}else{
					throw new ServletException(e);
				}
			} 
			
		}
	}

}
