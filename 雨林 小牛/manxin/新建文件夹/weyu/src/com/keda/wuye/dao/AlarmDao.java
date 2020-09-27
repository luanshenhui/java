package com.keda.wuye.dao;

import java.util.List;

import com.keda.wuye.entity.Alarm;
import com.keda.wuye.entity.Community;

public interface AlarmDao {
	//��ʾ������Ϣ
	public List<Alarm> getAlarm();
	//���
	public void insertAlarm(String alarm_id,String alarm_date,String alarm_location,String alarm_matter,String alarm_way,String alarm_dealway,String alarm_dealperson,String alarm_dealresult);
	//ɾ��
	public void deleteAlarm(String alarm_id);
	//�޸�
	public void updateAlarm(String alarm_id,String alarm_date,String alarm_location,String alarm_matter,String alarm_way,String alarm_dealway,String alarm_dealperson,String alarm_dealresult);
	//��ѯһ����Ϣ
	public Alarm getAlarm(String id);
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String alarm_id);
	//ģ����ѯ
	public List<Alarm> select(String s);
	
}
