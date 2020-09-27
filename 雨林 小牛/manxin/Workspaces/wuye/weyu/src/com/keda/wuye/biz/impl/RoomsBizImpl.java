package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.RoomsBiz;
import com.keda.wuye.dao.RoomsDao;
import com.keda.wuye.dao.impl.RoomsDaoImpl;
import com.keda.wuye.entity.Rooms;

public class RoomsBizImpl implements RoomsBiz {
	private RoomsDao roomsDao = new RoomsDaoImpl();
	public List<Rooms> getRooms()
	{
		List<Rooms> listRooms = roomsDao.getRooms();
		return listRooms;
	}
	//显示所有信息
	public List<Rooms> select(String s)
	{
		List<Rooms> listRooms = roomsDao.select(s);
		return listRooms;
	}
	public void insertRooms(String rooms_id,String rooms_housesid,String rooms_type,double rooms_area,double rooms_usearea)
	{
		roomsDao.insertRooms(rooms_id, rooms_housesid, rooms_type, rooms_area, rooms_usearea);
	}
	
	public List<String> get_houseid()
	{
		List<String> list_houseid = roomsDao.get_houseid();
		return list_houseid;
	}
	public boolean idEqual(String rooms_id)
	{
		boolean b = roomsDao.idEqual(rooms_id);
		return b;
	}
	public void deleteRooms(String rooms_id)
	{
		roomsDao.deleteRooms(rooms_id);
	}
	public void updateRooms(String rooms_id,String rooms_housesid,String rooms_type,double rooms_area,double rooms_usearea)
	{
		roomsDao.updateRooms(rooms_id, rooms_housesid, rooms_type, rooms_area, rooms_usearea);
	}
	public Rooms getRooms(String id)
	{
		Rooms rooms = roomsDao.getRooms(id);
		return rooms;
	}
}
