package com.keda.wuye.dao;

import java.util.List;

import com.keda.wuye.entity.Alarm;
import com.keda.wuye.entity.Community;

public interface AlarmDao {
	//显示所有信息
	public List<Alarm> getAlarm();
	//添加
	public void insertAlarm(String alarm_id,String alarm_date,String alarm_location,String alarm_matter,String alarm_way,String alarm_dealway,String alarm_dealperson,String alarm_dealresult);
	//删除
	public void deleteAlarm(String alarm_id);
	//修改
	public void updateAlarm(String alarm_id,String alarm_date,String alarm_location,String alarm_matter,String alarm_way,String alarm_dealway,String alarm_dealperson,String alarm_dealresult);
	//查询一条信息
	public Alarm getAlarm(String id);
	//判断编号是否重复
	public boolean idEqual(String alarm_id);
	//模糊查询
	public List<Alarm> select(String s);
	
}
