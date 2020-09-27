package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Pay;

public interface PayBiz {

	//显示所有信息
	public List<Pay> getPay();
	//查询一条信息
	public Pay getPay(String id);
	//添加
	public void insertPay(String pay_id,String pay_resid,String pay_feeid,double pay_number,String pay_date,double pay_overdue);
	//修改
	public void updatePay(String pay_id,String pay_resid,String pay_feeid,double pay_number,String pay_date,double pay_overdue);
	//删除
	public void deletePay(String pay_id);
	//判断编号是否重复
	public boolean idEqual(String pay_id);
	//获取resident表中的住户编号
	public List<String> get_resiid();
	//获取fee表中的费用编号
	public List<String> get_feeid();
	//显示所有信息
	public List<Pay> select(String s);
	
}
