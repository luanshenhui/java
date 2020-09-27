package com.yulin.dangdang.dao;

import java.util.List;

import com.yulin.dangdang.bean.Product;
import com.yulin.dangdang.bean.SearchKey;

public interface SerachDao {
	public List<Product> keyWord(SearchKey search);
}
