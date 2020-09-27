package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.ResidentBiz;
import com.keda.wuye.biz.RoomsBiz;
import com.keda.wuye.dao.ResidentDao;
import com.keda.wuye.dao.RoomsDao;
import com.keda.wuye.dao.impl.ResidentDaoImpl;
import com.keda.wuye.dao.impl.RoomsDaoImpl;
import com.keda.wuye.entity.Resident;
import com.keda.wuye.entity.Rooms;

public class ResidentBizImpl implements ResidentBiz {
	private ResidentDao residentDao = new ResidentDaoImpl();
	
	//显示所有信息
	public List<Resident> getResident()
	{
		List<Resident> listResident = residentDao.getResident();
		return listResident;
	}
	//显示所有信息
	public List<Resident> select(String s)
	{
		List<Resident> listResident = residentDao.select(s);
		return listResident;
	}
	//添加
	public void insertResident(String resident_id,String resident_name,String resident_phone,String resident_roomsid,String resident_sex,String resident_unit)
	{
		residentDao.insertResident(resident_id, resident_name, resident_phone, resident_roomsid, resident_sex, resident_unit);
	}
	//查询一条信息
	public Resident getResident(String id)
	{
		Resident resident = residentDao.getResident(id);
		return resident;	
	}
	//修改
	public void updateResident(String resident_id,String resident_name,String resident_phone,String resident_roomsid,String resident_sex,String resident_unit)
	{
		residentDao.updateResident(resident_id, resident_name, resident_phone, resident_roomsid, resident_sex, resident_unit);
	}
	//删除
	public void deleteResident(String resident_id)
	{
		residentDao.deleteResident(resident_id);
	}
	//判断编号是否重复
	public boolean idEqual(String resident_id)
	{
		boolean b = residentDao.idEqual(resident_id);
		return b;
	}

	//获取rooms表中的小区编号
	public List<String> get_roomid()
	{
		List<String> list_roomid = residentDao.get_roomid();
		return list_roomid;
	}
	
}
