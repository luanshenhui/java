package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.dao.impl.HousesDaoImpl;
import com.keda.wuye.entity.Houses;

public class HousesBizImpl implements HousesBiz {
	private HousesDao housesDao = new HousesDaoImpl();
	public List<Houses> getHouses()
	{
		List<Houses> listHouses = housesDao.getHouses();
		return listHouses;
	}
	//显示所有信息
	public List<Houses> select(String s)
	{
		List<Houses> listHouses = housesDao.select(s);
		return listHouses;
	}
	public void insertHouses(String houses_id,String houses_comid,String houses_date,int houses_floor,double houses_area,String houses_face,String houses_type)
	{
		housesDao.insertHouses(houses_id, houses_comid, houses_date, houses_floor, houses_area, houses_face, houses_type);
	}
	public boolean idEqual(String houses_id)
	{
		boolean b = housesDao.idEqual(houses_id);
		return b;
	}
	public void deleteHouses(String houses_id)
	{
		housesDao.deleteHouses(houses_id);
	}
	public void updateHouses(String houses_id,String houses_comid,String houses_date,int houses_floor,double houses_area,String houses_face,String houses_type)
	{
		housesDao.updateHouses(houses_id, houses_comid, houses_date, houses_floor, houses_area, houses_face, houses_type);
	}
	public Houses getHouses(String id)
	{
		Houses houses = housesDao.getHouses(id);
		return houses;
		
	}
	
	//获取community表中的小区编号
	public List<String> get_comid()
	{
		List<String> listcomid  = housesDao.get_comid();
		return listcomid;
	}
	
}
