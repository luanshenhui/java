package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.CarportBiz;
import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.dao.CarportDao;
import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.dao.impl.CarportDaoImpl;
import com.keda.wuye.dao.impl.HousesDaoImpl;
import com.keda.wuye.entity.Carport;
import com.keda.wuye.entity.Houses;

public class CarportBizImpl implements CarportBiz {
	private CarportDao carportDao = new CarportDaoImpl();
	//��ʾ������Ϣ
	public List<Carport> getCarport()
	{
		List<Carport> listCarport = carportDao.getCarport();
		return listCarport;
	}
	//��ѯһ����Ϣ
	public Carport getCarport(String id)
	{
		Carport carport = carportDao.getCarport(id);
		return carport;
	}
	//���
	public void insertCarport(String carport_id,String carport_resid,String carport_carnum,String carport_cartype,double carport_area)
	{
		carportDao.insertCarport(carport_id, carport_resid, carport_carnum, carport_cartype, carport_area);
	}
	//�޸�
	public void updateCarport(String carport_id,String carport_resid,String carport_carnum,String carport_cartype,double carport_area)
	{
		carportDao.updateCarport(carport_id, carport_resid, carport_carnum, carport_cartype, carport_area);
	}
	//ɾ��
	public void deleteCarport(String carport_id)
	{
		carportDao.deleteCarport(carport_id);
	}
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String carport_id)
	{
		boolean b = carportDao.idEqual(carport_id);
		return b;
	}
	//��ȡcommunity���е�С�����
	public List<String> get_resiid()
	{
		List<String> list_resiid = carportDao.get_resiid();
		return list_resiid;
	}
	//ģ����ѯ
	public List<Carport> select(String s)
	{
		List<Carport> listCarport = carportDao.select(s);
		return listCarport;
	}
	
}
