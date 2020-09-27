package chinsoft.service.size;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.SizeManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.SizeStandard;
import chinsoft.service.core.BaseServlet;

public class GetClothingPartsByGroup extends BaseServlet{
	private static final long serialVersionUID = 6444512880903492284L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();
			int nSizeStandardID=Utility.toSafeInt(getParameter("sizestandardid"));
			int nUnitID = Utility.toSafeInt(getParameter("unitid"));
			
			List<SizeStandard> sizeStandards = new SizeManager().getSizeStandardByGroup(nSizeStandardID, nUnitID);
			output(sizeStandards);
		}catch (Exception e){
			LogPrinter.debug("GetClothingPartsByGroup_err"+e.getMessage());
		}
	}
}