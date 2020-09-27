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

public class ModifyEmpServlet extends HttpServlet{
	public void service(HttpServletRequest request,
			HttpServletResponse response) 
	throws ServletException,IOException{
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		String salary = request.getParameter("salary");
		String age = request.getParameter("age");
		Connection conn = null;
		PreparedStatement prep = null;
		try {
			conn = DBUtil.getConnection();
			prep = conn.prepareStatement(
					"update emp " +
					"set name=?,salary=?,age=? where id=?");
			prep.setString(1, name);
			prep.setDouble(2, Double.parseDouble(salary));
			prep.setInt(3, Integer.parseInt(age));
			prep.setInt(4, Integer.parseInt(id));
			prep.executeUpdate();
			response.sendRedirect("list");
		} catch (SQLException e) {
			e.printStackTrace();
			out.println("…‘∫Û÷ÿ ‘");
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
