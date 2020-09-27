package chinsoft.service.member;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.core.DEncrypt;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;
public class ChangePassward extends BaseServlet{
	private static final long serialVersionUID = 6096767093374877215L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		try {
			super.service();

			String strPassward = getParameter("password");
			String strNewPassward = getParameter("newPassword");
			String strVerfyNewPassward = getParameter("verfyNewPassword");
			if(!strNewPassward.equals(strVerfyNewPassward)){
				output("两次输入密码不一致！");
				return;
			}
			Member member=CurrentInfo.getCurrentMember();
			if(DEncrypt.md5(strPassward).equals(member.getPassword())){
				member.setPassword(DEncrypt.md5(strNewPassward));
				new MemberManager().saveMember(member);
				CurrentInfo.setCurrentMember(member);
				output(Utility.RESULT_VALUE_OK);
			}else{
				output("原密码错误,请输入正确密码！");
			}
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}
}
