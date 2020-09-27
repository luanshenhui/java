package com.market.dao;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Brand;

public interface BrandDAO {

	public void save(Brand brand);

	public void update(Brand brand);

	public void delete(Brand brand);

	public Brand getBrand(Brand brand);

	public Brand getBrand(Long id);

	/**
	 * 获得Brand的分页列表
	 * 
	 * @param pageBean
	 * @return
	 */
	public List<Brand> findPageInfoBrand(Brand brand, PageBean pageBean);

	public Integer getCount(Brand brand);
}
