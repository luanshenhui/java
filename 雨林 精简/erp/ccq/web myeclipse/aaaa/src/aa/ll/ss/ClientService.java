package aa.ll.ss;

import java.util.List;

public class ClientService {//��½
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
	public boolean isload(String name,String phone){//ע��
		ClientDAO dao=new ClientDAO();
		List<Client>list=dao.getAll();
		for(Client c:list){
			if(c.equals(name)){
				return false;
			}
		}		
		Client c=new Client(6,name,"Ӫ��","ʲô",phone,"ʲô","ʲô");
		dao.add(c);
		return true;
		
	}
}
