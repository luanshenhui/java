package hongling.service.fabricwareroom;

import hongling.business.FabricWareroomManager;
import hongling.entity.FabricWareroom;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.write.WriteException;

import chinsoft.business.CDict;
import chinsoft.business.ExcelHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class ExportFabricWarerooms extends BaseServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		System.out.println(getParameter("formData"));
		String fabricNo=getParameter("searchFabricNo");
		String property=getParameter("searchProperty");
		String brands=getParameter("searchBrands");
		String category=getParameter("searchCategory");
		String belong=getParameter("belong");
		String status=getParameter("status");
		if("--请选择--".equals(belong)){
			belong="";
		}
		if("-1".equals(brands)){
			brands="";
		}
		if("-1".equals(category)){
			category="";
		}
		
		try {
			ArrayList<String> header=new ArrayList<String>();
			ArrayList<List<String>> rows=new ArrayList<List<String>>();
			
			header.add("面料编码");
			header.add("分类");
			header.add("颜色");
			header.add("属性");
			header.add("RMB");
			header.add("DOLLAR");
			header.add("库存");
			header.add("品牌");
			header.add("单位");
			header.add("状态");
			
			List<FabricWareroom> fabricwarerooms=new FabricWareroomManager().getFabricWarerooms(0, 10000000, fabricNo, property, brands, category,belong,status);
			System.out.println(fabricwarerooms.size());
			if(fabricwarerooms.size()>0){
				for (FabricWareroom f : fabricwarerooms) {
					
					List<String> row=new ArrayList<String>();
					row.add(f.getFabricNo());
					row.add(f.getCategoryName());
					row.add(f.getColorName());
					row.add(f.getPropertyName());
					row.add(f.getRmb().toString());
					row.add(f.getDollar().toString());
					row.add(f.getStock().toString());
					row.add(f.getFabricTrader().getTraderName());
					row.add(f.getBelong());
					row.add(f.getStatus()==10050?"在线":"下架");
					rows.add(row);
				}
			}
			String fileName = "FabricWareroomStatus_putOn-" + Utility.dateToStr(new Date(),"yyyy-MM-dd") + ".xls";
			resp.reset();
			// 禁止数据缓存。
			resp.setHeader("Pragma", "no-cache");

			try {
				resp.setHeader("Content-Disposition","attachment;filename=\""+ new String(fileName.getBytes("UTF8"),"iso-8859-1") + "\"");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			resp.setContentType("application/octet-stream;charset=UTF-8");
			ExcelHelper.exportExcel(header, rows, Workbook.createWorkbook(resp.getOutputStream()),"下架面料库存信息");
			return;
		} catch (WriteException e) {
			e.printStackTrace();
		}
			
	}
}
