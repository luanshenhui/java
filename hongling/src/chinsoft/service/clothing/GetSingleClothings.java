package chinsoft.service.clothing;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ClothingManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetSingleClothings extends BaseServlet {
	private static final long serialVersionUID = -1759095870257433218L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			int nClothingID1 = Utility.toSafeInt(getTempClothingID());
			int nClothingID2 = Utility.toSafeInt( getParameter("clothingID"));
			int nClothingID = 1;
			if(-1!=nClothingID2){
				nClothingID = nClothingID2;
			}else{
				nClothingID = nClothingID1;
			}
			List<Dict> singleClothings = new ClothingManager().getSingleClothings(nClothingID);
			
			output(singleClothings);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}