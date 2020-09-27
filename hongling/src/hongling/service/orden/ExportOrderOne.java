package hongling.service.orden;


import hongling.util.DateUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.write.WriteException;

import org.apache.commons.lang.StringUtils;

import chinsoft.bean.RepairOrdenBean;
import chinsoft.business.RepairOrdenManager;
import chinsoft.business.RepairTopExcelUtil;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;
/**
 * 导出excel一级返修
 * @author Luan.shen.hui 
 * date 2015-05-08
 */

public class ExportOrderOne extends BaseServlet {
	
	private static final long serialVersionUID = 1L;

		@Override
		protected void service(HttpServletRequest req, HttpServletResponse response)
				throws ServletException, IOException {
			String category = getParameter("searchKeyword");
			String begintime=getParameter("dealDate"); 
			Date begindate=null;
			if(StringUtils.isNotBlank(begintime)){
				begindate=DateUtils.parse(begintime, "yyyy-MM-dd");
			}
			List<RepairOrdenBean> repairOrdenBean=new RepairOrdenManager().getOrdenOneReport(category, begindate);				
			try {
				ArrayList<String> header=new ArrayList<String>();
				ArrayList<List<String>> rows=new ArrayList<List<String>>();			
				header.add(" ");
				header.add(" ");
				header.add(" ");
				header.add(" ");
				header.add("尺寸原因");
				header.add("做工原因");
				header.add("版型返修");
				header.add("面辅料返修");
				header.add("更改款式");
				header.add("更改工艺");
				header.add("顾客原因");
				header.add("更改附件及配料");
				header.add("尺寸原因");
				header.add("做工原因");
				header.add("版型原因");
				header.add("面辅料原因");
				header.add("更改款式");
				header.add("更改工艺");
				header.add("顾客原因");
				header.add("更改附件及配料");
				header.add("尺寸原因");
				header.add("做工原因");
				header.add("版型原因");
				header.add("面辅料原因");
				header.add("更改款式");
				header.add("更改工艺");
				header.add("顾客原因");
				header.add("更改附件及配料");
				header.add(" ");
				header.add(" ");
				header.add(" ");		

				for (RepairOrdenBean r : repairOrdenBean) {	
					List<String> row=new ArrayList<String>();
					row.add(r.getUserName());				
					row.add(r.getNianXiadan());
					row.add(r.getYueXiadan());
					row.add(r.getRiXiadan());
					row.add(r.getNianRepairchicun());
					row.add(r.getNianRepairzuogong());
					row.add(r.getNianRepairbanxing());
					row.add(r.getNianRepairmianfuliao());
					row.add(r.getNianRepairgenggaiks());
					row.add(r.getNianRepairgenggaigy());
					row.add(r.getNianRepairgukeyy());
					row.add(r.getNianRepairgenggaifjjpsl());
					row.add(r.getYueRepairchicun());
					row.add(r.getYueRepairzuogong());
					row.add(r.getYueRepairbanxing());
					row.add(r.getYueRepairmianfuliao());
					row.add(r.getYueRepairgenggaiks());
					row.add(r.getYueRepairgenggaigy());
					row.add(r.getYueRepairgukeyy());
					row.add(r.getYueRepairgenggaifjjpsl());
					row.add(r.getRiRepairchicun());
					row.add(r.getRiRepairzuogong());
					row.add(r.getRiRepairbanxing());
					row.add(r.getRiRepairmianfuliao());
					row.add(r.getRiRepairgenggaiks());
					row.add(r.getRiRepairgenggaigy());
					row.add(r.getRiRepairgukeyy());
					row.add(r.getRiRepairgenggaifjjpsl());					
					row.add(r.getNianRepairlv()+"%");
					row.add(r.getYueRepairlv()+"%");
					row.add(r.getRiRepairlv()+"%");	
					rows.add(row);
				}
				
				String fileName = "FabricWareroomStatus_putOn-" + Utility.dateToStr(new Date(),"yyyy-MM-dd") + ".xls";
				response.reset();
				// 禁止数据缓存。
				response.setHeader("Pragma", "no-cache");

				response.setHeader("Content-Disposition","attachment;filename=\""+ new String(fileName.getBytes("UTF8"),"iso-8859-1") + "\"");
			
				response.setContentType("application/octet-stream;charset=UTF-8");
				RepairTopExcelUtil.exportExcel(header, rows, Workbook.createWorkbook(response.getOutputStream()),"一级返修信息");
				return;
			} catch (WriteException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
		}
	}




