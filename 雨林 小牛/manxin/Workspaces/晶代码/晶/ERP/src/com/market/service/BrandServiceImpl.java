package com.market.service;

import java.util.List;

import com.market.dao.BrandDAO;
import com.market.util.PageBean;
import com.market.vo.Brand;

public class BrandServiceImpl implements BrandService {
	private BrandDAO brandDAO;

	public void save(Brand brand) {
		brandDAO.save(brand);
	}

	public void update(Brand brand) {
		brandDAO.update(brand);
	}

	public Brand getBrand(Brand brand) {
		return brandDAO.getBrand(brand);
	}

	public Brand getBrand(Long id) {
		return brandDAO.getBrand(id);
	}

	public void delete(Brand brand) {
		brandDAO.delete(brand);
	}

	public List<Brand> findPageInfoBrand(Brand brand, PageBean pageBean) {
		return brandDAO.findPageInfoBrand(brand, pageBean);
	}

	public Integer getCount(Brand brand) {
		return brandDAO.getCount(brand);
	}

	public void setBrandDAO(BrandDAO brandDAO) {
		this.brandDAO = brandDAO;
	}
}
