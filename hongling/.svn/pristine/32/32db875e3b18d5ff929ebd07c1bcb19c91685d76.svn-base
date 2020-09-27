package centling.service.orden;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import centling.business.BlDeliveryManager;
import centling.business.BlExcelHelper;
import centling.dto.DeliveryOrdenDetailDto;
import centling.util.BlDateUtil;
import chinsoft.business.DeliveryManager;
import chinsoft.business.MemberManager;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Delivery;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class BlExportDelivery extends BaseServlet {
	private static final long serialVersionUID = -2181458144165745165L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String deliveryId = request.getParameter("deliveryid");		
			
			// 设置表头信息
			Map<String, String> headMap = new HashMap<String, String>();
			Delivery delivery = new DeliveryManager().getDeliveryByID(deliveryId);
			// 根据发货单编号得到用户ID
			Member member = new MemberManager().getMemberByID(delivery.getPubMemberID());
			headMap.put("pubMemberName", member.getUsername());
			headMap.put("deliveryDate", BlDateUtil.formatDate(delivery.getDeliveryDate(), "yyyy-MM-dd"));
			headMap.put("bizPerson", "王程程");
			headMap.put("memo", delivery.getMemo());
			
			// 根据发货ID得到发货明细
			List<DeliveryOrdenDetailDto> deliveryOrdenDetailList = new ArrayList<DeliveryOrdenDetailDto>();
			deliveryOrdenDetailList = new BlDeliveryManager().getDeliveryDetailByDeliveryId(deliveryId);
			
			// 要写入的数据
			List<List<String>> cells = new ArrayList<List<String>>();
			for (DeliveryOrdenDetailDto bldeliveryOrdenDto : deliveryOrdenDetailList) {
				List<String> deliveryDetailList = new ArrayList<String>();
				// 设置序号
				deliveryDetailList.add(bldeliveryOrdenDto.getNumber().toString());
				// 设置订单号
				deliveryDetailList.add(bldeliveryOrdenDto.getOrdenID());
				// 设置数量
				deliveryDetailList.add(bldeliveryOrdenDto.getAmount());
				// 设置面料成份
				deliveryDetailList.add(bldeliveryOrdenDto.getCompositionName());
				// 设置男装\女装
				deliveryDetailList.add(bldeliveryOrdenDto.getClosingType());
				
				// 设置箱号、备注为空
				deliveryDetailList.add("");
				deliveryDetailList.add("");
				cells.add(deliveryDetailList);
			}
			// 设置导出文件名
			String fileName = "delivery-details-" + BlDateUtil.formatDate(new Date(), "MM-dd") + ".xls";
			response.reset();
			// 禁止数据缓存。
	        response.setHeader("Pragma", "no-cache");
			
			try {
				response.setHeader("Content-Disposition","attachment;filename=\""
					+ new String(fileName.getBytes("UTF8"),"iso-8859-1") + "\"");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			response.setContentType("application/octet-stream;charset=UTF-8");
			BlExcelHelper.exportExcelDelivery(headMap, cells, Workbook.createWorkbook(response
					.getOutputStream()),"sheet1");
			return;
			
		} catch (Exception e) {
			LogPrinter.error("ExportOrdens_" + e.getMessage());
			e.printStackTrace();
		}
	}
}
