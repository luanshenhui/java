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
		 *  �ӿͻ��˻�ȡ�����Ժ�һ��Ҫ�����ݵ���֤��
		 *  ���磬����������ֵ�Ƿ�Ϊnull���߿��ַ���
		 *  �Ƿ�Ϊ�Ϸ������ֵȵȡ��˴��ԡ�
		 */
		
		/*
		 * ����1������һ��content-type��Ϣͷ��
		 * ������������ص��������ͺͱ����ʽ��
		 * ����2������out.println�������ʱ��ʹ�õ�
		 * �����ʽ��
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
			out.println("ϵͳ��æ���Ժ�����");
		}
	}

}
