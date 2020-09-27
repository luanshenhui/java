package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.HousesBiz;
import com.keda.wuye.biz.PayBiz;
import com.keda.wuye.dao.HousesDao;
import com.keda.wuye.dao.PayDao;
import com.keda.wuye.dao.impl.HousesDaoImpl;
import com.keda.wuye.dao.impl.PayDaoImpl;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Pay;

public class PayBizImpl implements PayBiz {
	private PayDao payDao = new PayDaoImpl();
	//��ʾ������Ϣ
	public List<Pay> getPay()
	{
		List<Pay> listPay = payDao.getPay();
		return listPay;
	}
	//��ʾ������Ϣ
	public List<Pay> select(String s)
	{
		List<Pay> listPay = payDao.select(s);
		return listPay;
	}
	//��ѯһ����Ϣ
	public Pay getPay(String id)
	{
		Pay pay = payDao.getPay(id);
		return pay;
	}
	//���
	public void insertPay(String pay_id,String pay_resid,String pay_feeid,double pay_number,String pay_date,double pay_overdue)
	{
		payDao.insertPay(pay_id, pay_resid, pay_feeid, pay_number, pay_date, pay_overdue);
	}
	//�޸�
	public void updatePay(String pay_id,String pay_resid,String pay_feeid,double pay_number,String pay_date,double pay_overdue)
	{
		payDao.updatePay(pay_id, pay_resid, pay_feeid, pay_number, pay_date, pay_overdue);
	}
	//ɾ��
	public void deletePay(String pay_id)
	{
		payDao.deletePay(pay_id);
	}
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String pay_id)
	{
		boolean b = payDao.idEqual(pay_id);
		return b;
	}
	//��ȡresident���е�ס�����
	public List<String> get_resiid()
	{
		List<String> list_resiid = payDao.get_resiid();
		return list_resiid;
	}
	//��ȡfee���еķ��ñ��
	public List<String> get_feeid()
	{
		List<String> list_feeid = payDao.get_feeid();
		return list_feeid;
	}
}
