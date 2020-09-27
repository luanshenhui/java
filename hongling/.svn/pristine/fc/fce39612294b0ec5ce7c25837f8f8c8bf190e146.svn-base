package oa.weaver.services.RequestService;

import java.rmi.RemoteException;

import oa.weaver.hrm.webservice.UserBean;
import oa.weaver.soa.workflow.request.Cell;
import oa.weaver.soa.workflow.request.DetailTable;
import oa.weaver.soa.workflow.request.DetailTableInfo;
import oa.weaver.soa.workflow.request.MainTableInfo;
import oa.weaver.soa.workflow.request.Property;
import oa.weaver.soa.workflow.request.RequestInfo;
import oa.weaver.soa.workflow.request.Row;
import oa.weaver.workflow.webservices.WorkflowRequestInfo;

public class RequestServiceClient {
	public RequestServiceClient()
	{}
	public static void main(String[] args) throws Exception {
		
		RequestServiceClient hsc = new RequestServiceClient();
		//getDaiBanShuLiang();
		//getDaiBanLieBiao();
		getRequstInfoTable();
	
}

	public static void getRequstInfoTable() throws Exception{
		RequestServicePortTypeProxy RequestServicePortTypeProxy = new RequestServicePortTypeProxy();
		RequestInfo  ri = RequestServicePortTypeProxy.getRequest(105580);
		MainTableInfo mti = ri.getMainTableInfo();
		
		System.out.println(mti.getPropertyCount());
		Property[] p = mti.getProperty();
		System.out.println(p.length);
			for(int i=0;i<p.length;i++)
			{
				//Cell c = (Cell)p[i];
				//Row  r = p[i];
				System.out.println(p[i].getName());
				System.out.println(p[i].getValue());
			}
		
		}
	public static void getRequstInfoDetailTable() throws Exception{
		RequestServicePortTypeProxy RequestServicePortTypeProxy = new RequestServicePortTypeProxy();
		RequestInfo  ri = RequestServicePortTypeProxy.getRequest(105580);
		DetailTableInfo dti = ri.getDetailTableInfo();
		System.out.println(dti.getDetailTableCount());//��ϸ������
		//for(int i=0;i<dti.getDetailTableCount();i++){
			DetailTable[] dt = dti.getDetailTable();
			for(int i=0;i<dt.length;i++)
			{
				Row[] r = dt[i].getRow();
				for(int j=0;j<r.length;j++)
				{
					Cell[] c = r[j].getCell();
					for(int k=0;k<c.length;k++)
					{
						System.out.println(c[k].getName());
						System.out.println(c[k].getValue());
					}
				}
			}
				//}
	}
		
	}
