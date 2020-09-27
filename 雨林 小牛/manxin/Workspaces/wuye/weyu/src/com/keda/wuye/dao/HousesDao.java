package com.keda.wuye.dao;

import java.util.List;

import com.keda.wuye.entity.Houses;

public interface HousesDao {

	List<Houses> getHouses();
	void insertHouses(String houses_id,String houses_comid,String houses_date,int houses_floor,double houses_area,String houses_face,String houses_type);
	boolean idEqual(String houses_id);
	void deleteHouses(String houses_id);
	void updateHouses(String houses_id,String houses_comid,String houses_date,int houses_floor,double houses_area,String houses_face,String houses_type);
	Houses getHouses(String id);
	//获取community表中的小区编号
	public List<String> get_comid();
	//显示所有信息
	public List<Houses> select(String s);
}
