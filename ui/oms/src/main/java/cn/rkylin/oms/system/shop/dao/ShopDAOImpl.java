package cn.rkylin.oms.system.shop.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.system.shop.domain.Shop;
import cn.rkylin.oms.system.shop.vo.ShopVO;

/**
 * 店铺数据访问层
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:13
 */
@Repository(value = "shopDAO")
public class ShopDAOImpl implements IShopDAO {
	// 常量定义
	private static final String STMT_DELETE_SHOP = "deleteByPrimaryKeyShop";
	private static final String STMT_UPDATE_SHOP = "updateByPrimaryKeySelectiveShop";
	private static final String STMT_INSERT_SHOP = "insertShop";
	
	@Autowired
	protected IDataBaseFactory dao;

	/**
	 * 构造函数
	 */
	public ShopDAOImpl(){

	}

	/**
	 * 查询店铺
	 * 
	 * @param shopVO
	 */
	public List<ShopVO> findByWhere(ShopVO shopVO){
		return null;
	}
	
	/**
	 * 获取店铺明细
	 * 
	 * @param shopVO
	 */
	public ShopVO findById(String shopId) throws Exception {
		List<ShopVO> resultList = dao.findList("selectByPrimaryKeyShop", shopId);
		if (resultList != null && resultList.size() > 0) {
			return resultList.get(0);
		}
		return null;
	}

	/**
	 * 创建店铺
	 * 
	 * @param shop
	 */
	public int insert(Shop shop) throws Exception{
		return dao.insert(STMT_INSERT_SHOP, shop);
	}

	/**
	 * 修改店铺
	 * 
	 * @param shop
	 */
	public int update(Shop shop) throws Exception{
		return dao.update(STMT_UPDATE_SHOP, shop);
	}

	/**
	 * 删除店铺
	 * 
	 * @param shop
	 */
	public int delete(Shop shop) throws Exception{
		return dao.delete(STMT_DELETE_SHOP, shop.getShopId());
	}

}