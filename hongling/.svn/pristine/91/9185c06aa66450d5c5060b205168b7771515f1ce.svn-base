package rcmtm.member;

import java.security.interfaces.RSAPrivateKey;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import rcmtm.business.ConfigSR;
import rcmtm.business.RcmtmManager;
import rcmtm.encrypt.CCBInterfaceUtil;
import rcmtm.encrypt.CCBRsaUtil;
import rcmtm.encrypt.SendDataUtil;
import chinsoft.bean.SingleSingOnBean;
import chinsoft.business.CompanysManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.core.DEncrypt;
import chinsoft.core.Utility;
import chinsoft.entity.Companys;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;


public class Login extends BaseServlet {
	private static final long serialVersionUID = 7391945794655883869L;
	
	@SuppressWarnings("static-access")
	public void service(HttpServletRequest request,HttpServletResponse response) {
		
		String strUniondata = Utility.toSafeString(request.getParameter("para"));//善融用户信息
		//测试--删掉
//		strUniondata="39944c54fadd333dc698430b1368f5f8404a6fb794f7d55864f578ca20a8487902ea5660e52e43c04e9de4381e7c7e7f3b60c8b79f673635b5a1d4a7136e0e9751d017357453c5744bd49042c80465ce7a6011ed21aedf449eb6807b2cc6b877e3a2be9ca3e8d63b96a9ab8e4f05c5dc2cc36b570604d7765921b2c2f91d1a7d98f1bb91413d89f5d4988015f4bccf85bfe8819aa971b1e46f0c55c7237b2a6c84f18ea07ce065269bd84835e03a60092a59dd212f1ce6158eccfdf3ec8794b620916995689c9c73cba50538e28576475a31b52afc50c4f3c647dd200bd2bc0d910d6790ff7d672268e236eb016103f95cc44881740a49082c0829183c7a7dae";
		try {
				System.out.println("登录时善融传递的参数(解密前)："+strUniondata);
				//解密
				RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
				String strUser = new CCBRsaUtil().decryptByPirvKey(privk,strUniondata);
				System.out.println(new Date()+"登录时善融传递的参数(解密后)："+strUser);
				//解析JSON
				JSONObject jsonObj = JSONObject.fromObject(strUser);
				String strCpcode = jsonObj.getString("cpcode");//企业编码
				String strUserID = jsonObj.getString("userid");//善融账号
				String strLoginID = jsonObj.getString("loginid");//企业账号
				String strCompany = jsonObj.getString("company");//公司名称
				String strTimestamp = jsonObj.getString("timestamp");//善融时间戳
				String strAuth = jsonObj.getString("auth");//善融时间戳
				int nStatus = jsonObj.getInt("status");//善融绑定状态
				String strKey ="";
				if("1002".equals(strCpcode)){
					strKey = "redcollar";
				}else if("1003".equals(strCpcode)){
					strKey = "cameo";
				}
				System.out.println("login_auth:"+strCpcode+strLoginID+strUserID+strCompany+nStatus+strTimestamp+strKey);
				String auth = DEncrypt.md5(strCpcode+strLoginID+strUserID+strCompany+nStatus+strTimestamp+strKey);
				if("nul".equals(strUserID)){//游客进入浏览页面
					if("1003".equals(strCpcode)){
						response.sendRedirect("http://cameobespoke.com");
					}else{
						response.sendRedirect("http://www.rcmtm.cn");
					}
				}else{//绑定成功，登录下单系统
					Cookie cookie=new Cookie("SessionKey_srUserID", strUserID);
					cookie.setMaxAge(60*60*24*7);
					response.addCookie(cookie);
					request.getSession().setAttribute("SessionKey_srUserID", strUserID);
					request.getSession().setAttribute("SessionKey_Cpcode", strCpcode);
					System.out.println("SessionKey_srUserID:"+strUserID);
					Member cuMember = new MemberManager().getBindingMember(strUserID,Utility.toSafeInt(strCpcode));
					if(cuMember != null){//已绑定
						if(nStatus == 1){//绑定失败，发送3次绑定信息
							SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmms");//设置日期格式
					        String timestamp =df.format(new Date());
							String strPara = new RcmtmManager().bindingSR(strUserID,timestamp,strCpcode);
							new SendDataUtil().sendDate(ConfigSR.URL_BIND, strPara);
						}
						cuMember.setClientIP(request.getRemoteAddr());
						cuMember.setLastLoginDate(new Date());
						new MemberManager().saveMember(cuMember);
						cuMember.setUserStatus(10050);//已登录
						CurrentInfo.setCurrentMember(cuMember);
						
						//企业代码RC000003
						CompanysManager companysManager=new CompanysManager();
						Companys company=companysManager.getCompanyByCode("RC000003");
						request.getSession().setAttribute("company", company);
						
						String strMyPlatformUrl = "/hongling/pages/common/orden.jsp";//专业版
						if(cuMember.getHomePage() == 20118){//时尚版
							strMyPlatformUrl = "/hongling/pages/fix/fix.jsp";
						}else if(cuMember.getHomePage() == 20121){//快速下单
//							strMyPlatformUrl = "/hongling/pages/common/orden_page.jsp";
							strMyPlatformUrl = "/hongling/orden/dordenPage.do";//快速下单
						}
						response.sendRedirect(strMyPlatformUrl);
						
					}else{//未绑定
						response.sendRedirect("/hongling/pages/rcmtm/binding.jsp");//注册或绑定
					}
				}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
