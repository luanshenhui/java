package com.yulin.dangdang.dao.daoimpl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.yulin.dangdang.bean.Product;
import com.yulin.dangdang.common.MyBatisUtil;
import com.yulin.dangdang.dao.ItemDao;

public class ItemDaoImpl implements ItemDao{

	//详细信息
	private String namespace = "com.yulin.byMapping";
	@Override
	public List<Product> findAll(int id) {
		SqlSession session = MyBatisUtil.getSession();
		List<Product> list = session.selectList(namespace + ".findAll", id);
		return list;
	}
	
	public static void main(String[] args) {
		ItemDaoImpl idi = new ItemDaoImpl();
		List<Product> list = idi.findAll(3);

		System.out.println(list);
	}
	
}
