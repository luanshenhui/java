package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Repairs;

public interface RepairsBiz {
	//显示所有信息
	public List<Repairs> getRepairs();
	//查询一条信息
	public Repairs getRepairs(String id);
	//添加
	public void insertRepairs(String repairs_id,String repairs_plantid,String repairs_date,String repairs_reason,String repairs_way,String repairs_person,String repairs_result);
	//修改
	public void updateRepairs(String repairs_id,String repairs_plantid,String repairs_date,String repairs_reason,String repairs_way,String repairs_person,String repairs_result);
	//删除
	public void deleteRepairs(String repairs_id);
	//判断编号是否重复
	public boolean idEqual(String repairs_id);
	//获取plant表中的小区编号
	public List<String> get_plantid();
	//显示所有信息
	public List<Repairs> select(String s);
}
