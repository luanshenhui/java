package com.keda.wuye.dao;

import java.util.List;

import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Plant;

public interface PlantDao {

	//显示所有信息
	public List<Plant> getPlant();
	//查询一条信息
	public Plant getPlant(String id);
	//添加
	public void insertPlant(String plant_id,String plant_name,String plant_comid,String plant_factory,String plant_date,int plant_num,int plant_repaircycle);
	//修改
	public void updatePlant(String plant_id,String plant_name,String plant_comid,String plant_factory,String plant_date,int plant_num,int plant_repaircycle);
	//删除
	public void deletePlant(String plant_id);
	//判断编号是否重复
	public boolean idEqual(String plant_id);
	//获取community表中的小区编号
	public List<String> get_comid();
	//显示所有信息
	public List<Plant> select(String s);
	
}
