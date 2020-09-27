package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.CominfoBiz;
import com.keda.wuye.biz.RoomsBiz;
import com.keda.wuye.dao.CominfoDao;
import com.keda.wuye.dao.CommunityDao;
import com.keda.wuye.dao.RoomsDao;
import com.keda.wuye.dao.impl.CominfoDaoImpl;
import com.keda.wuye.dao.impl.CommunityDaoImpl;
import com.keda.wuye.dao.impl.RoomsDaoImpl;
import com.keda.wuye.entity.Cominfo;
import com.keda.wuye.entity.Community;
import com.keda.wuye.entity.Rooms;

public class CominfoBizImpl implements CominfoBiz {
	private CominfoDao  cominfoDao = new  CominfoDaoImpl();
	public List<Cominfo> getCominfo()
	{
		List<Cominfo> cominfo = cominfoDao.getCominfo();
		return cominfo;
	}
	
	//Ä£ºý²éÑ¯
	public List<Cominfo> select(String s)
	{
		List<Cominfo> cominfo = cominfoDao.select(s);
		return cominfo;
	}
	
	public void insertCominfo(String cominfo_id,String cominfo_bus,String cominfo_medical,String cominfo_news,String cominfo_weather,String cominfo_notice)
	{
		cominfoDao.insertCominfo(cominfo_id, cominfo_bus, cominfo_medical, cominfo_news, cominfo_weather, cominfo_notice);
	}
	public List<String> get_comid()
	{
		List<String> get_comid = cominfoDao.get_comid();
		return get_comid;
	}
	//ÅÐ¶Ï±àºÅÊÇ·ñÖØ¸´
	public boolean idEqual(String cominfo_id)
	{
		boolean b = cominfoDao.idEqual(cominfo_id);
		return b;
	}
	//É¾³ý
	public void deleteCominfo(String cominfo_id)
	{
		cominfoDao.deleteCominfo(cominfo_id);
	}
	//ÐÞ¸Ä
	public void updateCominfo(String cominfo_id,String cominfo_bus,String cominfo_medical,String cominfo_news,String cominfo_weather,String cominfo_notice)
	{
		cominfoDao.updateCominfo(cominfo_id, cominfo_bus, cominfo_medical, cominfo_news, cominfo_weather, cominfo_notice);
	}
	public Cominfo getCominfo(String id)
	{
		Cominfo cominfo = cominfoDao.getCominfo(id);
		return cominfo;
	}
}
