package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DBUtil;

public class ListEmpServlet extends HttpServlet{
	public void service(HttpServletRequest request,
			HttpServletResponse response) 
	throws ServletException,IOException{
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		Connection conn = null;
		PreparedStatement prep = null;
		ResultSet rst = null;
		try {
			conn = DBUtil.getConnection();
			prep = conn.prepareStatement(
					"select * from emp");
			rst = prep.executeQuery();
			//输出一个表格
			out.println("<table border='1' " +
					"width='60%' cellpadding='0' cellspacing='0'>");
			out.println("<tr><td>ID</td><td>姓名</td>" +
					"<td>薪水</td><td>年龄</td>" +
					"<td>操作</td></tr>");
			while(rst.next()){
				int id = rst.getInt("id");
				String name = rst.getString("name");
				double salary = rst.getDouble("salary");
				int age = rst.getInt("age");
				out.println("<tr><td>" + id 
						+ "</td><td>" + name 
						+ "</td><td>" + salary 
						+ "</td><td>" + age 
						+ "</td><td><a href='del?id=" 
						+ id + "'>删除</a>" +
								"&nbsp;&nbsp;<a href='load?id=" 
						+ id + "'>修改</a></td></tr>");
			}
			out.println("</table>");
			out.println("<a href='addEmp.html'>" +
					"添加员工</a>");
		} catch (SQLException e) {
			e.printStackTrace();
			out.println("a");
		}finally{
			if(rst != null){
				try {
					rst.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
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
