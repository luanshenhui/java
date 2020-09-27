package com.keda.wuye.biz;

import java.util.List;

import com.keda.wuye.entity.Complaint;
import com.keda.wuye.entity.Houses;
import com.keda.wuye.entity.Repairs;

public interface ComplaintBiz {
	//显示所有信息
	public List<Complaint> getComplaint();
	//查询一条信息
	public Complaint getComplaint(String id);
	//添加
	public void insertComplaint(String complaint_id,String complaint_resid,String complaint_date,String complaint_matter,String complaint_dealperson,String complaint_way,String complaint_result);
	//修改
	public void updateComplaint(String complaint_id,String complaint_resid,String complaint_date,String complaint_matter,String complaint_dealperson,String complaint_way,String complaint_result);
	//删除
	public void deleteComplaint(String complaint_id);
	//判断编号是否重复
	public boolean idEqual(String complaint_id);
	//获取resident表中的小区编号
	public List<String> get_resiid();
	//模糊查询
	public List<Complaint> select(String s);
	
}
