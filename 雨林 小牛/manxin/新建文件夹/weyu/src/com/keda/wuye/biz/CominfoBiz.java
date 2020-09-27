package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Cominfo;
import com.keda.wuye.entity.Rooms;

public interface CominfoBiz {

	public List<Cominfo> getCominfo();
	public void insertCominfo(String cominfo_id,String cominfo_bus,String cominfo_medical,String cominfo_news,String cominfo_weather,String cominfo_notice);
	public List<String> get_comid();
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String cominfo_id);
	//ɾ��
	public void deleteCominfo(String cominfo_id);
	//�޸�
	public void updateCominfo(String cominfo_id,String cominfo_bus,String cominfo_medical,String cominfo_news,String cominfo_weather,String cominfo_notice);
	public Cominfo getCominfo(String id);
	//ģ����ѯ
	public List<Cominfo> select(String s);
	
}
