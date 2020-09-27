package chinsoft.service.fabric;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.business.ExcelHelper;
import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Fabric;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class ExportFabrics extends BaseServlet {

	private static final long serialVersionUID = 3941900142054890884L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			Member loginUser = CurrentInfo.getCurrentMember();
			loginUser.getBusinessUnit();
			String strKeyword = getParameter("keyword");
			int nCategoryID = Utility.toSafeInt(getParameter("categoryid"));
			Integer nSupplyCategoryID = Utility
					.toSafeInt(getParameter("supplycategoryid"));
			// 表头
			ArrayList<String> header = new ArrayList<String>();
			// 要写入的数据
			List<List<String>> rows = new ArrayList<List<String>>();
			// 测试数据
			// String str =
			// "{\"count\":17590,\"data\":[{\"auditby\":null,\"audittime\":null,\"clflid\":1,\"closeby\":null,\"closestatus\":\"0\",\"closetime\":null,\"createby\":\"模型管理员\",\"createtime\":\"2011-05-14 10:14:23.0\",\"dhrq\":null,\"ecode\":\"MAH050A\",\"ename\":\"A类西服面料\",\"estatus\":\"1\",\"hgf\":\"1\",\"hxsl\":1.0,\"lockby\":null,\"lockstatus\":\"0\",\"locktime\":null,\"mdcd\":null,\"mlb\":null,\"mlcd\":100.0,\"mldnid\":1,\"mlfk\":1.56,\"mlll\":null,\"mlsl\":null,\"mltgkd\":0.9,\"mltn\":null,\"mlwg\":\"条纹\",\"mlzt\":null,\"modifyby\":\"程雪艳\",\"modifytime\":\"2011-08-30 10:17:26.0\",\"sfsy\":\"0\",\"sfxyrccj\":\"0\",\"tranmemo\":null,\"xstatus\":\"0\",\"ydh\":null,\"ysddh\":null,\"zxsl\":1.0},{\"auditby\":\"系统管理员\",\"audittime\":\"2011-05-21 17:15:24.0\",\"clflid\":1,\"closeby\":null,\"closestatus\":\"0\",\"closetime\":null,\"createby\":\"系统管理员\",\"createtime\":\"2011-05-14 10:14:23.0\",\"dhrq\":null,\"ecode\":\"MAC013A\",\"ename\":\"A类西服面料\",\"estatus\":\"7\",\"hgf\":\"1\",\"hxsl\":null,\"lockby\":null,\"lockstatus\":\"0\",\"locktime\":null,\"mdcd\":null,\"mlb\":null,\"mlcd\":null,\"mldnid\":2,\"mlfk\":1.5,\"mlll\":null,\"mlsl\":null,\"mltgkd\":0.2,\"mltn\":null,\"mlwg\":\"条纹\",\"mlzt\":null,\"modifyby\":\"系统管理员\",\"modifytime\":\"2011-05-21 15:21:59.0\",\"sfsy\":\"0\",\"sfxyrccj\":\"0\",\"tranmemo\":null,\"xstatus\":\"0\",\"ydh\":null,\"ysddh\":null,\"zxsl\":null},{\"auditby\":null,\"audittime\":null,\"clflid\":1,\"closeby\":null,\"closestatus\":\"0\",\"closetime\":null,\"createby\":\"系统管理员\",\"createtime\":\"2011-05-14 10:14:23.0\",\"dhrq\":null,\"ecode\":\"MAD042A\",\"ename\":\"A类西服面料\",\"estatus\":\"1\",\"hgf\":\"1\",\"hxsl\":1.0,\"lockby\":null,\"lockstatus\":\"0\",\"locktime\":null,\"mdcd\":null,\"mlb\":null,\"mlcd\":null,\"mldnid\":3,\"mlfk\":1.55,\"mlll\":null,\"mlsl\":null,\"mltgkd\":1.1,\"mltn\":null,\"mlwg\":\"条纹\",\"mlzt\":null,\"modifyby\":\"程雪艳\",\"modifytime\":\"2011-08-30 09:49:22.0\",\"sfsy\":\"0\",\"sfxyrccj\":\"0\",\"tranmemo\":null,\"xstatus\":\"0\",\"ydh\":null,\"ysddh\":null,\"zxsl\":1.0},{\"auditby\":null,\"audittime\":null,\"clflid\":1,\"closeby\":null,\"closestatus\":\"0\",\"closetime\":null,\"createby\":\"系统管理员\",\"createtime\":\"2011-05-14 10:14:23.0\",\"dhrq\":null,\"ecode\":\"MAE057A\",\"ename\":\"A类西服面料\",\"estatus\":\"1\",\"hgf\":\"1\",\"hxsl\":1.0,\"lockby\":null,\"lockstatus\":\"0\",\"locktime\":null,\"mdcd\":null,\"mlb\":null,\"mlcd\":null,\"mldnid\":4,\"mlfk\":1.55,\"mlll\":null,\"mlsl\":null,\"mltgkd\":1.0,\"mltn\":null,\"mlwg\":\"条纹\",\"mlzt\":null,\"modifyby\":\"程雪艳\",\"modifytime\":\"2011-08-30 09:50:35.0\",\"sfsy\":\"0\",\"sfxyrccj\":\"0\",\"tranmemo\":null,\"xstatus\":\"0\",\"ydh\":null,\"ysddh\":null,\"zxsl\":1.0},{\"auditby\":null,\"audittime\":null,\"clflid\":1,\"closeby\":null,\"closestatus\":\"0\",\"closetime\":null,\"createby\":\"系统管理员\",\"createtime\":\"2011-05-14 10:14:23.0\",\"dhrq\":null,\"ecode\":\"MAE058A\",\"ename\":\"A类西服面料\",\"estatus\":\"1\",\"hgf\":\"1\",\"hxsl\":1.0,\"lockby\":null,\"lockstatus\":\"0\",\"locktime\":null,\"mdcd\":null,\"mlb\":null,\"mlcd\":null,\"mldnid\":5,\"mlfk\":1.56,\"mlll\":null,\"mlsl\":null,\"mltgkd\":1.0,\"mltn\":null,\"mlwg\":\"条纹\",\"mlzt\":null,\"modifyby\":\"程雪艳\",\"modifytime\":\"2011-08-30 09:51:00.0\",\"sfsy\":\"0\",\"sfxyrccj\":\"0\",\"tranmemo\":null,\"xstatus\":\"0\",\"ydh\":null,\"ysddh\":null,\"zxsl\":1.0},{\"auditby\":null,\"audittime\":null,\"clflid\":1,\"closeby\":null,\"closestatus\":\"0\",\"closetime\":null,\"createby\":\"系统管理员\",\"createtime\":\"2011-05-14 10:14:23.0\",\"dhrq\":null,\"ecode\":\"MAE059A\",\"ename\":\"A类西服面料\",\"estatus\":\"1\",\"hgf\":\"1\",\"hxsl\":1.0,\"lockby\":null,\"lockstatus\":\"0\",\"locktime\":null,\"mdcd\":null,\"mlb\":null,\"mlcd\":null,\"mldnid\":6,\"mlfk\":1.55,\"mlll\":null,\"mlsl\":null,\"mltgkd\":0.2,\"mltn\":null,\"mlwg\":\"条纹\",\"mlzt\":null,\"modifyby\":\"程雪艳\",\"modifytime\":\"2011-08-30 09:51:29.0\",\"sfsy\":\"0\",\"sfxyrccj\":\"0\",\"tranmemo\":null,\"xstatus\":\"0\",\"ydh\":null,\"ysddh\":null,\"zxsl\":1.0},{\"auditby\":null,\"audittime\":null,\"clflid\":1,\"closeby\":null,\"closestatus\":\"0\",\"closetime\":null,\"createby\":\"系统管理员\",\"createtime\":\"2011-05-14 10:14:23.0\",\"dhrq\":null,\"ecode\":\"MAE061A\",\"ename\":\"A类西服面料\",\"estatus\":\"1\",\"hgf\":\"1\",\"hxsl\":1.0,\"lockby\":null,\"lockstatus\":\"0\",\"locktime\":null,\"mdcd\":null,\"mlb\":null,\"mlcd\":null,\"mldnid\":7,\"mlfk\":1.54,\"mlll\":null,\"mlsl\":null,\"mltgkd\":1.6,\"mltn\":null,\"mlwg\":\"条纹\",\"mlzt\":null,\"modifyby\":\"程雪艳\",\"modifytime\":\"2011-08-30 09:56:43.0\",\"sfsy\":\"0\",\"sfxyrccj\":\"0\",\"tranmemo\":\"1\",\"xstatus\":\"0\",\"ydh\":null,\"ysddh\":null,\"zxsl\":1.0},{\"auditby\":null,\"audittime\":null,\"clflid\":1,\"closeby\":null,\"closestatus\":\"0\",\"closetime\":null,\"createby\":\"系统管理员\",\"createtime\":\"2011-05-14 10:14:23.0\",\"dhrq\":null,\"ecode\":\"MAE062A\",\"ename\":\"A类西服面料\",\"estatus\":\"1\",\"hgf\":\"1\",\"hxsl\":1.0,\"lockby\":null,\"lockstatus\":\"0\",\"locktime\":null,\"mdcd\":null,\"mlb\":null,\"mlcd\":null,\"mldnid\":8,\"mlfk\":1.55,\"mlll\":null,\"mlsl\":null,\"mltgkd\":1.5,\"mltn\":null,\"mlwg\":\"条纹\",\"mlzt\":null,\"modifyby\":\"程雪艳\",\"modifytime\":\"2011-08-30 09:57:13.0\",\"sfsy\":\"0\",\"sfxyrccj\":\"0\",\"tranmemo\":null,\"xstatus\":\"0\",\"ydh\":null,\"ysddh\":null,\"zxsl\":1.0},{\"auditby\":null,\"audittime\":null,\"clflid\":1,\"closeby\":null,\"closestatus\":\"0\",\"closetime\":null,\"createby\":\"系统管理员\",\"createtime\":\"2011-05-14 10:14:23.0\",\"dhrq\":null,\"ecode\":\"MAE063A\",\"ename\":\"A类西服面料\",\"estatus\":\"1\",\"hgf\":\"1\",\"hxsl\":1.0,\"lockby\":null,\"lockstatus\":\"0\",\"locktime\":null,\"mdcd\":null,\"mlb\":null,\"mlcd\":null,\"mldnid\":9,\"mlfk\":1.56,\"mlll\":null,\"mlsl\":null,\"mltgkd\":1.0,\"mltn\":null,\"mlwg\":\"条纹\",\"mlzt\":null,\"modifyby\":\"程雪艳\",\"modifytime\":\"2011-08-30 09:58:00.0\",\"sfsy\":\"0\",\"sfxyrccj\":\"0\",\"tranmemo\":null,\"xstatus\":\"0\",\"ydh\":null,\"ysddh\":null,\"zxsl\":1.0},{\"auditby\":null,\"audittime\":null,\"clflid\":2,\"closeby\":null,\"closestatus\":\"0\",\"closetime\":null,\"createby\":\"系统管理员\",\"createtime\":\"2011-05-21 15:28:53.0\",\"dhrq\":null,\"ecode\":\"FLL2006-35\",\"ename\":\"涤粘粗斜纹\",\"estatus\":\"1\",\"hgf\":\"1\",\"hxsl\":null,\"lockby\":null,\"lockstatus\":\"0\",\"locktime\":null,\"mdcd\":null,\"mlb\":null,\"mlcd\":null,\"mldnid\":10,\"mlfk\":1.4,\"mlll\":null,\"mlsl\":null,\"mltgkd\":null,\"mltn\":null,\"mlwg\":\"斜纹\",\"mlzt\":null,\"modifyby\":\"程雪艳\",\"modifytime\":\"2011-06-20 08:41:48.0\",\"sfsy\":\"0\",\"sfxyrccj\":\"0\",\"tranmemo\":null,\"xstatus\":\"0\",\"ydh\":null,\"ysddh\":null,\"zxsl\":null}]}";

			if (CDict.FabricSupplyCategoryClientPiece.getID().equals(
					nSupplyCategoryID)) {
				// 客供单块料
				String strArriveDate = getParameter("arrivedate");
				String strArriveDateEnd = getParameter("arrivedateEnd");
				String strIsValid = getParameter("isvalid");
				if ("-1".equals(strIsValid)) {
					strIsValid = "";
				}
				String strCategoryID = "";
				if (nCategoryID > 0) {
					Dict category = DictManager.getDictByID(nCategoryID);
					if (category != null) {
						strCategoryID = category.getEcode();
					}
				}
				Object fabrics = new FabricManager().getClientPieceFabric("0",
						"100000000", strKeyword, strIsValid, strCategoryID,
						strArriveDate, strArriveDateEnd);
				rows = new FabricManager().getFabricCellList(fabrics);
				header.add(ResourceHelper.getValue("Common_Index"));

				// 面料类别
				header.add(ResourceHelper.getValue("Fabric_ename"));
				// 订单号
				header.add(ResourceHelper.getValue("Fabric_ysddh"));
				// 面料号
				header.add(ResourceHelper.getValue("Fabric_ecode"));
				// 面料属性
				header.add(ResourceHelper.getValue("Fabric_mlwg"));
				// 码单长度
				header.add(ResourceHelper.getValue("Fabric_mdcd"));
				// 面料长度
				header.add(ResourceHelper.getValue("Fabric_mlcd"));
				// 面料幅宽
				header.add(ResourceHelper.getValue("Fabric_mlfk"));
				// 合格否
				header.add(ResourceHelper.getValue("Fabric_hgf"));
				// 到料时间
				header.add(ResourceHelper.getValue("Fabric_dhrq"));

			} else {
				List<Fabric> fabrics = new ArrayList<Fabric>();
				String strFabricPre = "";
				if (CDict.FabricSupplyCategoryClientBatch.getID().equals(
						nSupplyCategoryID)) {
					strFabricPre = CurrentInfo.getCurrentMember()
							.getFabricPre();
					if ("".equals(strFabricPre)) {
						strFabricPre = "KLSKLLNMKSMCV";
					}
				}
				fabrics = new FabricManager().getFabrics(0, 1000000,
						strFabricPre, strKeyword, nCategoryID,
						nSupplyCategoryID, loginUser.getBusinessUnit());
				// 表头
				header.add(ResourceHelper.getValue("Common_Index"));
				header.add(ResourceHelper.getValue("Fabric_Code"));
				header.add(ResourceHelper.getValue("Common_Category"));
				header.add(ResourceHelper.getValue("Common_Price"));
				header.add(ResourceHelper.getValue("Fabric_Weight"));
				header.add(ResourceHelper.getValue("Fabric_Series"));
				header.add(ResourceHelper.getValue("Fabric_Flower"));
				header.add(ResourceHelper.getValue("Fabric_Color"));
				header.add(ResourceHelper.getValue("Fabric_Composition"));
				header.add(ResourceHelper.getValue("Fabric_Inventory"));
				int i = 0;
				for (Fabric fabric : fabrics) {
					i++;
					List<String> row = new ArrayList<String>();
					row.add(i + "");
					row.add(fabric.getCode());
					row.add(fabric.getCategoryName());
					Member member = CurrentInfo.getCurrentMember();
					if (CurrentInfo.isAdmin()) {
						row.add(Utility.toSafeString(fabric.getPrice() + "("
								+ CDict.MoneySignRmb.getEn() + ")"
								+ fabric.getDollarPrice() + "("
								+ CDict.MoneySignDollar.getEn() + ")"));
					} else {
						if (member.getMoneySignID() == CDict.MoneySignRmb
								.getID()) {
							row.add(Utility.toSafeString(fabric.getPrice()
									+ "(" + CDict.MoneySignRmb.getEn() + ")"));
						}
						if (member.getMoneySignID() == CDict.MoneySignDollar
								.getID()) {
							row.add(Utility.toSafeString(fabric
									.getDollarPrice()
									+ "("
									+ CDict.MoneySignDollar.getEn() + ")"));
						}
					}
					row.add(Utility.toSafeString(fabric.getWeight()));
					row.add(Utility.toSafeString(fabric.getSeriesName()));
					row.add(Utility.toSafeString(fabric.getFlowerName()));
					row.add(Utility.toSafeString(fabric.getColorName()));
					row.add(Utility.toSafeString(fabric.getCompositionName()));
					row.add(Utility.toSafeString(fabric.getInventory()));
					rows.add(row);
				}
			}
			// 设置导出文件名
			String fileName = "FabricList-"
					+ Utility.dateToStr(new Date(), "yyyy-MM-dd") + ".xls";
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
			ExcelHelper.exportExcel(header, rows,
					Workbook.createWorkbook(response.getOutputStream()),
					ResourceHelper.getValue("Fabric_Info"));
			return;
		} catch (Exception e) {
			LogPrinter.error("ExportFabrics_" + e.getMessage());
			e.printStackTrace();
		}
	}

}
