package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.RepairsBiz;
import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.dao.RepairsDao;
import com.keda.wuye.dao.impl.HousesDaoImpl;
import com.keda.wuye.dao.impl.RepairsDaoImpl;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Repairs;

public class RepairsBizImpl implements RepairsBiz {
	private RepairsDao repairsDao = new RepairsDaoImpl();
	//显示所有信息
	public List<Repairs> getRepairs()
	{
		List<Repairs> listRepairs = repairsDao.getRepairs();
		return listRepairs;
	}
	//显示所有信息
	public List<Repairs> select(String s)
	{
		List<Repairs> listRepairs = repairsDao.select(s);
		return listRepairs;
	}
	//查询一条信息
	public Repairs getRepairs(String id)
	{
		Repairs repairs = repairsDao.getRepairs(id);
		return repairs;
	}
	//添加
	public void insertRepairs(String repairs_id,String repairs_plantid,String repairs_date,String repairs_reason,String repairs_way,String repairs_person,String repairs_result)
	{
		repairsDao.insertRepairs(repairs_id, repairs_plantid, repairs_date, repairs_reason, repairs_way, repairs_person, repairs_result);
	}
	//修改
	public void updateRepairs(String repairs_id,String repairs_plantid,String repairs_date,String repairs_reason,String repairs_way,String repairs_person,String repairs_result)
	{
		repairsDao.updateRepairs(repairs_id, repairs_plantid, repairs_date, repairs_reason, repairs_way, repairs_person, repairs_result);
	}
	//删除
	public void deleteRepairs(String repairs_id)
	{
		repairsDao.deleteRepairs(repairs_id);
	}
	//判断编号是否重复
	public boolean idEqual(String repairs_id)
	{
		boolean b = repairsDao.idEqual(repairs_id);
		return b;
	}
	//获取plant表中的小区编号
	public List<String> get_plantid()
	{
		List<String> list_plantid = repairsDao.get_plantid();
		return list_plantid;
	}
	
}
