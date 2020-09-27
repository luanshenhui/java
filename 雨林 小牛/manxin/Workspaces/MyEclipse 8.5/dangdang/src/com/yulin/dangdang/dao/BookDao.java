package com.yulin.dangdang.dao;

import java.util.List;

import com.yulin.dangdang.bean.Book;

public interface BookDao {
	/**
	 * 通过P_id获得图书的信息
	 * @param id 分类列表的id
	 * @return 图书的详细信息
	 */
	public List<Book> findBookById(int id);
}
