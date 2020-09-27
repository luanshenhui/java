package chinsoft.service.mix;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.MemberManager;
import chinsoft.business.MixManager;
import chinsoft.business.MixSelectedManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.entity.Mix;
import chinsoft.entity.MixSelected;
import chinsoft.service.core.BaseServlet;

public class MixSelectedService extends BaseServlet{
	private static final long serialVersionUID = 1L;
	private String add = "add";
	private String delete = "delete";
	private String info ="";
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		
			super.service();
			String type = getParameter("type");
			String membername = getParameter("membername");
			String mixcodes = getParameter("mixcodes");
			Member member = new MemberManager().getMemberByUsername(membername);
			String memberid = (member == null || member.getID().equals("")) ? "" : member.getID() ;
			MixSelected mixSelected = new MixSelected();
			if(!memberid.equals(""))
			{
				//
				List<MixSelected> codes = new MixSelectedManager().getMixSelectedByMemberID(memberid);
				if( codes.isEmpty() || codes.get(0)==null){
					mixSelected.setMemberid(memberid);
				}else{
					mixSelected = codes.get(0);
				}
				//get
				String str = "";
				if(type.equalsIgnoreCase(add)){
					str = getDistinctArr(mixSelected.getMixcodes(),mixcodes,add);
				}else if(type.equalsIgnoreCase(delete)){
					str = getDistinctArr(mixSelected.getMixcodes(),mixcodes,delete);
				}
				mixSelected.setMixcodes(str);
				//save
				try {
					new MixSelectedManager().saveMixSelected(mixSelected);
				} catch (Exception e) {
					LogPrinter.debug(e.getMessage());
					info = "error";
				}
				info = "OK";
			}else{
				info ="用户不存在!";
			}
			output(info);
	}
	
	/**
	 *  	getDistinctArr
	 *  	status : add , delete
	 */
	private String getDistinctArr( String a ,String b,String status){
		a= Utility.toSafeString(a);
		b= Utility.toSafeString(b);
		String[] arra = a.trim().split(","),arrb = b.trim().split(",");
		StringBuffer val = new StringBuffer();
		if(status.equalsIgnoreCase(add)){
			val.append(a);
			for(int i=0;i<arrb.length;i++)
			{
				if(!a.contains(arrb[i]))
				{
					if(this.getCheckMix(arrb[i].toString()))//仅当增加时判断是否混搭号存在?
						val.append(arrb[i].toString().trim()+",") ;
				}
			}
		}else if(status.equalsIgnoreCase(delete)){
			for(int i=0;i<arra.length;i++)
			{
				//check
				String flag = "0";
				for(int ii=0;ii<arrb.length;ii++)
				{
					if(arrb[ii].equalsIgnoreCase(arra[i]))
					{
						flag="1";
					}
				}
				//add
				if(flag=="0"){
					val.append(arra[i].toString().trim()+",");
				}
			}
		}
		return val.toString();
	}
	/**
	 *  	验证混搭号是否存在
	 */
	private boolean getCheckMix(String mixcode){
		List<Mix> mix = new MixManager().getMixByCode(mixcode);
		return mix.isEmpty() || mix.get(0).toString().trim().equals("") ? false : true ; 
	}
}
