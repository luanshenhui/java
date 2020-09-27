package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.PlantBiz;
import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.dao.PlantDao;
import com.keda.wuye.dao.impl.HousesDaoImpl;
import com.keda.wuye.dao.impl.PlantDaoImpl;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Plant;

public class PlantBizImpl implements PlantBiz {
	private PlantDao plantDao = new PlantDaoImpl();
	//��ʾ������Ϣ
	public List<Plant> getPlant()
	{
		List<Plant> listPlant = plantDao.getPlant();
		return listPlant;
	}
	//��ʾ������Ϣ
	public List<Plant> select(String s)
	{
		List<Plant> listPlant = plantDao.select(s);
		return listPlant;
	}
	
	//��ѯһ����Ϣ
	public Plant getPlant(String id)
	{
		Plant plant = plantDao.getPlant(id);
		return plant;
	}
	//���
	public void insertPlant(String plant_id,String plant_name,String plant_comid,String plant_factory,String plant_date,int plant_num,int plant_repaircycle)
	{
		plantDao.insertPlant(plant_id, plant_name, plant_comid, plant_factory, plant_date, plant_num, plant_repaircycle);
	}
	//�޸�
	public void updatePlant(String plant_id,String plant_name,String plant_comid,String plant_factory,String plant_date,int plant_num,int plant_repaircycle)
	{
		plantDao.updatePlant(plant_id, plant_name, plant_comid, plant_factory, plant_date, plant_num, plant_repaircycle);
	}
	//ɾ��
	public void deletePlant(String plant_id)
	{
		plantDao.deletePlant(plant_id);
	}
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String plant_id)
	{
		boolean b = plantDao.idEqual(plant_id);
		return b;
	}
	//��ȡcommunity���е�С�����
	public List<String> get_comid()
	{
		List<String> list_comid = plantDao.get_comid();
		return list_comid;
	}
	
}
