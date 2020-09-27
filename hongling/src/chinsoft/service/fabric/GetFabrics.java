package chinsoft.service.fabric;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.business.FabricManager;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.PagingData;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Fabric;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class GetFabrics extends BaseServlet {

	private static final long serialVersionUID = -6535997613729365562L;

	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			super.service();
			// 获取登陆用户的经营单位
			Member loginUser = CurrentInfo.getCurrentMember();
			Integer areaID =  loginUser.getBusinessUnit();
			//总管理用户 和财务管理用户 可以查看全部
			if(loginUser.getGroupID() == 10258 ||loginUser.getGroupID() == 10257 ){
				areaID = null;
			}

			int nPageIndex = Utility.toSafeInt(getParameter("pageindex"));
			String strKeyword = getParameter("keyword");
			int nCategoryID = Utility.toSafeInt(getParameter("categoryid"));
			Integer nSupplyCategoryID = Utility.toSafeInt(getParameter("supplycategoryid"));
			
			HttpContext.setSessionValue("priceType",loginUser.getPriceType());

			List<Fabric> data = null;
			long nCount = 0;
			if (CDict.FabricSupplyCategoryClientPiece.getID().equals(
					nSupplyCategoryID)) {
				// 客供单块料
				String strArriveDate = getParameter("arrivedate");
				String strArrivedateEnd = getParameter("arrivedateEnd");
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
				Object result = new FabricManager().getClientPieceFabric(
						Utility.toSafeString(nPageIndex),
						Utility.toSafeString(CDict.PAGE_SIZE), strKeyword,
						strIsValid, strCategoryID, strArriveDate,
						strArrivedateEnd);
				response.setContentType("text/html;charset=utf-8");
				response.getWriter().print(result);
			} else {
				String strFabricPre = "";
				if (CDict.FabricSupplyCategoryClientBatch.getID().equals(
						nSupplyCategoryID)) {
					strFabricPre = CurrentInfo.getCurrentMember()
							.getFabricPre();
					if ("".equals(strFabricPre)) {
						strFabricPre = "KLSKLLNMKSMCV";
					}
				}
				data = new FabricManager().getFabrics(nPageIndex,
						CDict.PAGE_SIZE, strFabricPre, strKeyword, nCategoryID,
						nSupplyCategoryID, areaID);
				nCount = new FabricManager().getFabricsCount(strFabricPre,
						strKeyword, nCategoryID, nSupplyCategoryID,
						areaID);
				PagingData pagingData = new PagingData();
				pagingData.setCount(nCount);
				pagingData.setData(data);
				output(pagingData);
			}
		} catch (Exception e) {
			LogPrinter.debug("getfabrics_err" + e.getMessage());
		}
	}
}
