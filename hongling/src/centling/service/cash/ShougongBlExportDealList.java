package centling.service.cash;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;

import centling.business.BlDealManager;
import centling.dto.DealDto;
import chinsoft.business.CurrentInfo;
import chinsoft.business.CustomerManager;
import chinsoft.business.ExcelHelper;
import chinsoft.business.MemberManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class ShougongBlExportDealList extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		try {
			//String formData=getParameter("formData");
			String keyword=getParameter("keyword");
			String fromdate=getParameter("fromDate");
			String todate=getParameter("toDate");
			String memberid=CurrentInfo.getCurrentMember().getID();
			
			Date fromDate=null;
			Date toDate=null;
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			
			if(!("".equals(fromdate))&&!("".equals(toDate))){
				fromDate = sdf.parse(fromdate);
				toDate = sdf.parse(todate);
			}
			
			
			System.out.println(keyword+"-"+fromdate+"-"+todate+"-"+memberid);
			
			ArrayList<String> header=new ArrayList<String>();
			ArrayList<List<String>> rows=new ArrayList<List<String>>();
			
			header.add("交易日期");
			header.add("客户公司名称");
			header.add("账户名");
			header.add("交易项目");
			header.add("币种");
			header.add("记账金额(收入)");
			header.add("记账金额(支出)");
			header.add("订单号/运单号");
			header.add("当前金额");
			header.add("备注");
			header.add("面料号");
			header.add("客户名称");
			
			
			 List<DealDto> dealdtos = new BlDealManager().getDeals(0, 100000000, memberid, keyword, fromDate, toDate);
			if(dealdtos.size()>0){
				for (DealDto d : dealdtos) {
					List<String> row=new ArrayList<String>();
					row.add(d.getDealDate());
					row.add(d.getCompanyName());
					row.add(d.getUsername());
					row.add(d.getDealItemName());
					row.add(d.getMoneySignName());
					row.add(d.getAccountIn());
					row.add(d.getAccountOut());
					row.add(d.getOrdenId());
					row.add(d.getNum());
					row.add(new OrdenManager().getordenByOrderId(d.getOrdenId())==null?"":new OrdenManager().getordenByOrderId(d.getOrdenId()).getFabricCode());
					row.add(new OrdenManager().getordenByOrderId(d.getOrdenId())==null?"":(new CustomerManager().getCustomerByID(new OrdenManager().getordenByOrderId(d.getOrdenId()).getCustomerID())==null?"":new CustomerManager().getCustomerByID(new OrdenManager().getordenByOrderId(d.getOrdenId()).getCustomerID()).getName()));
					row.add(d.getMemo());
					
					rows.add(row);
				}
			}
			
			String fileName = "shougongduizhangdan-" + Utility.dateToStr(new Date(),"yyyy-MM-dd") + ".xls";
			resp.reset();
			// 禁止数据缓存。
			resp.setHeader("Pragma", "no-cache");

			try {
				resp.setHeader("Content-Disposition","attachment;filename=\""+ new String(fileName.getBytes("UTF8"),"iso-8859-1") + "\"");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			resp.setContentType("application/octet-stream;charset=UTF-8");
			ExcelHelper.exportExcel(header, rows, Workbook.createWorkbook(resp.getOutputStream()),"手工对账单");
			return;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		
	}
}
