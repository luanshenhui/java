package rcmtm.member;

import java.util.Date;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import rcmtm.business.ConfigSR;
import chinsoft.business.CompanysManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.core.DEncrypt;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Companys;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;


public class MemberBinding extends BaseServlet {
	private static final long serialVersionUID = 7391945794655884485L;
	
	public void service(HttpServletRequest request,HttpServletResponse response) {
		
		String strUsername = getParameter("username");
		String strPassword = getParameter("password");
		String strResult =Utility.RESULT_VALUE_OK;
		String strMyPlatformUrl = "";
		Member member = new MemberManager().getMemberByUsername(strUsername);
		if (member == null) {
			strResult = ResourceHelper.getValue("Common_UserNotExist");
		}else{
			if (!member.getPassword().equals(DEncrypt.md5(strPassword))) {
				strResult = ResourceHelper.getValue("Member_PasswordNotMatch");
			}
		}
		if(Utility.RESULT_VALUE_OK.equals(strResult)){
			String strUserID = "";
			Cookie[]cookies= request.getCookies();
			for (Cookie cookie : cookies) {
				if (cookie.getName().equals("SessionKey_srUserID")) {
					strUserID=cookie.getValue();
				}
			}
			System.out.println(new Date()+"绑定时获得的session值SessionKey_srUserID："+strUserID);
			request.getSession().setAttribute("SessionKey_hlUserID", strUsername);
			
			if(!"".equals(strUserID)){
				if(member.getCompanyID() == null){
					String code = (String) request.getSession().getAttribute("SessionKey_Cpcode");
					member.setCompanyID(Utility.toSafeInt(code));//善融企业编号
					member.setSrUserID(strUserID);//善融账号
					member.setClientIP(request.getRemoteAddr());
					member.setLastLoginDate(new Date());
					new MemberManager().saveMember(member);
					member.setUserStatus(10050);//已登录
					CurrentInfo.setCurrentMember(member);
					
					//企业代码RC000003
					CompanysManager companysManager=new CompanysManager();
					Companys company=companysManager.getCompanyByCode("RC000003");
					request.getSession().setAttribute("company", company);
					
					strMyPlatformUrl = "../common/orden.jsp";//专业版
					if(member.getHomePage() == 20118){//时尚版
						strMyPlatformUrl = "../fix/fix.jsp";
					}else if(member.getHomePage() == 20118){//快速下单
						strMyPlatformUrl = "../common/orden_page.jsp";
					}
				}else{
					strResult = member.getUsername()+"用户已绑定！";
				}
			}
		}
		strResult = strResult+":"+strMyPlatformUrl;
		output(strResult);
	}
}
