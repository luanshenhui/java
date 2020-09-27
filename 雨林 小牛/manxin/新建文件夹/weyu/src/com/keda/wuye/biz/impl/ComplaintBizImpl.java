package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.ComplaintBiz;
import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.RepairsBiz;
import com.keda.wuye.dao.ComplaintDao;
import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.dao.RepairsDao;
import com.keda.wuye.dao.impl.ComplaintDaoImpl;
import com.keda.wuye.dao.impl.HousesDaoImpl;
import com.keda.wuye.dao.impl.RepairsDaoImpl;
import com.keda.wuye.entity.Complaint;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Repairs;

public class ComplaintBizImpl implements ComplaintBiz {
	private ComplaintDao complaintDao = new ComplaintDaoImpl();
	//显示所有信息
	public List<Complaint> getComplaint()
	{
		List<Complaint> listComplaint = complaintDao.getComplaint();
		return listComplaint;
	}
	//模糊查询
	public List<Complaint> select(String s)
	{
		List<Complaint> listComplaint = complaintDao.select(s);
		return listComplaint;
	}
	//查询一条信息
	public Complaint getComplaint(String id)
	{
		Complaint complaint = complaintDao.getComplaint(id);
		return complaint;
	}
	//添加
	public void insertComplaint(String complaint_id,String complaint_resid,String complaint_date,String complaint_matter,String complaint_dealperson,String complaint_way,String complaint_result)
	{
		complaintDao.insertComplaint(complaint_id, complaint_resid, complaint_date, complaint_matter, complaint_dealperson, complaint_way, complaint_result);
	}
	//修改
	public void updateComplaint(String complaint_id,String complaint_resid,String complaint_date,String complaint_matter,String complaint_dealperson,String complaint_way,String complaint_result)
	{
		complaintDao.updateComplaint(complaint_id, complaint_resid, complaint_date, complaint_matter, complaint_dealperson, complaint_way, complaint_result);
	}
	//删除
	public void deleteComplaint(String complaint_id)
	{
		complaintDao.deleteComplaint(complaint_id);
	}
	//判断编号是否重复
	public boolean idEqual(String complaint_id)
	{
		boolean b = complaintDao.idEqual(complaint_id);
		return b;
	}
	//获取resident表中的小区编号
	public List<String> get_resiid()
	{
		List<String> list_resiid = complaintDao.get_resiid();
		return list_resiid;
	}
	
}
