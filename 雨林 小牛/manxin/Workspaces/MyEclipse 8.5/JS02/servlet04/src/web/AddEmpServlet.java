package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.Factory;
import dao.EmployeeDAO;
import entity.Employee;

public class AddEmpServlet extends HttpServlet {
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		String name = request.getParameter("name");
		String salary = request.getParameter("salary");
		String age = request.getParameter("age");
		/*
		 *  从客户端获取数据以后，一定要做数据的验证，
		 *  比如，检查请求参数值是否为null或者空字符，
		 *  是否为合法的数字等等。此处略。
		 */
		
		/*
		 * 作用1：生成一个content-type消息头，
		 * 告诉浏览器返回的数据类型和编码格式。
		 * 作用2：设置out.println方法输出时所使用的
		 * 编码格式。
		 */
		response.setContentType(
				"text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		try {
			EmployeeDAO dao = 
				(EmployeeDAO)Factory.getInstance(
						"EmployeeDAO");
			Employee e = new Employee();
			e.setName(name);
			e.setSalary(Double.parseDouble(salary));
			e.setAge(Integer.parseInt(age));
			dao.save(e);
			response.sendRedirect("list");
		} catch (Exception e) {
			e.printStackTrace();
			out.println("系统繁忙，稍后重试");
		}
	}

}
