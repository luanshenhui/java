package com.market.service;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Brand;

public interface BrandService {
	public void save(Brand brand);

	public void update(Brand brand);

	public void delete(Brand brand);

	public Brand getBrand(Brand brand);

	public Brand getBrand(Long id);

	public List<Brand> findPageInfoBrand(Brand brand, PageBean pageBean);

	public Integer getCount(Brand brand);
}
