package rcmtm.member;

import java.security.interfaces.RSAPrivateKey;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;
import rcmtm.business.ConfigSR;
import rcmtm.encrypt.CCBInterfaceUtil;
import rcmtm.encrypt.CCBRsaUtil;
import rcmtm.encrypt.SendDataUtil;
import rcmtm.entity.ErrorInfo;
import rcmtm.entity.Packets;
import chinsoft.business.CurrentInfo;
import chinsoft.business.MemberManager;
import chinsoft.core.DEncrypt;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;
import flexjson.JSONSerializer;


public class MemberBindingToSr extends BaseServlet {
	
	private static final long serialVersionUID = 7391945794655884485L;
	
	@SuppressWarnings("static-access")
	public void service(HttpServletRequest request,HttpServletResponse response) {
		
		String strCompany = (String) request.getSession().getAttribute("SessionKey_Cpcode");
		String strSrUserID = (String) request.getSession().getAttribute("SessionKey_srUserID");//善融账号
		String strHlUserID = (String) request.getSession().getAttribute("SessionKey_hlUserID");//红领账号
		System.out.println(new Date()+"绑定后向善融传递的session值SessionKey_srUserID："+strSrUserID);
		Member member = new MemberManager().getMemberByUsername(strHlUserID);
		String company =member.getCompanyName()==null?"":member.getCompanyName();//企业中文名称
		Packets packets=new Packets();
		packets.setCpcode(strCompany);
		packets.setLoginid(strHlUserID);
		packets.setLoginname("");
		packets.setUserid(strSrUserID);
		packets.setCompany(company);
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmms");//设置日期格式
        String timestamp =df.format(new Date());
		packets.setTimestamp(timestamp);
		String strKey ="";
		if("1002".equals(strCompany)){
			strKey = "redcollar";
		}else if("1003".equals(strCompany)){
			strKey = "cameo";
		}
		System.out.println("memberBindingToSr_auth:"+strCompany+strHlUserID+strSrUserID+company+timestamp+strKey);
		String auth = DEncrypt.md5(strCompany+strHlUserID+strSrUserID+company+timestamp+strKey);
		packets.setAuth(auth);
		String json=new JSONSerializer().exclude("*.class").deepSerialize(packets).toString();
		System.out.println(new Date()+"绑定后红领传递的参数(加密前):"+json);
//		json ="{\"auth\":\"a44f775cb94b3984c7985addf624efbd\",\"cpcode\":\"1002\",\"loginid\":\"TESTAA\",\"loginname\":\"null\",\"timestamp\":\"20130621171553\",\"userid\":\"cs\"}";

		try {
			//私钥加密
			RSAPrivateKey privk = new CCBRsaUtil().getRSAPrivateKeyPair(ConfigSR.PRIVATE_KEY);
			String enStr = new CCBRsaUtil().encryptByPriKey(privk,json);
	        StringBuffer para=new StringBuffer();
	        para.append("cpcode=").append(strCompany).append("&uniondata=").append(enStr);
	        
	        System.out.println("绑定后红领传递的参数(加密后):"+para.toString());
	        String result = new CCBInterfaceUtil().sendData(ConfigSR.URL_BIND,para.toString());
	        System.out.println("绑定后返回错误信息："+result);
	        //判断返回信息
			if(result.equals("")){//返回空，绑定失败，重发3次
				new SendDataUtil().sendDate(ConfigSR.URL_BIND, para.toString());
			}else{
				JSONObject  js=JSONObject.fromObject(result);
				ErrorInfo error=(ErrorInfo) JSONObject.toBean(js,ErrorInfo.class);
				if(!error.isFlag()){//返回false，绑定失败，重发3次
					new SendDataUtil().sendDate(ConfigSR.URL_BIND, para.toString());
				}
			} 
	        output(result);
	        
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
