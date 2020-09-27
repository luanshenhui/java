package com.yulin.dangdang.dao.daoimpl;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.yulin.dangdang.bean.Book;
import com.yulin.dangdang.common.MyBatisUtil;
import com.yulin.dangdang.dao.BookDao;

public class BookImpl implements BookDao{

	private String namespace = "com.yulin.cateMapping";
	@Override
	public List<Book> findBookById(int id) {
		List<Book> list = new ArrayList<Book>();
		SqlSession session = MyBatisUtil.getSession();
		list = session.selectList(namespace + ".findBook", id);
		return list;
	}
	
	public static void main(String[] args) {
		BookImpl bi = new BookImpl();
		List<Book> list = bi.findBookById(1);
		System.out.println(list);
	}

}
