package com.yulin.lsh;

import java.util.List;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		DAO dao=new DAOImpl();
		
		Member member=new Member("张三",30);
		//添加(使用序列生成主键)
		dao.add(member); 
		//根据名字查询员工(假设员工姓名唯一)
		member=dao.getMemberByName("张三");
		//更改员工
		member.setName("李四");
		member.setAge(40);
		dao.update(member);
//		删除
//		dao.delete(member);
//		//查所有
		List<Member>list=dao.getAll();
		System.out.println(list);
	}

}
