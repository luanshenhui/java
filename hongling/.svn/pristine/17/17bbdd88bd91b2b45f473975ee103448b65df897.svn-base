package chinsoft.test;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import chinsoft.business.MemberManager;
import chinsoft.core.DataAccessObject;
import chinsoft.entity.Member;

public class TestCase {
	
	   //@Test//保存测试
	    public  void saveTest() {
		MemberManager manager=new MemberManager();
		Member member=new Member();
		//member.setId(UUID.randomUUID().toString());
		member.setName("123");
		member.setGroupID(3);
		member.setLastLoginDate(new Date(System.currentTimeMillis()));
		member.setPassword("fvdf");
		member.setUsername("ased");
		member.setClientIP("12.02515");
		manager.saveMember(member);
	    }
	   //@Test//通过id得到类测试
	    public  void getTest() {
	    	MemberManager manager=new MemberManager();
	    	System.out.println(manager.getMemberByID("402881cb33f8e0790133f8e07ae80001").getName());
	    }
	   //@Test//得到list
	   public void getListTest(){
		   MemberManager manager=new MemberManager();
		   System.out.println(manager.getAllMember().get(0).getName());
	   }
	   //@Test//分页
	   public void getlist(){
		   //System.out.println(manager.getMembers(1, 2).get(1).getName());
	   }
	   //@Test//删除
	   public void de(){
		   MemberManager manager=new MemberManager();
		   manager.removeMemberByID("402881cb33f7e5150133f7e517130001");
	   }
	   //@Test
	   public void ex(){
		   DataAccessObject accessObject=new DataAccessObject();
		   System.out.println(accessObject.exist(DataAccessObject.openSession(),Member.class, "402881cb33f7fs2e00133f7f2e1d60001"));
	   }
	   //@Test
	   public void cu(){
		   DataAccessObject accessObject=new DataAccessObject();
		   System.out.println(accessObject.getMax(DataAccessObject.openSession(),Member.class));
	   }
	 //@Test
	  public void cud(String[] args) {
		List<String> list=new ArrayList<String>();
		list.add("123");
		list.add("456");
		List<String> list2=new ArrayList<String>(list);
		list2.addAll(list);
		list2.set(0, "789");
		System.out.println(list2.get(0));
		System.out.println(list.get(0));
		
 	}
}

	
	


