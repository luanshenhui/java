package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Resident;
import com.keda.wuye.entity.Rooms;

public interface ResidentBiz {
	public List<Resident> getResident();
	public void insertResident(String resident_id,String resident_name,String resident_phone,String resident_roomsid,String resident_sex,String resident_unit);
	//��ѯһ����Ϣ
	public Resident getResident(String id);
	//�޸�
	public void updateResident(String resident_id,String resident_name,String resident_phone,String resident_roomsid,String resident_sex,String resident_unit);
	//ɾ��
	public void deleteResident(String resident_id);
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String resident_id);
	//��ȡrooms���е�С�����
	public List<String> get_roomid();
	//��ʾ������Ϣ
	public List<Resident> select(String s);
	
}

