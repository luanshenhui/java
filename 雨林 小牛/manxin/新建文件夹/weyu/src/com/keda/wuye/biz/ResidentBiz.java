package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Resident;
import com.keda.wuye.entity.Rooms;

public interface ResidentBiz {
	public List<Resident> getResident();
	public void insertResident(String resident_id,String resident_name,String resident_phone,String resident_roomsid,String resident_sex,String resident_unit);
	//查询一条信息
	public Resident getResident(String id);
	//修改
	public void updateResident(String resident_id,String resident_name,String resident_phone,String resident_roomsid,String resident_sex,String resident_unit);
	//删除
	public void deleteResident(String resident_id);
	//判断编号是否重复
	public boolean idEqual(String resident_id);
	//获取rooms表中的小区编号
	public List<String> get_roomid();
	//显示所有信息
	public List<Resident> select(String s);
	
}

