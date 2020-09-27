package centling.service.orden;

import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;

import org.hibernate.Session;

import centling.business.BlExcelHelper;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.service.core.BaseServlet;

/**
 * 导出厂检单据
 */
public class BlExportInspection extends BaseServlet {

	private static final long serialVersionUID = 7467340784917743700L;

	@SuppressWarnings("deprecation")
	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			String strChkRow = request.getParameter("chkRow");

			List<List<String>> cells1 = new ArrayList<List<String>>();
			List<List<String>> cells2 = new ArrayList<List<String>>();

			Session ses = DataAccessObject.openSessionFactory().openSession();
			Connection conn = ses.connection();
			CallableStatement st = null;
			ResultSet rs = null;
			ResultSet rs2 = null;
			try {
				conn.setAutoCommit(false);
				String proc = "{Call GET_EXPORTINSPECTIONS(?,?,?)}";
				st = conn.prepareCall(proc);
				st.setString(1, strChkRow);
				st.registerOutParameter(2, oracle.jdbc.OracleTypes.CURSOR);// 输出参数
				st.registerOutParameter(3, oracle.jdbc.OracleTypes.CURSOR);// 输出参数

				st.execute();
				conn.commit();

				rs = (ResultSet) st.getObject(2);
				rs2 = (ResultSet) st.getObject(3);
				
				while (rs.next()) {
					List<String> rsStr1 = new ArrayList<String>();
					rsStr1.add(rs.getString("DeliveryCD"));
					rsStr1.add(rs.getString("ShortName"));
					rsStr1.add(rs.getString("ContractNum"));
					rsStr1.add(rs.getString("UserCountry"));
					rsStr1.add(rs.getString("DeliveryDate"));
					rsStr1.add(rs.getString("UnitCompany"));
					rsStr1.add(rs.getString("AllCount"));
					rsStr1.add(rs.getString("SignName"));
					cells1.add(rsStr1);
				}
				while (rs2.next()) {
					List<String> rsStr2 = new ArrayList<String>();
					rsStr2.add(rs2.getString("DeliveryCD"));
					rsStr2.add(rs2.getString("OrdenNum"));
					// rsStr2.add(rs2.getString("SingleClothing"));
					rsStr2.add(rs2.getString("Qty"));
					cells2.add(rsStr2);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (rs != null) {
					rs.close();
				}
				if (rs2 != null) {
					rs2.close();
				}
				if (st != null) {
					st.close();
				}
				if (conn != null) {
					conn.close();
				}
				if (ses != null) {
					ses.close();
				}
			}
			
			if (cells1.size()==0 || cells2.size()==0) {
				String msg = ResourceHelper.getValue("Delivery_NoInspectData");
				response.setContentType("text/html; charset=UTF-8"); //转码
			    PrintWriter out = response.getWriter();
			    out.flush();
			    out.println("<script>");
			    out.println("alert('"+msg+"');");
			    out.println("window.close();");
			    out.println("</script>");
			} else {
				// 设置导出文件名
				String fileName = "inspectionsList-"
						+ new SimpleDateFormat("yyyy-MM-dd").format(new Date())
						+ ".xls";
				response.reset();
				// 禁止数据缓存。
				response.setHeader("Pragma", "no-cache");
	
				try {
					response.setHeader(
							"Content-Disposition",
							"attachment;filename=\""
									+ new String(fileName.getBytes("UTF8"),
											"iso-8859-1") + "\"");
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
				response.setContentType("application/octet-stream;charset=UTF-8");
				BlExcelHelper.exportExcelChangjian(cells1, cells2,
						Workbook.createWorkbook(response.getOutputStream()),
						ResourceHelper.getValue("Delivery_InspectInfo"));
				return;
			}
		} catch (Exception e) {
			LogPrinter.error("BlExportInspection_" + e.getMessage());
			e.printStackTrace();
		}
	}
}
