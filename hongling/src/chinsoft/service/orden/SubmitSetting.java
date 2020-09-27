package chinsoft.service.orden;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class SubmitSetting extends BaseServlet {

	private static final long serialVersionUID = -3752715900655015724L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			String strFormData = getParameter("formData");
			
			Member member = CurrentInfo.getCurrentMember();
			if(member != null){
				member = (Member)EntityHelper.updateEntityFromFormData(member, strFormData);
				new MemberManager().saveMember(member);
				output(Utility.RESULT_VALUE_OK);
			}
			
		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}