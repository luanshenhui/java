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

public class LoadEmpServlet extends HttpServlet{
	public void service(HttpServletRequest request,
			HttpServletResponse response) 
	throws ServletException,IOException{
		response.setContentType(
				"text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		String id = request.getParameter("id");
		Connection conn = null;
		PreparedStatement stat = null;
		ResultSet rst = null;
		try {
			conn = DBUtil.getConnection();
			stat = conn.prepareStatement(
					"select * from emp where id=?");
			stat.setInt(1, Integer.parseInt(id));
			rst = stat.executeQuery();
			if(rst.next()){
				String name = rst.getString("name");
				double salary = rst.getDouble("salary");
				int age = rst.getInt("age");
				out.println("<form action='modify?id=" + id + "' method='post'>");
				out.println("id:" + id + "<br/>");
				out.println(
						"姓名:<input name='name' value='" 
						+ name + "'/><br/>");
				out.println(
						"薪水:<input name='salary' value='" 
						+ salary + "'/><br/>");
				out.println(
						"年龄:<input name='age' value='" 
						+ age + "'/><br/>");
				//out.println("<input type='hidden' name='id' value='" + id + "'/>");
				out.println("<input type='submit' value='提交'/>");
				out.println("</form>");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			out.println("稍后重试");
		}finally{
			if(rst != null){
				try {
					rst.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if(stat != null){
				try {
					stat.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			DBUtil.close();
		}
		
	}
	
	
	
}
