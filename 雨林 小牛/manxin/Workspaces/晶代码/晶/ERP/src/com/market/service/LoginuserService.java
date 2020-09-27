package com.market.service;

import java.util.List;

import com.market.util.PageBean;
import com.market.vo.Loginuser;

public interface LoginuserService {
	public void save(Loginuser loginuser);

	public void update(Loginuser loginuser);

	public void delete(Loginuser loginuser);

	public Loginuser getLoginuser(Loginuser loginuser);

	public Loginuser getLoginuser(Long id);

	public List<Loginuser> findPageInfoLoginuser(Loginuser loginuser,
			PageBean pageBean);

	public Integer getCount(Loginuser loginuser);

	public List<Loginuser> findPageInfoLoginuser1(Loginuser loginuser,
			PageBean pageBean);

	public Integer getCount1(Loginuser loginuser);
}
