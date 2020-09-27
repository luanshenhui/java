package com.keda.wuye.dao;

import java.util.List;

import com.keda.wuye.entity.Houses;

public interface HousesDao {

	List<Houses> getHouses();
	void insertHouses(String houses_id,String houses_comid,String houses_date,int houses_floor,double houses_area,String houses_face,String houses_type);
	boolean idEqual(String houses_id);
	void deleteHouses(String houses_id);
	void updateHouses(String houses_id,String houses_comid,String houses_date,int houses_floor,double houses_area,String houses_face,String houses_type);
	Houses getHouses(String id);
	//��ȡcommunity���е�С�����
	public List<String> get_comid();
	//��ʾ������Ϣ
	public List<Houses> select(String s);
}
