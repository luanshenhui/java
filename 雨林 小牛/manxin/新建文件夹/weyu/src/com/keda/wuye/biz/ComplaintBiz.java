package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Complaint;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Repairs;

public interface ComplaintBiz {
	//��ʾ������Ϣ
	public List<Complaint> getComplaint();
	//��ѯһ����Ϣ
	public Complaint getComplaint(String id);
	//���
	public void insertComplaint(String complaint_id,String complaint_resid,String complaint_date,String complaint_matter,String complaint_dealperson,String complaint_way,String complaint_result);
	//�޸�
	public void updateComplaint(String complaint_id,String complaint_resid,String complaint_date,String complaint_matter,String complaint_dealperson,String complaint_way,String complaint_result);
	//ɾ��
	public void deleteComplaint(String complaint_id);
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String complaint_id);
	//��ȡresident���е�С�����
	public List<String> get_resiid();
	//ģ����ѯ
	public List<Complaint> select(String s);
	
}
