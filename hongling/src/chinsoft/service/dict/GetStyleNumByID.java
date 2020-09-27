package chinsoft.service.dict;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.CurableStyle;
import chinsoft.service.core.BaseServlet;

public class GetStyleNumByID extends BaseServlet {
	private static final long serialVersionUID = 5434333432826474384L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strID = getParameter("dictID");// 款式号
			int nLastIndex = Utility.toSafeInt(getParameter("lastIndex"));// 行数
			int clothingID = Utility.toSafeInt(getParameter("clothingID"));// 服装大类
			String strDictHtml = "";
			List<CurableStyle> CurableStyles = DictManager
					.getStyleNumByID2(strID);
			if (CurableStyles.size() > 0) {
				strDictHtml = DictManager.getStyleNumHtml(CurableStyles,
						nLastIndex, clothingID);
			}
			output(strDictHtml);
		} catch (Exception e) {
			//e.printStackTrace();
			LogPrinter.debug(e.getMessage());
		}
	}
}
