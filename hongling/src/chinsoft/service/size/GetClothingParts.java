package chinsoft.service.size;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.SizeManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.SizeStandard;
import chinsoft.service.core.BaseServlet;

public class GetClothingParts extends BaseServlet{
	private static final long serialVersionUID = 6444512880903492284L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nSingleClothingID=Utility.toSafeInt(getParameter("singleclothingid"));
			int nSizeCategoryID=Utility.toSafeInt(getParameter("sizecategoryid"));
			int nAreaID=Utility.toSafeInt(getParameter("areaid"));
			String strSpecHeight=getParameter("specheight");
			String strSpecChest=getParameter("specchest");
			int nUnitID = Utility.toSafeInt(getParameter("unitid"));
			if(nSingleClothingID == -1){
				nSingleClothingID = Utility.toSafeInt(getTempClothingID());
			}
			
			List<SizeStandard> sizeStandards = new SizeManager().getSizeStandard(nSingleClothingID, nSizeCategoryID, nAreaID, strSpecHeight,strSpecChest, nUnitID);
			
			//根据工艺筛选尺寸
			List<SizeStandard> validSizeStandards = new SizeManager().getValidSizeStandard(sizeStandards, this.getTempComponentIDs());
			output(validSizeStandards);
		}catch (Exception e){
			LogPrinter.debug("GetClothingParts_err"+e.getMessage());
		}
	}
	
}