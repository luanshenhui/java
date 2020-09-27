package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.DictManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetLapelWidthID extends BaseServlet {

	private static final long serialVersionUID = -1750095872257443294L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			String[] strComponentIDs = this.getTempComponentIDs().split(",");
			String strFrontButtonId = "";
			String strLapelStyleId = "";
			String strLapelWidthId = "";
			String id = getParameter("id");
			for(int i=0;i<strComponentIDs.length;i++){
				Dict dict =DictManager.getDictByID(Utility.toSafeInt(strComponentIDs[i]));
				if(CDict.FRONTBUTTON.equals(Utility.toSafeString(dict.getParentID()))){//前面扣
					strFrontButtonId = strComponentIDs[i];
				}
				if(CDict.LAPELS.equals(Utility.toSafeString(dict.getParentID()))){//驳头型
					strLapelStyleId = strComponentIDs[i];
				}
			}
			if(!"".equals(id)){//选择前门扣
				strFrontButtonId = id;
			}
			strLapelWidthId = new DictManager().getLapelWidthId(strFrontButtonId,strLapelStyleId);
			this.setTempParameterID(Utility.toSafeInt(strLapelWidthId));
			output(strLapelWidthId);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}

