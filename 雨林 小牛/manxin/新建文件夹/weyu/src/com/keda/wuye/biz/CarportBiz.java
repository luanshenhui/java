package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Carport;
import com.keda.wuye.entity.Houses;

public interface CarportBiz {

	//��ʾ������Ϣ
	public List<Carport> getCarport();
	//��ѯһ����Ϣ
	public Carport getCarport(String id);
	//���
	public void insertCarport(String carport_id,String carport_resid,String carport_carnum,String carport_cartype,double carport_area);
	//�޸�
	public void updateCarport(String carport_id,String carport_resid,String carport_carnum,String carport_cartype,double carport_area);
	//ɾ��
	public void deleteCarport(String carport_id);
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String carport_id);
	//��ȡcommunity���е�С�����
	public List<String> get_resiid();
	//ģ����ѯ
	public List<Carport> select(String s);
}
