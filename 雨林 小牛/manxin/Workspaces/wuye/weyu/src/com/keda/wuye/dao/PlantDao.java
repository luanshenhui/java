package com.keda.wuye.dao;

import java.util.List;

import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Plant;

public interface PlantDao {

	//��ʾ������Ϣ
	public List<Plant> getPlant();
	//��ѯһ����Ϣ
	public Plant getPlant(String id);
	//���
	public void insertPlant(String plant_id,String plant_name,String plant_comid,String plant_factory,String plant_date,int plant_num,int plant_repaircycle);
	//�޸�
	public void updatePlant(String plant_id,String plant_name,String plant_comid,String plant_factory,String plant_date,int plant_num,int plant_repaircycle);
	//ɾ��
	public void deletePlant(String plant_id);
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String plant_id);
	//��ȡcommunity���е�С�����
	public List<String> get_comid();
	//��ʾ������Ϣ
	public List<Plant> select(String s);
	
}
