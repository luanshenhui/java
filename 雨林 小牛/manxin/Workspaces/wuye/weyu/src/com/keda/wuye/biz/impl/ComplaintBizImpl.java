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
	//��ʾ������Ϣ
	public List<Complaint> getComplaint()
	{
		List<Complaint> listComplaint = complaintDao.getComplaint();
		return listComplaint;
	}
	//ģ����ѯ
	public List<Complaint> select(String s)
	{
		List<Complaint> listComplaint = complaintDao.select(s);
		return listComplaint;
	}
	//��ѯһ����Ϣ
	public Complaint getComplaint(String id)
	{
		Complaint complaint = complaintDao.getComplaint(id);
		return complaint;
	}
	//���
	public void insertComplaint(String complaint_id,String complaint_resid,String complaint_date,String complaint_matter,String complaint_dealperson,String complaint_way,String complaint_result)
	{
		complaintDao.insertComplaint(complaint_id, complaint_resid, complaint_date, complaint_matter, complaint_dealperson, complaint_way, complaint_result);
	}
	//�޸�
	public void updateComplaint(String complaint_id,String complaint_resid,String complaint_date,String complaint_matter,String complaint_dealperson,String complaint_way,String complaint_result)
	{
		complaintDao.updateComplaint(complaint_id, complaint_resid, complaint_date, complaint_matter, complaint_dealperson, complaint_way, complaint_result);
	}
	//ɾ��
	public void deleteComplaint(String complaint_id)
	{
		complaintDao.deleteComplaint(complaint_id);
	}
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String complaint_id)
	{
		boolean b = complaintDao.idEqual(complaint_id);
		return b;
	}
	//��ȡresident���е�С�����
	public List<String> get_resiid()
	{
		List<String> list_resiid = complaintDao.get_resiid();
		return list_resiid;
	}
	
}
