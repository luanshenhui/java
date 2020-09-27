package hongling.service.assemble;

import hongling.business.AssembleManager;
import hongling.entity.Assemble;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import chinsoft.business.ExcelHelper;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class ExportAssemble extends BaseServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			String strFormData = getParameter("formData");
			Map<String, Object> maps = EntityHelper.jsonToMap(strFormData);

			Assemble assemble = new Assemble();
			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));

			// 关键字
			String keyWord = null;
			if (null != getParameter("searchKeywords")
					&& !"".equals(getParameter("searchKeywords"))) {
				keyWord = getParameter("searchKeywords");
			}

			// 代码
			String assembleCode = null;
			if (null != getParameter("searchCode")
					&& !"".equals(getParameter("searchCode"))) {
				assembleCode = getParameter("searchCode");
				assemble.setCode(assembleCode);
			}

			// 服装分类
			Integer assembleClothing = null;
			if (null != getParameter("searchClothingID")
					&& !"".equals(getParameter("searchClothingID"))) {
				assembleClothing = Utility
						.toSafeInt(getParameter("searchClothingID"));
				assemble.setClothingID(assembleClothing);
			}

			// 款式风格
			Integer assembleStyel = null;
			if (null != getParameter("assembleCode")
					&& !"".equals(getParameter("assembleCode"))) {
				assembleStyel = Utility.toSafeInt(getParameter("assembleCode"));
				assemble.setStyleID(assembleStyel);
			}

			// 添加日期
			String fromDate = null;
			if (getParameter("fromDate") != null
					&& !"".equals(getParameter("fromDate"))) {
				fromDate = Utility.toSafeString(getParameter("fromDate"));
			}
			// 添加日期
			String toDate = null;
			if (getParameter("toDate") != null
					&& !"".equals(getParameter("toDate"))) {
				toDate = Utility.toSafeString(getParameter("toDate"));
			}

			List<Assemble> assembles = new AssembleManager().getAssemble(0,
					1000000, keyWord, assemble, fromDate, toDate);
			// 处理显示 字段
			for (Assemble temp : assembles) {
				if (null != temp) {
					if (null != temp.getClothingID()
							&& !"".equals(temp.getClothingID())) {
						temp.setClothName(new AssembleManager().getDictByID(
								temp.getClothingID()).getName());
					}
					if (null != temp.getStyleID()
							&& !"".equals(temp.getStyleID())) {
						temp.setStyleName(new AssembleManager().getDictByID(
								temp.getStyleID()).getName());
					}
					// 把 工艺的ID 字符 串变成 描述的字符串
					temp.setProcess(new AssembleManager().getProcessStr(temp
							.getProcess()));
					// 把 特殊工艺的信息 字符 串变成 适用的字符串
					temp.setSpecialProcess(new AssembleManager()
							.getSpecialProc(temp));
				}
			}

			// 表头
			ArrayList<String> headList = new ArrayList<String>();
			headList.add("序号");
			headList.add("代码");
			headList.add("服装分类");
			headList.add("款式风格");

			headList.add("款式工艺");
			headList.add("特殊工艺");

			headList.add("类似品牌 ");
			headList.add("默认面料");
			headList.add("适用面料");
			headList.add("中文标题");
			headList.add("英文标题");
			// 要写入的数据
			List<List<String>> cells = new ArrayList<List<String>>();
			int i = 0;
			for (Assemble temp : assembles) {
				i++;
				List<String> assembleStr = new ArrayList<String>();
				assembleStr.add(i + "");
				assembleStr.add(temp.getCode());
				if (null != temp.getClothName()
						&& !"".equals(temp.getClothName())) {

					assembleStr.add(temp.getClothName());
				} else {
					assembleStr.add("");
				}
				if (null != temp.getStyleName()
						&& !"".equals(temp.getStyleName())) {

					assembleStr.add(temp.getStyleName());
				} else {
					assembleStr.add("");
				}
				assembleStr.add(temp.getProcess());
				assembleStr.add(temp.getSpecialProcess());

				assembleStr.add(temp.getBrands());
				assembleStr.add(temp.getDefaultFabric());
				assembleStr.add(temp.getFabrics());
				assembleStr.add(temp.getTitleCn());
				assembleStr.add(temp.getTitleEn());
				cells.add(assembleStr);
			}

			// 设置导出文件名
			String fileName = "assembleList-"
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
			LogPrinter.error("ExportAssembles_" + e.getMessage());
			e.printStackTrace();
		}

	}
}
