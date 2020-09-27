package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Carport;
import com.keda.wuye.entity.Houses;

public interface CarportBiz {

	//显示所有信息
	public List<Carport> getCarport();
	//查询一条信息
	public Carport getCarport(String id);
	//添加
	public void insertCarport(String carport_id,String carport_resid,String carport_carnum,String carport_cartype,double carport_area);
	//修改
	public void updateCarport(String carport_id,String carport_resid,String carport_carnum,String carport_cartype,double carport_area);
	//删除
	public void deleteCarport(String carport_id);
	//判断编号是否重复
	public boolean idEqual(String carport_id);
	//获取community表中的小区编号
	public List<String> get_resiid();
	//模糊查询
	public List<Carport> select(String s);
}
