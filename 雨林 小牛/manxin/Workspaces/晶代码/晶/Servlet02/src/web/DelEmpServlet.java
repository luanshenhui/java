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

public class DelEmpServlet extends HttpServlet{
	public void service(HttpServletRequest request,
			HttpServletResponse response) 
	throws ServletException,IOException{
		response.setContentType(
				"text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		String id = request.getParameter("id");
		Connection conn = null;
		PreparedStatement stat = null;
		try {
			conn = DBUtil.getConnection();
			stat = conn.prepareStatement("delete from " +
					"emp where id=?");
			stat.setInt(1, Integer.parseInt(id));
			stat.executeUpdate();
			response.sendRedirect("list");
		} catch (SQLException e) {
			e.printStackTrace();
			out.println("…‘∫Û÷ÿ ‘");
		}finally{
			if(stat  != null){
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
