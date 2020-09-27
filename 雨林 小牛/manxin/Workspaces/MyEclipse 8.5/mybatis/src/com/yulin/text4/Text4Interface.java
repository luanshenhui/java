package com.yulin.text4;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.yulin.text2.Dept;

public interface Text4Interface {
	@Select("select * from dept")
	public List<Dept> findAll();
	
	@Delete("delete from dept where dept_id = 101")
	public boolean deltet();
	
	@Insert("insert into dept values(105,'DF','JINZHOU')")
	public boolean insert();
	
	@Update("update dept set dname='ANSHAN' where dept_id=105")
	public boolean update();
}
