package chinsoft.service.orden;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.business.ExcelHelper;
import chinsoft.business.MemberManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;
public class ExportStatistic extends BaseServlet{
	
	private static final long serialVersionUID = 3941900143054890884L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			/*List<?> datas = new GetOrdenStatistic().getOrdenStatistic(request);
			
			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add(ResourceHelper.getValue("Orden_ClothingCategory"));
			headList.add(ResourceHelper.getValue("Common_Amount"));
			headList.add(ResourceHelper.getValue("Cash_Num"));

			// 要写入的数据
			List<List<String>> rows = new ArrayList<List<String>>();
			for (int j=0; j<datas.size();j++) {
				List<String> row = new ArrayList<String>();
				Object[] data = (Object[])datas.get(j);
				row.add(DictManager.getDictNameByID(Utility.toSafeInt(data[0])));
				row.add(Utility.toSafeString(data[1]));
				row.add(Utility.toSafeString(data[2]));
				rows.add(row);
			}*/
			
			// 要写入的数据
			List<List<String>> rows = new ArrayList<List<String>>();
			
			String strMemberID = getParameter("memberid");
			int moneySignID=Utility.toSafeInt(getParameter("moneySignid"));
			int statusID=Utility.toSafeInt(getParameter("ordenStatusID"));
			Member currentMember=null;
			if("-1".equals(strMemberID)){
				currentMember = CurrentInfo.getCurrentMember();
			}else{
				currentMember = new MemberManager().getMemberByID(strMemberID);
			}
			Date from = Utility.toSafeDateTime(getParameter("from"));
			Date to = Utility.toSafeDateTime(getParameter("to"));
			
			List<Member> list= new MemberManager().getSubMembers(currentMember.getCode(),moneySignID);//用户
			for(Member member : list){
				List<?> datas = new OrdenManager().getOrdenExportStatistic(member.getID(), from ,to,moneySignID,statusID);//数据
				for (int j=0; j<datas.size();j++) {
					List<String> row = new ArrayList<String>();
					Object[] data = (Object[])datas.get(j);
					row.add(member.getUsername());
					row.add(member.getCode());
					row.add(DictManager.getDictNameByID(Utility.toSafeInt(data[0])));
					row.add(Utility.toSafeString(data[1]));
					row.add(Utility.toSafeString(data[2]));
					row.add(Utility.toSafeString(data[3]));
					row.add(Utility.toSafeString(data[4]));
					row.add(DictManager.getDictNameByID(Utility.toSafeInt(data[5])));
					row.add(DictManager.getDictNameByID(Utility.toSafeInt(data[6])));
					rows.add(row);
				}
			}
			
			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add(ResourceHelper.getValue("Member_Moduler"));//用户
			headList.add(ResourceHelper.getValue("Member_Level"));//用户级别
			headList.add(ResourceHelper.getValue("Orden_ClothingCategory"));//服装分类
			headList.add("订单数量");//订单数量
			headList.add("产品数量");//产品数量
			headList.add("追加西裤数量");//产品数量
			headList.add(ResourceHelper.getValue("Cash_Num"));//订单金额
			headList.add(ResourceHelper.getValue("Common_Status"));//订单状态
			headList.add(ResourceHelper.getValue("Cash_MoneyKind"));//币种
			// 设置导出文件名
			String fileName = "statistic-" + Utility.dateToStr(new Date(),"yyyy-MM-dd")	+ ".xls";
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
			ExcelHelper.exportExcel(headList, rows, Workbook.createWorkbook(response
					.getOutputStream()),"statistic");
			return;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
