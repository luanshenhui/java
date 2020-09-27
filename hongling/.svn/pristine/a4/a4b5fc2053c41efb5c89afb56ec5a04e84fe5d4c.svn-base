package hongling.service.assemble;

import hongling.business.AssembleManager;
import hongling.entity.Assemble;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class ListAssemble extends BaseServlet {

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {

		try {
			super.service();
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
				if (-1 == assembleClothing) {
					assembleClothing = null;
				}
				assemble.setClothingID(assembleClothing);
			}

			// 款式风格
			Integer assembleStyel = null;
			if (null != getParameter("searchStyleID")
					&& !"".equals(getParameter("searchStyleID"))) {
				assembleStyel = Utility
						.toSafeInt(getParameter("searchStyleID"));
				if (-1 == assembleStyel) {
					assembleStyel = null;
				}
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

			List<Assemble> assembles = new AssembleManager().getAssemble(
					nPageIndex, CDict.PAGE_SIZE, keyWord, assemble, fromDate,
					toDate);

			String str = "";
			String[] temps = null;
			StringBuffer bufferTemp1 = null;
			StringBuffer bufferTemp2 = null;
			// 处理显示 字段
			for (Assemble temp : assembles) {
				if (null != temp) {
					if (null != temp.getClothingID()
							&& !"".equals(temp.getClothingID())) {
						temp.setClothName(new AssembleManager().getDictByID(
								temp.getClothingID()).getName());
					}
					if (null != temp.getStyleID()
							&& !"".equals(temp.getStyleID())
							&& -1 != temp.getStyleID()) {
						temp.setStyleName(new AssembleManager().getDictByID(
								temp.getStyleID()).getName());
					}
					// 处理显示 推荐面料的换行信息
					str = temp.getFabrics();
					if (str != null && str.length() != 0) {
						temps = str.split(",");
						bufferTemp1 = new StringBuffer("");
						bufferTemp2 = new StringBuffer("");
						for (int i = 0; i < temps.length; i++) {
							if (bufferTemp1.length() > 30) {
								bufferTemp2.append(bufferTemp1).append("<br/>");
								bufferTemp1 = new StringBuffer("");
							}
							bufferTemp1.append(temps[i]).append(",");
						}
						bufferTemp2.append(bufferTemp1);

						temp.setFabrics(bufferTemp2.toString());
					}

				}
			}

			long nCount = new AssembleManager().getAssembleCount(keyWord,
					assemble, fromDate, toDate);
			PagingData pagingData = new PagingData();
			pagingData.setCount(nCount);
			pagingData.setData(assembles);

			output(pagingData);
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetAssemble_err" + e.getMessage());
		}
	}
}
