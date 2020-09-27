package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class GetTempComponentText extends BaseServlet {

	private static final long serialVersionUID = -1750095872257443214L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
	{		
		try {
			super.service();
			String strID = getParameter("id");
			String strValue = getComponentTextByID(strID);
			output(strValue);
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
	
	private String getComponentTextByID(String strID) {
		String strTexts = this.getTempComponentTexts();
		String strValue ="";
		String[] texts = Utility.getStrArray(strTexts);
		for(String text :texts){
			String[] label_value = text.split(":");
			if(label_value.length > 1 && label_value[0].equals(strID)){
				strValue = label_value[1];
			}
		}
		return strValue;
	}
}

