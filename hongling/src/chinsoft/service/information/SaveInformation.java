package chinsoft.service.information;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.InformationManager;
import chinsoft.core.CVersion;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Information;
import chinsoft.service.core.BaseServlet;

public class SaveInformation extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015723L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			
			String strFormData = getParameter("formData");
			String strInformationID = EntityHelper.getValueByParamID(strFormData);
			Information information = null;
			if(!strInformationID.equals("")){
				information = new InformationManager().getInformationByID(strInformationID);
			}
			
			if(information == null){
				information = new Information();
				information.setPubMemberID(CurrentInfo.getCurrentMember().getID());
				information.setPubDate(new Date());
				information.setVersionID(CVersion.getCurrentVersionID());
			}
			
			information = (Information) EntityHelper.updateEntityFromFormData(information, strFormData);
			
			new InformationManager().saveInformation(information);
			output(Utility.RESULT_VALUE_OK);
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}