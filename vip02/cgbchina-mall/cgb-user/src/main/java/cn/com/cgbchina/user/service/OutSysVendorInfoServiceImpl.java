package cn.com.cgbchina.user.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.user.dao.ShopinfOutsystemDao;
import cn.com.cgbchina.user.model.ShopinfOutsystemModel;

@Service
public class OutSysVendorInfoServiceImpl implements OutSysVendorInfoService {

	@Resource
	private ShopinfOutsystemDao shopinfOutsystemDao;

	@Override
	public ShopinfOutsystemModel findMallKey() {
		return shopinfOutsystemDao.findMallKey();
	}

	@Override
	public ShopinfOutsystemModel findByVendorId(String vendorId) {
		return shopinfOutsystemDao.findByVendorId(vendorId);
	}

	@Override
	public ShopinfOutsystemModel findByOutSysId(String outSysId) {
		return shopinfOutsystemDao.findByOutSysId(outSysId);
	}

}
