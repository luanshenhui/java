package chinsoft.service.orden;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.format.UnderlineStyle;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.business.MemberManager;
import chinsoft.business.OrdenManager;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.service.core.BaseServlet;

public class ExportStatement extends BaseServlet{
	
	private static final long serialVersionUID = 3941900143054890884L;

	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			String strKeyword = getParameter("keyword");		
			String strMemberCode = CurrentInfo.getCurrentMember().getCode();
			int nStatusID = Utility.toSafeInt(getParameter("searchStatusID"));
			int nClothingID = Utility.toSafeInt(getParameter("searchClothingID"));
			String strPubMemberID = getParameter("searchClientID");
			Member member = new MemberManager().getMemberByID(strPubMemberID);
			
			Date fromDate = null;
			if (getParameter("fromDate") != null && !"".equals(getParameter("fromDate"))) {
				fromDate = Utility.toSafeDateTime(getParameter("fromDate"));
			}
			Date toDate = null;
			if (getParameter("toDate") != null && !"".equals(getParameter("toDate"))) {
				toDate = Utility.toSafeDateTime(getParameter("toDate"));
			}
			Date dealDate = null;
			Date dealToDate = null;
			if(getParameter("dealDate") != null &&!"".equals(getParameter("dealDate"))){
				dealDate = Utility.toSafeDateTime(getParameter("dealDate"));
			}
			if (getParameter("dealToDate")!=null && !"".equals(getParameter("dealToDate"))) {
				dealToDate = Utility.toSafeDateTime(getParameter("dealToDate"));
			}
			
			List<Orden> ordens = new ArrayList<Orden>();
			
			ordens = new OrdenManager().getOrdens(0, 100000000, strKeyword, strMemberCode, nStatusID, nClothingID, dealDate, dealToDate, fromDate, toDate, strPubMemberID);
			// 设置导出文件名
			String fileName = "statementList-" + new SimpleDateFormat("yyyy-MM-dd").format(new Date())+ ".xls";
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
		
			// 定义第一行单元格样式
			WritableFont wf = new WritableFont(WritableFont.createFont("宋体"), 10, WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE);
			//粗体字体
			WritableFont wf2 = new WritableFont(WritableFont.createFont("宋体"), 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE);
			
			//单元格样式定义
			WritableCellFormat wcf = new WritableCellFormat(wf);
			WritableCellFormat wcf2 = new WritableCellFormat(wf2);
			
			//加边框
			wcf.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
			
			//把水平对齐方式指定为居中
			wcf.setAlignment(jxl.format.Alignment.CENTRE);
			wcf2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
			wcf2.setAlignment(jxl.format.Alignment.CENTRE);
			
			//数字价格的格式
			jxl.write.NumberFormat nf = new jxl.write.NumberFormat("###,###.00"); 
	        jxl.write.WritableCellFormat wnf = new jxl.write.WritableCellFormat(nf);
	        jxl.write.WritableCellFormat wnf2 = new jxl.write.WritableCellFormat(nf);
	        wnf.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	        wnf.setFont(wf);
	        wnf.setAlignment(jxl.format.Alignment.CENTRE);
	        wnf2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	        wnf2.setFont(wf2);
	        wnf2.setAlignment(jxl.format.Alignment.CENTRE);


			//查询版本
			//String excelFile = "statement" + CDict.getVersionByID((Integer)Utility.getSessionValue(Utility.SessionKey_Version)).getExtension() + ".xls";
			//获取路径
			String modelPath = this.getServletConfig().getServletContext().getRealPath("/template/statement.zh-CN.xls");
			//选择模板文件：
			Workbook wb = Workbook.getWorkbook(new File(modelPath));
			WritableWorkbook wwb = Workbook.createWorkbook(response.getOutputStream(), wb);
			WritableSheet wws = wwb.getSheet("对账单");
			int count = ordens.size();
			for(int i=0;i<count;i++){
				wws.insertRow(8);
			}
			
			
			Label cCompanyName = new Label(3,1,member.getName(),wcf2);
			wws.addCell(cCompanyName);
			
			Label cUsername = new Label(3,2,member.getUsername(),wcf2);
			wws.addCell(cUsername);
			
			Label cFromDate = new Label(3,3,Utility.toSafeString(fromDate),wcf2);
			wws.addCell(cFromDate);
			
			Label cToDate = new Label(4,3,Utility.toSafeString(toDate),wcf2);
			wws.addCell(cToDate);
			
			Label cBillDate = new Label(17,2,Utility.dateToStr(new Date(),"yyyy-MM-dd"),wcf2);
			wws.addCell(cBillDate);
			
			Label cBillMember = new Label(17,3,CurrentInfo.getCurrentMember().getName(),wcf2);
			wws.addCell(cBillMember);
			
			Label cMoneySign = new Label(17,4,member.getMoneySignName(),wcf2);
			wws.addCell(cMoneySign);
			
			//总的数量合计
			double zslhj = 0;
			//总cmt价格合计
//			double zcmthj = 0.00;
			//总合计
			double zhj = 0;
			
			for(int i=0;i<count;i++){
				//序号
				jxl.write.Number N1 = new jxl.write.Number(1,8+i,i+1,wcf);
				wws.addCell(N1);

				Orden orden = ordens.get(i);
				Double processPrice = 0.0;
				Double cmtPrice = 0.0;
				Double fabricPrice = 0.0;
				Double fabricOccupy = 0.0;
				Double fabricSinglePrice = 0.0;
				for(OrdenDetail detail:orden.getOrdenDetails()){
					processPrice += Utility.toSafeDouble(detail.getProcessPrice());
					cmtPrice += Utility.toSafeDouble(detail.getCmtPrice());
					fabricPrice += Utility.toSafeDouble(detail.getFabricPrice());
					Dict clothing = DictManager.getDictByID(detail.getSingleClothingID());
					if(clothing!=null){
						fabricOccupy += Utility.toSafeDouble(clothing.getOccupyFabric());
					}
					fabricSinglePrice = fabricPrice/fabricOccupy;
				}
				Double dj = processPrice + fabricPrice + cmtPrice;
				Double hj = dj;
				//出库日期
				Label C1 = new Label(2,8+i,Utility.dateToStr(orden.getDeliveryDate(),"yyyy-MM-dd"),wcf);
				wws.addCell(C1);
				
				//订单号
				Label C2 = new Label(3,8+i,orden.getOrdenID(),wcf);
				wws.addCell(C2);
				
				//产品名
				Label C3 = new Label(4,8+i,orden.getClothingName(),wcf);
				wws.addCell(C3);
				
				//产品ID
				jxl.write.Number C4 = new jxl.write.Number(5,8+i,orden.getClothingID(),wcf);
				wws.addCell(C4);
				
				//面料号
				Label C5 = new Label(6,8+i,orden.getFabricCode(),wcf);
				wws.addCell(C5);
				
				//数量
				zslhj += 1; 
				jxl.write.Number C6 = new jxl.write.Number(7,8+i,1,wcf);
				wws.addCell(C6);
				
				//CMT价格
//				zcmthj +=110;
				jxl.write.Number C7 = new jxl.write.Number(8,8+i,cmtPrice,wnf);
				wws.addCell(C7);

				//面料单价
				jxl.write.Number C8 = new jxl.write.Number(9,8+i,fabricSinglePrice,wnf);
				wws.addCell(C8);
				//面料单耗
				jxl.write.Number C9 = new jxl.write.Number(10,8+i, fabricOccupy ,wnf);
				wws.addCell(C9);
				//款式工艺
				
				jxl.write.Number C10 = new 	jxl.write.Number(11,8+i,processPrice,wnf);
				wws.addCell(C10);
				
				//深层设计
				//jxl.write.Number C11 = new 	jxl.write.Number(12,8+i,11,wnf);
				//wws.addCell(C11);
				
				//更改费
				//jxl.write.Number C12 = new jxl.write.Number(13,8+i, 0 ,wnf);
				Label C12 = new Label(13,8+i,"",wcf);
				wws.addCell(C12);
				
				//加急费
				//jxl.write.Number C13= new jxl.write.Number(14,8+i, 0 ,wnf);
				Label C13 = new Label(14,8+i,"",wcf);
				wws.addCell(C13);

				//其他
				//jxl.write.Number C14= new jxl.write.Number(15,8+i,3,wnf);
				Label C14 = new Label(15,8+i,"",wcf);
				wws.addCell(C14);
				
				//单价
				jxl.write.Number C15= new jxl.write.Number(16,8+i,dj,wnf);
				wws.addCell(C15);
				
				//合计
				jxl.write.Number C16= new jxl.write.Number(17,8+i,hj,wnf);
				wws.addCell(C16);
				
				//备注
				Label C17 = new Label(18,8+i,"",wcf);
				wws.addCell(C17);	
				
				zhj += hj;
			}
			//总的数量合计
			jxl.write.Number zslhjCell = new jxl.write.Number(7,8+count,zslhj,wcf2);
			wws.addCell(zslhjCell);
			//总合计费用
			jxl.write.Number zhjCell = new jxl.write.Number(17,8+count,zhj,wnf2);
			wws.addCell(zhjCell);
			
			//其他费用条目数量
			int qtfyCount = 2;
//			//其他费用
//			for(int i=0;i<qtfyCount;i++){
//				wws.insertRow(8+count+2);
//			}
//			//其他费用合计
//			double ytfyhj = 0;
//			for(int i=0;i<qtfyCount;i++){
//				//序号
//				jxl.write.Number C1= new jxl.write.Number(1,8+count+2+i,i+1,wcf);
//				wws.addCell(C1);
//				//合并居中,3-16列
//				wws.mergeCells(3,8+count+2+i,16,8+count+2+i); 
//				//产生日期
//				//Label C2 = new Label(2,8+count+2+i,Utility.dateToStr(new Date(),"yyyy-MM-dd"),wcf);
//				Label C2 = new Label(2,8+count+2+i,"",wcf);
//				wws.addCell(C2);
//				//项目
//				Label C3 = new Label(3,8+count+2+i,i+1+"",wcf);
//				wws.addCell(C3);
//				//金额
//				ytfyhj += 31.7;
//				//jxl.write.Number C4= new jxl.write.Number(17,8+count+2+i,31.7,wnf);
//				Label C4 = new Label(17,8+count+2+i, "",wcf);
//				wws.addCell(C4);
//				//加个边框
//				Label C5 = new Label(18,8+count+2+i,"",wcf);
//				wws.addCell(C5);
//			}
			//其他费用合计
			//jxl.write.Number qtfyhjCell = new jxl.write.Number(17,8+count+2+qtfyCount,ytfyhj,wnf2);
			//wws.addCell(qtfyhjCell);
			
			//贷方项目
			//到账总计
//			double dzzj = 0;
			//帐户金额总计
//			double zhjezj = 0;
			for(int i=0;i<count+qtfyCount+3;i++){
				//到账日期
				Label C18 = new Label(19,8+i,"",wcf);
				wws.addCell(C18);
				//到账金额
//				dzzj += 1100;
				//jxl.write.Number C19 = new 	jxl.write.Number(20,8+i,1100,wnf);
				Label C19 = new Label(20,8+i,"",wcf);
				wws.addCell(C19);
				//帐户金额
//				zhjezj += 11112;
				//jxl.write.Number C20 = new 	jxl.write.Number(21,8+i,11112,wnf);
				Label C20 = new Label(21,8+i,"",wcf);
				wws.addCell(C20);	
			}
			//jxl.write.Number dzzjCell = new jxl.write.Number(20,8+count+2+qtfyCount+1,dzzj,wnf2);
			Label dzzjCell = new Label(20,8+count+2+qtfyCount+1,"",wcf);
			wws.addCell(dzzjCell);
			//jxl.write.Number zhjezjCell = new jxl.write.Number(21,8+count+2+qtfyCount+1,zhjezj,wnf2);
			Label zhjezjCell = new Label(21,8+count+2+qtfyCount+1,"",wcf);
			wws.addCell(zhjezjCell);
			
			wwb.write();
			wwb.close();
			wb.close();
			return;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}