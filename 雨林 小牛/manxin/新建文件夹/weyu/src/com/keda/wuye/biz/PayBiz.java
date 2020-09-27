package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Pay;

public interface PayBiz {

	//��ʾ������Ϣ
	public List<Pay> getPay();
	//��ѯһ����Ϣ
	public Pay getPay(String id);
	//���
	public void insertPay(String pay_id,String pay_resid,String pay_feeid,double pay_number,String pay_date,double pay_overdue);
	//�޸�
	public void updatePay(String pay_id,String pay_resid,String pay_feeid,double pay_number,String pay_date,double pay_overdue);
	//ɾ��
	public void deletePay(String pay_id);
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String pay_id);
	//��ȡresident���е�ס�����
	public List<String> get_resiid();
	//��ȡfee���еķ��ñ��
	public List<String> get_feeid();
	//��ʾ������Ϣ
	public List<Pay> select(String s);
	
}
