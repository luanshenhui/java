package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.model.ShopinfOutsystemModel;

public interface OutSysVendorInfoService {
	/**
	 * 
	 * Description :获取商城的key
	 * 
	 * @return
	 */
	public ShopinfOutsystemModel findMallKey();

	/**
	 * 
	 * Description : 获取供应商信息
	 * 
	 * @param vendorId
	 * @return
	 */
	public ShopinfOutsystemModel findByVendorId(String vendorId);

	/**
	 * 
	 * Description : 根据外系统id获取供应商信息
	 * 
	 * @param outSysId
	 * @return
	 */
	public ShopinfOutsystemModel findByOutSysId(String outSysId);
}
