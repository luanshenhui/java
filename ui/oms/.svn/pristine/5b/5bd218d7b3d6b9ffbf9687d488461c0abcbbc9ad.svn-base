package cn.rkylin.oms.system.shop.service;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageInfo;

import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.system.shop.dao.IShopDAO;
import cn.rkylin.oms.system.shop.domain.Shop;
import cn.rkylin.oms.system.shop.vo.ShopVO;

/**
 * 店铺管理服务实现
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:15
 */
@Service("shopService")
public class ShopServiceImpl extends ApolloService implements IShopService {

	/**
	 * 店铺数据访问
	 */
	@Autowired
	private IShopDAO shopDAO;
	
	//店铺验证策略（不同电商平台验证策略不一样）
	private ShopValidatingStrategy shopValidatingStrategy;

	public IShopDAO getShopDAO() {
		return shopDAO;
	}

	public void setShopDAO(IShopDAO shopDAO) {
		this.shopDAO = shopDAO;
	}

	public ShopValidatingStrategy getShopValidatingStrategy() {
		return shopValidatingStrategy;
	}

	public void setShopValidatingStrategy(ShopValidatingStrategy shopValidatingStrategy) {
		this.shopValidatingStrategy = shopValidatingStrategy;
	}

	/**
	 * 构造函数
	 */
	public ShopServiceImpl(){

	}
	
	/**
	 * 查询需要分单店铺
	 * 
	 * @param shopVO
	 */
	public PageInfo<ShopVO> findSplitShop(int page, int rows, ShopVO shopVO) throws Exception {
		PageInfo<ShopVO> shopVOList = findPage(page, rows, "pageSelectSplitShop", shopVO);
		return shopVOList;
	}

	/**
	 * 查询店铺
	 * 
	 * @param shopVO
	 */
	public PageInfo<ShopVO> findByWhere(int page, int rows, ShopVO shopVO) throws Exception {
		PageInfo<ShopVO> shopVOList = findPage(page, rows, "pageSelectShop", shopVO);
		return shopVOList;
	}

	/**
	 * 创建店铺
	 * 
	 * @param shopVO
	 */
	@Transactional
	@CachePut(value="shop", key="T(String).valueOf('shop:').concat(#shopVO.shopId)")
	public ShopVO insert(ShopVO shopVO) throws Exception{
		Shop shop = new Shop();
		BeanUtils.copyProperties(shopVO, shop);
		shopDAO.insert(shop);
		return shopVO;
	}

	/**
	 * 修改店铺
	 * 
	 * @param shopVO
	 */
	@Transactional
	@CachePut(value="shop", key="T(String).valueOf('shop:').concat(#shopVO.shopId)")
	public ShopVO update(ShopVO shopVO) throws Exception{
		Shop shop = new Shop();
		BeanUtils.copyProperties(shopVO, shop);
		shopDAO.update(shop);
		return shopVO;
	}

	/**
	 * 删除店铺
	 * 
	 * @param shopVO
	 */
	@Transactional
    @CacheEvict(value="shop", key="T(String).valueOf('shop:').concat(#shopVO.shopId)")
	public int delete(ShopVO shopVO) throws Exception{
		Shop shop = new Shop();
		BeanUtils.copyProperties(shopVO, shop);
		return shopDAO.delete(shop);
	}
    
    /**
     * 根据shopId获取shop
     * @param shopId
     * @return
     */
    @Cacheable(value="shop", key="T(String).valueOf('shop:').concat(#shopId)")
    public ShopVO getShopById (String shopId) throws Exception {
    	ShopVO returnShop = shopDAO.findById(shopId);
    	return returnShop;
    }

	/**
	 * 验证店铺
	 * 
	 * @param shopVO
	 */
	public int validate(ShopVO shopVO) throws Exception{
		return 0;
	}

	/**
	 * 启用店铺
	 * 
	 * @param shopId
	 */
	@Transactional
	@CacheEvict(value="shop", key="T(String).valueOf('shop:').concat(#shopId)")
	public int setEnable(String shopId) throws Exception{
		Shop shop = new Shop();
		shop.setShopId(shopId);
		return shopDAO.update(shop);
	}

	/**
	 * 禁用店铺
	 * 
	 * @param shopId
	 */
	@Transactional
	@CacheEvict(value="shop", key="T(String).valueOf('shop:').concat(#shopId)")
	public int setDisable(String shopId) throws Exception{
		Shop shop = new Shop();
		shop.setShopId(shopId);
		return shopDAO.update(shop);
	}
}