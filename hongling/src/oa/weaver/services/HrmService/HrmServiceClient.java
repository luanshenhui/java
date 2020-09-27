package oa.weaver.services.HrmService;

import oa.weaver.hrm.webservice.UserBean;

public class HrmServiceClient {
	public HrmServiceClient()
	{}
	public static void main(String[] args) {
		
		HrmServiceClient hsc = new HrmServiceClient();
		hsc.getResourceInfo();
	
}
	public void getResourceInfo()
	{
		try {
			HrmServiceLocator client = new HrmServiceLocator();	       
		    HrmServicePortType service = client.getHrmServiceHttpPort();
		    System.out.println(service.checkUser("127.0.0.1", "lm", "1"));
		    
		    //��ȡ��Ա��Ϣ
		    UserBean[] ui = service.getHrmUserInfo("http://oa.rcmtm.com", "", "", "", "" ,"");
	        for(int i=0;i<ui.length;i++)
	        {
	        	System.out.println(ui[i].getLastname());
	        }
		} catch (Exception e) {
		    e.printStackTrace();
		}
	}
	}
