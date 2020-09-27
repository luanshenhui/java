package cn.rkylin.oms.system.shop.service;

import com.github.pagehelper.PageInfo;

import cn.rkylin.oms.system.shop.domain.Shop;
import cn.rkylin.oms.system.shop.vo.ShopVO;

/**
 * 店铺服务层接口
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:13
 */
public interface IShopService {

	/**
	 * 查询需要分单的店铺
	 * 
	 * @param shopVO
	 * @throws Exception 
	 */
	public PageInfo<ShopVO> findSplitShop(int page, int rows, ShopVO shopVO) throws Exception;

	
	/**
	 * 查询店铺
	 * 
	 * @param shopVO
	 * @throws Exception 
	 */
	public PageInfo<ShopVO> findByWhere(int page, int rows, ShopVO shopVO) throws Exception;
	
	/**
     * 根据shopId获取shop
     * @param shopId
     * @return
     */
    public ShopVO getShopById (String shopId) throws Exception;
    
	/**
	 * 创建店铺
	 * 
	 * @param shopVO
	 */
	public ShopVO insert(ShopVO shopVO) throws Exception;

	/**
	 * 修改店铺
	 * 
	 * @param shopVO
	 */
	public ShopVO update(ShopVO shopVO) throws Exception;

	/**
	 * 删除店铺
	 * 
	 * @param shopVO
	 */
	public int delete(ShopVO shopVO) throws Exception;

	/**
	 * 删除店铺
	 * 
	 * @param shopVO
	 */
	public int validate(ShopVO shopVO) throws Exception;

	/**
	 * 启用店铺
	 * 
	 * @param shopId
	 */
	public int setEnable(String shopId) throws Exception;

	/**
	 * 禁用店铺
	 * 
	 * @param shopId
	 */
	public int setDisable(String shopId) throws Exception;

}