package hongling.service.kitStyle;

import hongling.business.KitStyleManager;
import hongling.entity.KitStyle;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Orden;
import chinsoft.service.core.BaseServlet;

public class GetKitStyles extends BaseServlet{
	private static final long serialVersionUID = -6898384861459365043L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			//{'searchKeyword':'','searchCode':'','searchCategory':'','searchClothing':'0','fromDate':'2013-7-21','toDate':'2013-08-21','pageindex':'0'}
			String param=getParameter("formData");
			int pageNo = Utility.toSafeInt(getParameter("pageindex"));
			String code = getParameter("searchCode");
			String keyword=getParameter("searchKeyword");
			int clothingId=Utility.toSafeInt(getParameter("searchClothing"));
			String category=getParameter("searchCatey");
			String strStyleID=getParameter("styleID");
			
			Date fromDate = null;
			if (getParameter("fromDate") != null && !"".equals(getParameter("fromDate"))) {
				fromDate = Utility.toSafeDateTime(getParameter("fromDate"));
			}
			Date toDate = null;
			if (getParameter("toDate") != null && !"".equals(getParameter("toDate"))) {
				toDate = Utility.toSafeDateTime(getParameter("toDate"));
			}
			
			
			
			List<KitStyle> kitStyles = new KitStyleManager().getKitStyles(pageNo, CDict.PAGE_SIZE, keyword, code, clothingId, category,fromDate,toDate,strStyleID);
			for(KitStyle kitStyle : kitStyles){
				//款式风格
				String styleName = DictManager.getDictNameByID(kitStyle.getStyleID());
				kitStyle.setStyleName(styleName);
			}
			long count = new KitStyleManager().getKitStylesCount(keyword, code, clothingId, category,fromDate,toDate,strStyleID);
			PagingData pagingData = new PagingData();
			pagingData.setCount(count);
			pagingData.setData(kitStyles);
			output(pagingData);
		} catch (Exception e) {
			LogPrinter.debug("GetKitStyleDaos_err"+e.getMessage());
		}
		
	}
}
