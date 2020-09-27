package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Repairs;

public interface RepairsBiz {
	//��ʾ������Ϣ
	public List<Repairs> getRepairs();
	//��ѯһ����Ϣ
	public Repairs getRepairs(String id);
	//���
	public void insertRepairs(String repairs_id,String repairs_plantid,String repairs_date,String repairs_reason,String repairs_way,String repairs_person,String repairs_result);
	//�޸�
	public void updateRepairs(String repairs_id,String repairs_plantid,String repairs_date,String repairs_reason,String repairs_way,String repairs_person,String repairs_result);
	//ɾ��
	public void deleteRepairs(String repairs_id);
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String repairs_id);
	//��ȡplant���е�С�����
	public List<String> get_plantid();
	//��ʾ������Ϣ
	public List<Repairs> select(String s);
}
