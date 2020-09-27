package chinsoft.service.member;


import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.MemberManager;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class ChangeRegisttime extends BaseServlet{
	
	private static final long serialVersionUID = 1L;
	
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		String result=null;
		String strKeyword = request.getParameter("keywords");
		MemberManager manager=new MemberManager();
		Member member=manager.getMemberByUsername(strKeyword);
		if(member==null){
			result="用户名错误";
		}else{
			try {
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
			//固定值 2014年6月1日
			Date registerDate= sdf.parse("2014-6-1");
			member.setRegistDate(registerDate);
			manager.update(member);
			result="修改成功";
			} catch (Exception e) {
			  result="系统错误";
			}
		}
		output(result);
	}
	

}
