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
		//����������Դ·��������������ò�ͬ��ģ��������
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
				//����ģ�ͷ��صĽ����ѡ����ʵ���ͼ
				request.setAttribute("number", number);
				request.getRequestDispatcher("view.jsp")
				.forward(request, response);
			} catch (Exception e) {
				e.printStackTrace();
				if(e instanceof AccountNotExsitException){
					request.setAttribute("apply_error",
							"�ʺŲ�����");
					request.getRequestDispatcher("apply_form.jsp")
					.forward(request, response);
				}else if(e instanceof AccountLimitException){
					request.setAttribute("apply_error",
					"����");
			request.getRequestDispatcher("apply_form.jsp")
			.forward(request, response);
				}else{
					throw new ServletException(e);
				}
			} 
			
		}
	}

}
