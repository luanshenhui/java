package com.keda.wuye.biz.impl;

import java.util.List;

import com.keda.wuye.biz.FeeBiz;
import com.keda.wuye.biz.RoomsBiz;
import com.keda.wuye.dao.FeeDao;
import com.keda.wuye.dao.RoomsDao;
import com.keda.wuye.dao.impl.FeeDaoImpl;
import com.keda.wuye.dao.impl.RoomsDaoImpl;
import com.keda.wuye.entity.Fee;
import com.keda.wuye.entity.Rooms;

public class FeeBizImpl implements FeeBiz {
	private FeeDao feeDao = new FeeDaoImpl();
	//��ʾ������Ϣ
	public List<Fee> getFee()
	{
		List<Fee> listFee = feeDao.getFee();
		return listFee;
	}
	
	//ģ����ѯ
	public List<Fee> select(String s)
	{
		List<Fee> listFee = feeDao.select(s);
		return listFee;
	}
	//���
	public void insertFee(String fee_id,String fee_comid,String fee_name,double fee_standard,String fee_date)
	{
		feeDao.insertFee(fee_id, fee_comid, fee_name, fee_standard, fee_date);
	}
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String fee_id)
	{
		boolean b = feeDao.idEqual(fee_id);
		return b;
	}
	//��ȡcommunity���е�С�����
	public List<String> get_comid()
	{
		List<String> list_comid = feeDao.get_comid();
		return list_comid;
	}
	//ɾ��
	public void deleteFee(String fee_id)
	{
		feeDao.deleteFee(fee_id);
	}
	//��ѯһ����Ϣ
	public Fee getFee(String id)
	{
		Fee fee = feeDao.getFee(id);
		return fee;
	}
	//�޸�
	public void updateFee(String fee_id,String fee_comid,String fee_name,double fee_standard,String fee_date)
	{
		feeDao.updateFee(fee_id, fee_comid, fee_name, fee_standard, fee_date);
	}
}
