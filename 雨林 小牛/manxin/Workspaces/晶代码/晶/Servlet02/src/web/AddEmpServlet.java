package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DBUtil;

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
		Connection conn = null;
		PreparedStatement prep = null;
		try {
			conn = DBUtil.getConnection();
			prep = conn.prepareStatement(
					"insert into emp(name,salary,age) " +
					"values(?,?,?)");
			prep.setString(1, name);
			prep.setDouble(2, Double.parseDouble(salary));
			prep.setInt(3, Integer.parseInt(age));
			prep.executeUpdate();
//			out.println("����ɹ�");
//			out.close();
//			out.println("<a href='list'>Ա���б�</a>");
			response.sendRedirect("list");
			System.out.println("hello...");
		} catch (SQLException e) {
			e.printStackTrace();
			out.println("ϵͳ��æ���Ժ�����");
		}finally{
			if(prep != null){
				try {
					prep.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			DBUtil.close();
		}
	}

}
