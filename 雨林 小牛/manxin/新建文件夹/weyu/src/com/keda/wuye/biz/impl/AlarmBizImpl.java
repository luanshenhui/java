package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.AlarmBiz;
import com.keda.wuye.biz.CommunityBiz;
import com.keda.wuye.dao.AlarmDao;
import com.keda.wuye.dao.CommunityDao;
import com.keda.wuye.dao.impl.AlarmDaoImpl;
import com.keda.wuye.dao.impl.CommunityDaoImpl;
import com.keda.wuye.entity.Alarm;
import com.keda.wuye.entity.Community;

public class AlarmBizImpl implements AlarmBiz{
	private AlarmDao  alarmDao = new  AlarmDaoImpl();
	//显示所有信息
	public List<Alarm> getAlarm()
	{
		List<Alarm> alarm = alarmDao.getAlarm();
		return alarm;
	}
	//添加
	public void insertAlarm(String alarm_id,String alarm_date,String alarm_location,String alarm_matter,String alarm_way,String alarm_dealway,String alarm_dealperson,String alarm_dealresult)
	{
		alarmDao.insertAlarm(alarm_id, alarm_date, alarm_location, alarm_matter, alarm_way, alarm_dealway, alarm_dealperson, alarm_dealresult);
	}
	//删除
	public void deleteAlarm(String alarm_id)
	{
		alarmDao.deleteAlarm(alarm_id);
	}
	//修改
	public void updateAlarm(String alarm_id,String alarm_date,String alarm_location,String alarm_matter,String alarm_way,String alarm_dealway,String alarm_dealperson,String alarm_dealresult)
	{
		alarmDao.updateAlarm(alarm_id, alarm_date, alarm_location, alarm_matter, alarm_way, alarm_dealway, alarm_dealperson, alarm_dealresult);
	}
	//查询一条信息
	public Alarm getAlarm(String id)
	{
		Alarm alarm = alarmDao.getAlarm(id);
		return alarm;
	}
	//判断编号是否重复
	public boolean idEqual(String alarm_id)
	{
		boolean b = alarmDao.idEqual(alarm_id);
		return b;
	}
	//模糊查询
	public List<Alarm> select(String s)
	{
		List<Alarm> alarm = alarmDao.select(s);
		return alarm;
	}
}
