package com.yulin.dangdang.dao;

import java.util.List;

import com.yulin.dangdang.bean.Product;

public interface ItemDao {
	public List<Product> findAll(int id);
}
