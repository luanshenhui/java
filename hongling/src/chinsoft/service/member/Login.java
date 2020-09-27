package chinsoft.service.member;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.code.kaptcha.Constants;

import chinsoft.business.CDict;
import chinsoft.business.CashManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.business.MessageManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Cash;
import chinsoft.entity.Member;
import chinsoft.entity.Message;
import chinsoft.service.core.BaseServlet;

public class Login extends BaseServlet {
	private static final long serialVersionUID = -4065118422243404238L;
	@Override
	public void service(HttpServletRequest request,HttpServletResponse response) {
		try {

			String strUsername = getParameter("username");
			String strPassword = getParameter("password");
			String strCaptcha = getParameter("captcha");
			String CaptchaImage=(String) request.getSession().getAttribute(Constants.KAPTCHA_SESSION_KEY);
			
			if(!strCaptcha.toLowerCase().equals(CaptchaImage.toLowerCase())){output(ResourceHelper.getValue("Common_Captchar"));return;}
			String strResult =new MemberManager().login(strUsername, strPassword);
			if (strResult == Utility.RESULT_VALUE_OK) {
				request.getSession().removeAttribute("company");
				Member member = new MemberManager().getMemberByUsername(strUsername);
				member.setClientIP(request.getRemoteAddr());
				member.setLastLoginDate(new Date());
				new MemberManager().saveMember(member);
				CurrentInfo.setCurrentMember(member);
				
				// 判断是否是前台用户
				if (!CurrentInfo.isAdmin()) {
					// 判断用户金额是否已经小于提醒金额，如果小于提醒金额，在消息表中插入记录
					// 查询用户金额
					Cash cash = new CashManager().getCashByMemberID(member.getID());
					
					if (cash != null) {
						// 用户金额
						double currentNum = 0;
						
						// 用户提醒金额
						double noticeNum = 0;
						
						if (null != cash.getNum() && !"".equals(cash.getNum())) {
							currentNum = cash.getNum();
						}
						
						if (null != cash.getNoticeNum() && !"".equals(cash.getNoticeNum())) {
							noticeNum = cash.getNoticeNum();
						}
						
						// 判断是否需要插入提示信息
						// 如果金额已经小于提示金额
						if (currentNum < noticeNum) {
							Message message = new Message();
							message.setTitle(ResourceHelper.getValue("Cash_MoneyNotice"));
							message.setContent(ResourceHelper.getValue("Cash_MoneyNoticePre")+"("+currentNum+")"+ResourceHelper.getValue("Cash_MoneyNoticeMid")+"("+noticeNum+")，"+ResourceHelper.getValue("Cash_MoneyNoticeEnd"));
							message.setPubDate(new Date());
							// 查询总管理用户
							Member adminMember = new MemberManager().getMemberListByGroupId(CDict.GROUPID_ZONGGUANLI).get(0);
							message.setPubMemberID(adminMember.getID());
							message.setReceiverID(member.getID());
							message.setIsRead(CDict.NO.getID());
							new MessageManager().saveMessage(message);
						}
					}
				}
			}
			output(strResult);
		} catch (Exception err) {
			LogPrinter.error(err.toString());
		}
	}
}
