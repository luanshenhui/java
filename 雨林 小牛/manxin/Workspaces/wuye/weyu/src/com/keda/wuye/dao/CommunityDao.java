package com.keda.wuye.dao;

import java.util.List;

import com.keda.wuye.entity.Community;

public interface CommunityDao {

	List<Community> getCommunity();
	void insertCommunity(String com_id,String com_name,String com_date,String com_principal,double com_area,double com_buildarea,String com_location);
	void deleteCommunity(String com_id);
	void updateCommunity(String com_id,String com_name,String com_date,String com_principal,double com_area,double com_buildarea,String com_location);
	Community getCommunity(String id);
	boolean idEqual(String com_id);
	//Ä£ºý²éÑ¯
	public List<Community> select(String s);
}
