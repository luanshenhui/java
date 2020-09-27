package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Fee;
import com.keda.wuye.entity.Rooms;

public interface FeeBiz {
	public List<Fee> getFee();
	//添加
	public void insertFee(String fee_id,String fee_comid,String fee_name,double fee_standard,String fee_date);
	//判断编号是否重复
	public boolean idEqual(String fee_id);
	//获取community表中的小区编号
	public List<String> get_comid();
	//删除
	public void deleteFee(String fee_id);
	//查询一条信息
	public Fee getFee(String id);
	//修改
	public void updateFee(String fee_id,String fee_comid,String fee_name,double fee_standard,String fee_date);
	//模糊查询
	public List<Fee> select(String s);

}
