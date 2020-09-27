package oa.weaver.services.WorkflowService;

import java.rmi.RemoteException;

import oa.weaver.hrm.webservice.UserBean;
import oa.weaver.workflow.webservices.WorkflowRequestInfo;


public class WorkflowServiceClient {
	public WorkflowServiceClient()
	{}
	public static void main(String[] args) throws Exception {
		
		WorkflowServiceClient hsc = new WorkflowServiceClient();
		getDaiBanShuLiang();
		getDaiBanLieBiao();
		submitWfDaiBai();
	
}
	/**
	 * ��ô����������
	 * @throws RemoteException 
	 */
	public static void getDaiBanShuLiang() throws RemoteException{
		WorkflowServicePortTypeProxy WorkflowServicePortTypeProxy = new WorkflowServicePortTypeProxy();
		int count = WorkflowServicePortTypeProxy.getToDoWorkflowRequestCount(3, null);
		System.out.println("�����������:"+count);//��ȡ������˽ӿ�
		//���ѯ������ѯ��ֻ��д������2����Ĳ�ѯ���� workflow_requestbase t1,workflow_currentoperator t2
		//��ѯ�������治��Ҫдand
		String conditions[] = new String[2];
		conditions[0] = "	t1.currentnodetype = 3 ";//״̬Ϊ����
		conditions[1] = "	t1.creater = 3 ";//������Ϊ111
		count = WorkflowServicePortTypeProxy.getToDoWorkflowRequestCount(3, conditions);
		System.out.println("�����������:"+count);//��ȡ������˽ӿ�
	}
	/**
	 * ��ô���б�
	 */
	public static void getDaiBanLieBiao() throws Exception{
		WorkflowServicePortTypeProxy WorkflowServicePortTypeProxy = new WorkflowServicePortTypeProxy();
		WorkflowRequestInfo WorkflowRequestInfo[] = WorkflowServicePortTypeProxy.getProcessedWorkflowRequestList(1, 15, 100, 3, null);//��ȡ������˽ӿ�
		System.out.println("��������б�����:"+WorkflowRequestInfo.length);
		for(int i=0;i<WorkflowRequestInfo.length;i++){
			WorkflowRequestInfo wri = WorkflowRequestInfo[i];
			System.out.println(wri.getRequestId()+"	"+wri.getCreatorName()+"	"+wri.getRequestName()+"	"+wri.getCreateTime());
		}
	}
	/**
	 * �����ύ
	 */
	public static void submitWfDaiBai() throws Exception{
		WorkflowServicePortTypeProxy WorkflowServicePortTypeProxy = new WorkflowServicePortTypeProxy();
		WorkflowRequestInfo wri=  WorkflowServicePortTypeProxy.getWorkflowRequest(2, 3, 0);
		String status = WorkflowServicePortTypeProxy.submitWorkflowRequest(wri, Integer.valueOf(wri.getRequestId()), 3, "submit", "����");//��ȡ������˽ӿ�
		System.out.println("״̬:"+status);
		//System.out.println(wri.getRequestId()+"	"+wri.getCreatorName()+"	"+wri.getRequestName()+"	"+wri.getCreateTime());
	}
	}
