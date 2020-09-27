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
	//显示所有信息
	public List<Plant> getPlant()
	{
		List<Plant> listPlant = plantDao.getPlant();
		return listPlant;
	}
	//显示所有信息
	public List<Plant> select(String s)
	{
		List<Plant> listPlant = plantDao.select(s);
		return listPlant;
	}
	
	//查询一条信息
	public Plant getPlant(String id)
	{
		Plant plant = plantDao.getPlant(id);
		return plant;
	}
	//添加
	public void insertPlant(String plant_id,String plant_name,String plant_comid,String plant_factory,String plant_date,int plant_num,int plant_repaircycle)
	{
		plantDao.insertPlant(plant_id, plant_name, plant_comid, plant_factory, plant_date, plant_num, plant_repaircycle);
	}
	//修改
	public void updatePlant(String plant_id,String plant_name,String plant_comid,String plant_factory,String plant_date,int plant_num,int plant_repaircycle)
	{
		plantDao.updatePlant(plant_id, plant_name, plant_comid, plant_factory, plant_date, plant_num, plant_repaircycle);
	}
	//删除
	public void deletePlant(String plant_id)
	{
		plantDao.deletePlant(plant_id);
	}
	//判断编号是否重复
	public boolean idEqual(String plant_id)
	{
		boolean b = plantDao.idEqual(plant_id);
		return b;
	}
	//获取community表中的小区编号
	public List<String> get_comid()
	{
		List<String> list_comid = plantDao.get_comid();
		return list_comid;
	}
	
}
