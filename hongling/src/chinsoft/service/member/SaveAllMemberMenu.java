package chinsoft.service.member;

import java.util.List;
import java.util.TreeSet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.Dict1Manager;
import chinsoft.business.MemberManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict1;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class SaveAllMemberMenu extends BaseServlet{
	private static final long serialVersionUID = -6192897803965585696L;
	@Override
	protected void service(HttpServletRequest request,HttpServletResponse response) {
		super.service();
		try {
			
            String strType = getParameter("type");//添加、删除
            if("check".equals(strType)){
            	String username = getParameter("username");//用户
                String checkQorderMeniusID = getParameter("checkMeniusID");//工艺id
                Member member = new MemberManager().getMemberByUsername(username);
                String[] ids = Utility.toSafeString(member.getQordermenuids()).split(",");
                for (String id : ids){
                	if(checkQorderMeniusID.equals(id)){
                		Dict1 dict1 = Dict1Manager.getDict1FromDB(Utility.toSafeInt(id));
        				if(dict1 != null){
        					output(dict1);
        				}
                	}
                }
    		}else{
    			String strQorderMemberGroupID = getParameter("membergroup");//更新权限分类
                String strQorderMenuIDs = getParameter("dictmenius");//工艺id
                List<Member> members= new MemberManager().getMembersByGroupID(strQorderMemberGroupID);//符合当前权限 所有用户
                
                for(Member member : members){
                		if("add".equals(strType)){//添加
                			String str = Utility.toSafeString(member.getQordermenuids())+strQorderMenuIDs;
                    		str=str.replaceAll("\\s*", "");//取消空格
                    		
                    		//去掉重复工艺
                    		TreeSet<String> tr = new TreeSet<String>();
                    		String[] s =Utility.getStrArray(str);
                    		for(int i=0;i<s.length;i++){
                    			tr.add(s[i]);
                    		}
                    		String[] s2= new String[tr.size()];
                    		String menuAlls="";
                    		for(int i=0;i<s2.length;i++){
                    			s2[i]=tr.pollFirst();//从TreeSet中取出元素重新赋给数组
                    			//去掉dict中没有的id
                    			Dict1 dict1 = Dict1Manager.getDict1ByID(Utility.toSafeInt(s2[i]));
                    			if(dict1 != null){
                    				menuAlls +=s2[i]+",";
                    			}
                    		}
                    		
                    		member.setQordermenuids(menuAlls);
                    		//保存权限
                    		new MemberManager().saveMember(member);
                		}else if("del".equals(strType)){//删除
                			String strAll = ","+Utility.toSafeString(member.getQordermenuids());
                			strAll=strAll.replaceAll("\\s*", "");
                			String strDel= strQorderMenuIDs.replaceAll("\\s*", "");
                			String[] s =Utility.getStrArray(strDel);
                    		for(int i=0;i<s.length;i++){
                    			String del=","+s[i]+",";
                    			if(strAll.contains(del)){
                    				strAll = strAll.replace(del, ",");
                    			}
                    		}
                    		member.setQordermenuids(strAll.substring(1));
                    		new MemberManager().saveMember(member);
                		}
                }
    		}
            output(Utility.RESULT_VALUE_OK);
		} catch (Exception e) {
			LogPrinter.info("SaveAllMemberMenu   "+e.getMessage());
		}
	}
}
