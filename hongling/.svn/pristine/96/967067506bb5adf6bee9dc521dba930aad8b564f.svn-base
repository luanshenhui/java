package chinsoft.service.delivery;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import chinsoft.business.DeliveryManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Delivery;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;
public class ExportDelivery extends BaseServlet{
	
	private static final long serialVersionUID = 3941900143054890884L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String strDeliveryID = request.getParameter("id");	
			Delivery delivery = new DeliveryManager().getDeliveryByID(strDeliveryID);			
			List<Orden> ordens = delivery.getOrdens();

			// 设置导出文件名
			String fileName = "DeliveryList-" + new SimpleDateFormat("yyyy-MM-dd").format(new Date())+ ".xls";
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
			
			WritableWorkbook wwb = Workbook.createWorkbook(response.getOutputStream());
			WritableSheet ws = wwb.createSheet("发货单", 0);
			
			ws.addCell(new jxl.write.Label(0, 0, "发货单"));
			ws.mergeCells(0, 0, 6, 0);
			
			ws.addCell(new jxl.write.Label(0, 1, "发货时间"));
			ws.addCell(new jxl.write.Label(1, 1, Utility.dateToStr(delivery.getDeliveryDate(),"yyyy-MM-dd")));
			ws.addCell(new jxl.write.Label(2, 1, "发货地址"));
			ws.addCell(new jxl.write.Label(3, 1, delivery.getDeliveryAddress()));
			//插入头部
			ws.addCell(new jxl.write.Label(0, 3, "订单号"));
			ws.addCell(new jxl.write.Label(1, 3, "分类"));
			ws.addCell(new jxl.write.Label(2, 3, "面料"));
			//插入内容
			for(int i=0 ;i< ordens.size() ;i++){
				ws.addCell(new jxl.write.Label(0, i+4, ordens.get(i).getOrdenID()));
				ws.addCell(new jxl.write.Label(1, i+4, ordens.get(i).getClothingName()));
				ws.addCell(new jxl.write.Label(2, i+4, ordens.get(i).getFabricCode()));
			}
			wwb.write();
			wwb.close();
			return;
			
		} catch (Exception e) {
			LogPrinter.error("ExportMembers_" + e.getMessage());
			e.printStackTrace();
		}
	}
}
