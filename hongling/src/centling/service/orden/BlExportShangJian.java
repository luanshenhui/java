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
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.service.core.BaseServlet;

/**
 * 导出商检及报关数据
 * 
 */
public class BlExportShangJian extends BaseServlet {
	private static final long serialVersionUID = -952438227343775760L;

	@SuppressWarnings("deprecation")
	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			String strFormData = getParameter("formData");
			String strChkRow = EntityHelper
					.getValueByKey(strFormData, "chkRow").toString();
			String multpleFlag = EntityHelper.getValueByKey(strFormData,
					"multpleFlag").toString();

			List<List<String>> cells1 = new ArrayList<List<String>>();
			List<List<String>> cells2 = new ArrayList<List<String>>();
			List<List<String>> cells3 = new ArrayList<List<String>>();
			List<List<String>> cells4 = new ArrayList<List<String>>();
			List<List<String>> cells5 = new ArrayList<List<String>>();
			List<List<String>> cells6 = new ArrayList<List<String>>();
			List<List<String>> cells7 = new ArrayList<List<String>>();
			
			Session ses = DataAccessObject.openSessionFactory().openSession();// this.getHibernateTemplate().getSessionFactory().openSession();
			Connection conn = ses.connection();
			CallableStatement st = null;
			try {

				conn.setAutoCommit(false);
				String proc = "{Call GET_EXPORTDELIVERY(?,?,?,?,?,?,?,?,?)}";
				st = conn.prepareCall(proc);
				// st.registerOutParameter(1,
				// oracle.jdbc.OracleTypes.CURSOR);//输出参数
				st.setString(1, strChkRow);
				st.setString(2, multpleFlag);
				st.registerOutParameter(3, oracle.jdbc.OracleTypes.CURSOR);
				st.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
				st.registerOutParameter(5, oracle.jdbc.OracleTypes.CURSOR);
				st.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);
				st.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
				st.registerOutParameter(8, oracle.jdbc.OracleTypes.CURSOR);
				st.registerOutParameter(9, oracle.jdbc.OracleTypes.CURSOR);

				st.execute();
				conn.commit();

				ResultSet rs = (ResultSet) st.getObject(3);
				ResultSet rs2 = (ResultSet) st.getObject(4);
				ResultSet rs3 = (ResultSet) st.getObject(5);
				ResultSet rs4 = (ResultSet) st.getObject(6);
				ResultSet rs5 = (ResultSet) st.getObject(7);
				ResultSet rs6 = (ResultSet) st.getObject(8);
				ResultSet rs7 = (ResultSet)st.getObject(9);
				
				while (rs.next()) {
					List<String> rsStr1 = new ArrayList<String>();
					rsStr1.add(rs.getString("DeliveryCD"));
					rsStr1.add(rs.getString("Company"));
					rsStr1.add(rs.getString("Address"));
					rsStr1.add(rs.getString("UserAdressOne"));
					rsStr1.add(rs.getString("UserAdressTwo"));
					rsStr1.add(rs.getString("UserAdressThree"));
					rsStr1.add(rs.getString("UserCountry"));
					rsStr1.add(rs.getString("InvoiceShortname"));
					rsStr1.add(rs.getString("InvoiceapplyDays"));
					rsStr1.add(rs.getString("applyDays"));
					rsStr1.add(rs.getString("ContractNum"));
					rsStr1.add(rs.getString("ByVesselOrAir"));
					rsStr1.add(rs.getString("CompanyName"));
					cells1.add(rsStr1);
				}
				while (rs2.next()) {
					List<String> rsStr2 = new ArrayList<String>();
					rsStr2.add(rs2.getString("DeliveryCD"));
					rsStr2.add(rs2.getString("Descriptions"));
					rsStr2.add(rs2.getString("qty"));
					rsStr2.add(rs2.getString("Unit"));
					rsStr2.add(rs2.getString("UnitPrice"));
					rsStr2.add(rs2.getString("TotalAmount"));
					cells2.add(rsStr2);
				}
				while (rs3.next()) {
					List<String> rsStr3 = new ArrayList<String>();
					rsStr3.add(rs3.getString("DeliveryCD"));
					rsStr3.add(rs3.getString("UserAdressOne"));
					rsStr3.add(rs3.getString("UserAdressTwo"));
					rsStr3.add(rs3.getString("UserAdressThree"));
					rsStr3.add(rs3.getString("UserCountry"));
					rsStr3.add(rs3.getString("InvoiceShortname"));
					rsStr3.add(rs3.getString("InvoiceapplyDays"));
					rsStr3.add(rs3.getString("applyDays"));
					rsStr3.add(rs3.getString("ContractNum"));
					rsStr3.add(rs3.getString("ByVesselOrAir"));
					rsStr3.add(rs3.getString("CompanyName"));
					rsStr3.add(rs3.getString("Company"));
					cells3.add(rsStr3);
				}
				while (rs4.next()) {
					List<String> rsStr4 = new ArrayList<String>();
					rsStr4.add(rs4.getString("DeliveryCD"));
					rsStr4.add(rs4.getString("Descriptions"));
					rsStr4.add(rs4.getString("qty"));
					rsStr4.add(rs4.getString("UnitNW"));
					rsStr4.add(rs4.getString("TotalNW"));
					rsStr4.add(rs4.getString("TotalGW"));
					rsStr4.add(rs4.getString("MeasureCBM"));
					rsStr4.add(rs4.getString("Cartons"));
					cells4.add(rsStr4);
				}
				while (rs5.next()) {
					List<String> rsStr5 = new ArrayList<String>();
					rsStr5.add(rs5.getString("DeliveryCD"));
					rsStr5.add(rs5.getString("Company"));
					rsStr5.add(rs5.getString("Address"));
					rsStr5.add(rs5.getString("UserAdressOne"));
					rsStr5.add(rs5.getString("UserAdressTwo"));
					rsStr5.add(rs5.getString("UserAdressThree"));
					rsStr5.add(rs5.getString("UserCountry"));
					rsStr5.add(rs5.getString("InvoiceShortname"));
					rsStr5.add(rs5.getString("InvoiceapplyDays"));
					rsStr5.add(rs5.getString("applyDays"));
					rsStr5.add(rs5.getString("ContractNum"));
					rsStr5.add(rs5.getString("ContractEndDate"));
					rsStr5.add(rs5.getString("PartyA"));
					rsStr5.add(rs5.getString("PartyB"));
					rsStr5.add(rs5.getString("StreetAddress"));
					rsStr5.add(rs5.getString("BigCompany"));
					rsStr5.add(rs5.getString("CompanyName"));
					cells5.add(rsStr5);
				}
				while (rs6.next()) {
					List<String> rsStr6 = new ArrayList<String>();
					rsStr6.add(rs6.getString("DeliveryCD"));
					rsStr6.add(rs6.getString("Descriptions"));
					rsStr6.add(rs6.getString("qty"));
					rsStr6.add(rs6.getString("UnitPrice"));
					System.out.println("UnitPrice---------"+rs6.getString("UnitPrice"));
					rsStr6.add(rs6.getString("TotalAmount"));
					cells6.add(rsStr6);
				}
				while (rs7.next()) {
					List<String> rsStr7 = new ArrayList<String>();
					rsStr7.add(rs7.getString("ContractNum"));
					rsStr7.add(rs7.getString("CLOTHINGNAME"));
					rsStr7.add(rs7.getString("CLOTHINGNO"));
					rsStr7.add(rs7.getString("TOTALAMOUNT"));
					rsStr7.add(rs7.getString("ORDENPRICE"));
					System.out.println("---------"+rs7.getString("ORDENPRICE"));
					cells7.add(rsStr7);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
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

			if (cells1.size() == 0 && cells3.size() == 0 && cells5.size() == 0) {
				String msg = ResourceHelper.getValue("Delivery_NoShangJianData");
				response.setContentType("text/html; charset=UTF-8"); //转码
			    PrintWriter out = response.getWriter();
			    out.flush();
			    out.println("<script>");
			    out.println("alert('"+msg+"');");
			    out.println("window.close();");
			    out.println("</script>");
			} else {
				String fileName = "";
				if ("1".equals(multpleFlag)) {
					fileName = "BaoGuanList-"
							+ new SimpleDateFormat("yyyy-MM-dd").format(new Date())
							+ ".xls";
				} else {
					fileName = "ShangjianList-"
							+ new SimpleDateFormat("yyyy-MM-dd").format(new Date())
							+ ".xls";
				}
	
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
				BlExcelHelper.exportExcelShangjian(multpleFlag,cells1, cells2, cells3, cells4,
						cells5, cells6,	cells7, Workbook.createWorkbook(response.getOutputStream()),"");
				return;
			}
		} catch (Exception e) {
			LogPrinter.error("BlExportShangJian_" + e.getMessage());
			e.printStackTrace();
		}
	}
}
