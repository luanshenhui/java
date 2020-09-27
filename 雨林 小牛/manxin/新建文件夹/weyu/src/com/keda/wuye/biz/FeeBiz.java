package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Fee;
import com.keda.wuye.entity.Rooms;

public interface FeeBiz {
	public List<Fee> getFee();
	//���
	public void insertFee(String fee_id,String fee_comid,String fee_name,double fee_standard,String fee_date);
	//�жϱ���Ƿ��ظ�
	public boolean idEqual(String fee_id);
	//��ȡcommunity���е�С�����
	public List<String> get_comid();
	//ɾ��
	public void deleteFee(String fee_id);
	//��ѯһ����Ϣ
	public Fee getFee(String id);
	//�޸�
	public void updateFee(String fee_id,String fee_comid,String fee_name,double fee_standard,String fee_date);
	//ģ����ѯ
	public List<Fee> select(String s);

}
