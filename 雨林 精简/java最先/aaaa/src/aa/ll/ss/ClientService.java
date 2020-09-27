package aa.ll.ss;

import java.util.List;

public class ClientService {//登陆
	public boolean island(String name,String phone){
		ClientDAO dao=new ClientDAO();
		List<Client>list=dao.getAll();
			for(Client c:list){
				if(c.equals(name) && c.equals(phone)){
					return true;
				}
			}
		
		return false;
		
	}
	public boolean isload(String name,String phone){//注册
		ClientDAO dao=new ClientDAO();
		List<Client>list=dao.getAll();
		for(Client c:list){
			if(c.equals(name)){
				return false;
			}
		}		
		Client c=new Client(6,name,"营口","什么",phone,"什么","什么");
		dao.add(c);
		return true;
		
	}
}
