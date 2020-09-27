package hongling.service.fabrictrader;

import hongling.business.FabricTraderManager;
import hongling.util.DateUtils;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;

import org.apache.commons.lang.StringUtils;

import chinsoft.business.ExcelHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.service.core.BaseServlet;

/**
 * 将零售面料报表信息导出excel表格
 * @author Wang.Yue
 * @version 2015.5.7
 * @category servlet
 */
public class ExportFabricPrice extends BaseServlet {
	private static final long serialVersionUID = 1L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response){
		try {
			String searchKeyword = request.getParameter("searchKeyword");
			String begintime = request.getParameter("dealDate");
			String fpareaId = request.getParameter("fpareaid");
			Date begindate=null;
			if(StringUtils.isNotBlank(begintime)){
				begindate=DateUtils.parse(begintime, "yyyy-MM-dd");
			}
			@SuppressWarnings("unchecked")
			List<Object> list=new FabricTraderManager().getFabricReport(searchKeyword, 0, 999999999, begindate , fpareaId);
		
			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add("面料code");
			headList.add("品牌");
			headList.add("面料成分");
			headList.add("面料颜色");
			headList.add("人民币价格");
			headList.add("美元价格");
			headList.add("月度使用米数");
			headList.add("年度使用米数");
			// 要写入的数据
			List<List<String>> cells = new ArrayList<List<String>>();
			//12653478
			Iterator<Object> it = list.iterator();
			while(it.hasNext()){
				Object[] obj = (Object[]) it.next();
				List<String> fabric = new ArrayList<String>();
				fabric.add(String.valueOf(obj[1]));
				fabric.add(String.valueOf(obj[2]));
				fabric.add(String.valueOf(obj[6]));
				fabric.add(String.valueOf(obj[5]));
				fabric.add("￥"+String.valueOf(obj[3]));
				fabric.add("$"+String.valueOf(obj[4]));
				fabric.add(String.valueOf(obj[7]));
				fabric.add(String.valueOf(obj[8]));
				cells.add(fabric);
			}	
			// 设置导出文件名
			String fileName = "fabricList-"
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
			ExcelHelper.exportExcel(headList, cells,
					Workbook.createWorkbook(response.getOutputStream()),
					ResourceHelper.getValue("Orden_Info"));
			return;
		} catch (Exception e) {
			LogPrinter.error("ExportFabricPrice_" + e.getMessage());
			e.printStackTrace();
		}
	}
}
