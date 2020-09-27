package centling.service.delivery;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import net.sf.json.JSONObject;
import centling.business.BlDeliveryManager;
import centling.business.BlExcelHelper;
import centling.dto.DeliveryOrdenDetailDto;
import centling.util.BlDateUtil;
import chinsoft.business.CurrentInfo;
import chinsoft.core.LogPrinter;
import chinsoft.service.core.BaseServlet;

public class BlExportDeliveryDetail extends BaseServlet {
	private static final long serialVersionUID = 8873756677202706248L;
	
	/**
	 * 批量导出发货单明细
	 */
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) {
		super.service();
		
		// 得到参数
		String param = request.getParameter("param");
		JSONObject obj = JSONObject.fromObject(param);
		String strBlKeyword = obj.getString("blDetailKeyword");
		String deliveryFromDate = obj.getString("blDeliverFromDate");
		String deliveryToDate = obj.getString("blDeliverToDate");
		String from = obj.getString("from");
		String currentMemberId = "";
		
		if ("qiantai".equals(from)) {
			currentMemberId = CurrentInfo.getCurrentMember().getID();
		}
		
		try {
			// 表头信息集合
			List<Map<String, String>> headMapList = new BlDeliveryManager().getBatchHeadMapList(currentMemberId,strBlKeyword, deliveryFromDate, deliveryToDate);
			
			if (headMapList.size()>0) {
				// 得到单元格信息
				List<DeliveryOrdenDetailDto> deliveryOrdenDetailList = new ArrayList<DeliveryOrdenDetailDto>();
				
				deliveryOrdenDetailList = new BlDeliveryManager().getDeliveryDetailByDeliveryId(currentMemberId,strBlKeyword, deliveryFromDate, deliveryToDate);
				Collections.sort(deliveryOrdenDetailList);
				
				Map<String, List<List<String>>> cellsMap = new HashMap<String, List<List<String>>>();
				
				List<List<String>> arrayList = new ArrayList<List<String>>();
				
				// map的key值
				String deliveryMapId = null;
				int num = 1;
				for (DeliveryOrdenDetailDto blDeliveryOrdenDetailDto: deliveryOrdenDetailList) {
					// 得到发货单ID
					String deliveryId = blDeliveryOrdenDetailDto.getDeliveryID();
	
					// 第一次遍历
					if (deliveryMapId == null) {
						deliveryMapId = deliveryId;
					}
					
					// 判断deliveryId是否发生变化
					// 如果发生变化 ，将arrayList的值保存到map中并将arrayList清空
					// 并将deliveryMapId设置为deliveryId
					// 将num值设置为1
					if (!deliveryMapId.equals(deliveryId)) {
						cellsMap.put(deliveryMapId, new ArrayList<List<String>>(arrayList));
						arrayList.clear();
						deliveryMapId = deliveryId;
						num=1;
					}
					
					List<String> deliveryDetailList = new ArrayList<String>();
					
					// 设置序号
					deliveryDetailList.add(String.valueOf(num));
					// 设置订单号
					deliveryDetailList.add(blDeliveryOrdenDetailDto.getOrdenID());
					// 设置数量
					deliveryDetailList.add(blDeliveryOrdenDetailDto.getAmount());
					// 设置面料成份
					deliveryDetailList.add(blDeliveryOrdenDetailDto.getCompositionName());
					// 设置男装\女装
					deliveryDetailList.add(blDeliveryOrdenDetailDto.getClosingType());
					
					// 设置箱号、备注为空
					deliveryDetailList.add("");
					deliveryDetailList.add("");
					
					arrayList.add(deliveryDetailList);
					num++;
				}
				
				// 将最后一个arrayList放入到map中
				List<List<String>> cells = cellsMap.get(deliveryMapId);
				if (cells == null || cells.size()<=0) {
					cellsMap.put(deliveryMapId, arrayList);
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
				BlExcelHelper.batchExportExcelDelivery(headMapList, cellsMap, Workbook.createWorkbook(response.getOutputStream()));
			}
		} catch (Exception e) {
			LogPrinter.error("BlExportDeliveryDetail_err"+e.getMessage());
		}
	}
}