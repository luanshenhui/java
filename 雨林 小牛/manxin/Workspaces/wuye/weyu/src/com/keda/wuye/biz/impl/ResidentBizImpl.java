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
	
	//��ʾ������Ϣ
	public List<Resident> getResident()
	{
		List<Resident> listResident = residentDao.getResident();
		return listResident;
	}
	//��ʾ������Ϣ
	public List<Resident> select(String s)
	{
		List<Resident> listResident = residentDao.select(s);
		return listResident;
	}
	//���
	public void insertResident(String resident_id,String resident_name,String resident_phone,String resident_roomsid,String resident_sex,String resident_unit)
	{
		residentDao.insertResident(resident_id, resident_name, resident_phone, resident_roomsid, resident_sex, resident_unit);
	}
	//��ѯһ����Ϣ
	public Resident getResident(String id)
	{
		Resident resident = residentDao.getResident(id);
		return resident;	
	}
	//�޸�
	public void updateResident(String resident_id,String resident_name,String resident_phone,String resident_roomsid,String resident_sex,String resident_unit)
	{
		residentDao.updateResident(resident_id, resident_name, resident_phone, resident_roomsid, resident_sex, resident_unit);
	}
	//ɾ��
	public void deleteResident(String resident_id)
	{
		residentDao.deleteResident(resident_id);
	}
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String resident_id)
	{
		boolean b = residentDao.idEqual(resident_id);
		return b;
	}

	//��ȡrooms���е�С�����
	public List<String> get_roomid()
	{
		List<String> list_roomid = residentDao.get_roomid();
		return list_roomid;
	}
	
}
