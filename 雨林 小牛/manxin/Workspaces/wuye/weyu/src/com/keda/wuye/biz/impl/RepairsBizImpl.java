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
	//��ʾ������Ϣ
	public List<Repairs> getRepairs()
	{
		List<Repairs> listRepairs = repairsDao.getRepairs();
		return listRepairs;
	}
	//��ʾ������Ϣ
	public List<Repairs> select(String s)
	{
		List<Repairs> listRepairs = repairsDao.select(s);
		return listRepairs;
	}
	//��ѯһ����Ϣ
	public Repairs getRepairs(String id)
	{
		Repairs repairs = repairsDao.getRepairs(id);
		return repairs;
	}
	//���
	public void insertRepairs(String repairs_id,String repairs_plantid,String repairs_date,String repairs_reason,String repairs_way,String repairs_person,String repairs_result)
	{
		repairsDao.insertRepairs(repairs_id, repairs_plantid, repairs_date, repairs_reason, repairs_way, repairs_person, repairs_result);
	}
	//�޸�
	public void updateRepairs(String repairs_id,String repairs_plantid,String repairs_date,String repairs_reason,String repairs_way,String repairs_person,String repairs_result)
	{
		repairsDao.updateRepairs(repairs_id, repairs_plantid, repairs_date, repairs_reason, repairs_way, repairs_person, repairs_result);
	}
	//ɾ��
	public void deleteRepairs(String repairs_id)
	{
		repairsDao.deleteRepairs(repairs_id);
	}
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String repairs_id)
	{
		boolean b = repairsDao.idEqual(repairs_id);
		return b;
	}
	//��ȡplant���е�С�����
	public List<String> get_plantid()
	{
		List<String> list_plantid = repairsDao.get_plantid();
		return list_plantid;
	}
	
}
