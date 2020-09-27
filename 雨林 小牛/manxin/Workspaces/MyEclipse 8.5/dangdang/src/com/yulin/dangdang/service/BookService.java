package com.yulin.dangdang.service;

import java.util.List;

import com.yulin.dangdang.bean.Book;
import com.yulin.dangdang.bean.Product;
import com.yulin.dangdang.dao.BookDao;
import com.yulin.dangdang.dao.daoimpl.BookImpl;

public class BookService {
	public List<Book> findBookById(int id){
		BookDao bd = new BookImpl();
		return bd.findBookById(id);
	}
	public static void main(String[] args) {
		BookService bs = new BookService();
		List<Book> list = bs.findBookById(1);
		System.out.println(list);
	}
}
