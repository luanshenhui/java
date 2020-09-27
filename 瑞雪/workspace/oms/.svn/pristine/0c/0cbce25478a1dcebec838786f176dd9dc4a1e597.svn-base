package cn.rkylin.oms.system.shop.dao;

import java.util.List;

import cn.rkylin.oms.system.shop.domain.Shop;
import cn.rkylin.oms.system.shop.vo.ShopVO;

/**
 * 店铺数据访问层接口
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:13
 */
public interface IShopDAO {

	/**
	 * 查询店铺
	 * 
	 * @param shopVO
	 */
	public List<ShopVO> findByWhere(ShopVO shopVO) throws Exception;

	/**
	 * 获取店铺明细
	 * 
	 * @param shopVO
	 */
	public ShopVO findById(String shopId) throws Exception;

	/**
	 * 创建店铺
	 * 
	 * @param shop
	 * @throws Exception 
	 */
	public int insert(Shop shop) throws Exception;

	/**
	 * 修改店铺
	 * 
	 * @param shop
	 */
	public int update(Shop shop) throws Exception;

	/**
	 * 删除店铺
	 * 
	 * @param shop
	 */
	public int delete(Shop shop) throws Exception;

}