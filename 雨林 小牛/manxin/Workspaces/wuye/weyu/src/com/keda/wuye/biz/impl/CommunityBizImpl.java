package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.CommunityBiz;
import com.keda.wuye.dao.CommunityDao;
import com.keda.wuye.dao.impl.CommunityDaoImpl;
import com.keda.wuye.entity.Community;

public class CommunityBizImpl implements CommunityBiz{
	private CommunityDao  communityDao = new  CommunityDaoImpl();
	public List<Community> getCommunityDate()
	{
		List<Community> community = communityDao.getCommunity();
		return community;
	}
	
	public void insertCommunity(String com_id,String com_name,String com_date,String com_principal,double com_area,double com_buildarea,String com_location)
	{
		communityDao.insertCommunity(com_id, com_name, com_date, com_principal, com_area, com_buildarea, com_location);
	}
	public void deleteCommunity(String com_id)
	{
		communityDao.deleteCommunity(com_id);
	}
	public void updateCommunity(String com_id,String com_name,String com_date,String com_principal,double com_area,double com_buildarea,String com_location)
	{
		communityDao.updateCommunity(com_id, com_name, com_date, com_principal, com_area, com_buildarea, com_location);
	}
	public Community getCommunity(String id)
	{
		Community community = communityDao.getCommunity(id);
		return community;
	}
	public boolean idEqual(String com_id)
	{
		boolean b = communityDao.idEqual(com_id);
		return b;
	}
	//Ä£ºý²éÑ¯
	public List<Community> select(String s)
	{
		List<Community> list_select = communityDao.select(s);
		return list_select;
	}
}
