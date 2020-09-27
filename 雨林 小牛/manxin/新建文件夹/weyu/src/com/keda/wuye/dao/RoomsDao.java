package com.keda.wuye.dao;

import java.util.List;

import com.keda.wuye.entity.Rooms;

public interface RoomsDao {

	public List<Rooms> getRooms();
	public void insertRooms(String rooms_id,String rooms_housesid,String rooms_type,double rooms_area,double rooms_usearea);
	public List<String> get_houseid();
	public boolean idEqual(String rooms_id);
	public void deleteRooms(String rooms_id);
	public void updateRooms(String rooms_id,String rooms_housesid,String rooms_type,double rooms_area,double rooms_usearea);
	public Rooms getRooms(String id);
	//显示所有信息
	public List<Rooms> select(String s);
	
}
