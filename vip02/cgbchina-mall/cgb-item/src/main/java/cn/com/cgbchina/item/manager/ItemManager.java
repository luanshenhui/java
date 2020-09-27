/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.PromotionRedisDao;
import cn.com.cgbchina.item.model.ItemModel;
import com.google.common.collect.Maps;
import com.spirit.user.User;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author A11150921050273
 * @version 1.0
 * @Since 2016/5/31.
 */
@Component
@Transactional
public class ItemManager {
	@Resource
	private ItemDao itemDao;
	@Resource
	private PromotionRedisDao promotionRedisDao;
	@Resource
	private PointPoolManager pointPoolManager;

	/**
	 * 更新单品信息
	 *
	 * @param itemModel item 缺省更新
	 * @return Integer
	 */
	public Integer update(ItemModel itemModel) {
		return  itemDao.update(itemModel);
	}

	public Integer updateWxOrder(ItemModel itemModel) {
		return itemDao.updateWxOrder(itemModel);
	}
//	public Integer updateItem(ItemModel itemModel){
//		Integer i = itemDao.update(itemModel);
//		return i;
//	}



	public Integer updateItemTotal(ItemModel itemModel){
		return itemDao.updateItemTotal(itemModel);
	}

	/**
	 * 批量更新单品信息
	 * @param map
	 * @param user
	 * @return
	 */
	public Integer updateBatchStock(Map<String, Integer> map, User user) {
		int ret = 0;
		for (String code : map.keySet()) {
			ret = itemDao.updateBatchStock(code, map.get(code), user.getId());
			if (ret <= 0) {
				throw new RuntimeException("库存回滚失败");
			}
		}
		return ret;
	}

	/**
	 * 批量更新单品信息
	 *
	 * @param itemModelList
	 * @return
	 */
	public Boolean updateBatchStock(List<ItemModel> itemModelList) {
		itemDao.updateBatchStock(itemModelList);
		return Boolean.TRUE;
	}
	/**
	 * MAL502 回滚库存 niufw
	 * 
	 * @param itemModel
	 * @return
	 */
	public Boolean rollbackBacklogByNum(ItemModel itemModel) {
		boolean result = itemDao.rollbackBacklogByNum(itemModel) == 1;
		return result;
	}

	/**
	 * MAL115 减库存
	 * @param itemModel
	 * @return
	 */
	public Integer subtractStock(ItemModel itemModel) {
		Integer i = itemDao.subtractStock(itemModel);
		return i;
	}

	/**
	 * 更新库存
	 *
	 * @param itemModelMap
	 * @return
	 */
	@Transactional
	public Integer updateStock(Map<String, Long> itemModelMap) {
		int ret = 1;
		for (String itemCd : itemModelMap.keySet()) {
			if (itemModelMap.get(itemCd) == -1L) continue;
			ret = itemDao.updateStockForOrder(itemCd, itemModelMap.get(itemCd));
			if (ret <= 0) {
				throw new RuntimeException("更新库存失败");
			}
		}
		return  ret;
	}


	/**
	 * 批量更新单品信息
	 * @param map
	 * @param user
	 * @return
	 */
	public Integer updateRollBackStockForJF(Map<String, Integer> map, User user) {
		int ret = 0;
		for (String code : map.keySet()) {
			ret = itemDao.updateRollBackStockForJF(code, map.get(code), user.getId());
			if (ret < 0) {
				throw new RuntimeException("库存回滚失败");
			}
		}
		return ret;
	}

	/**
	 * 批量更新单品
	 *
	 * @param itemModelList itemModel集合
	 * @return Integer 影响行数
	 */
	public Integer batchUpdateItemInfo(List<ItemModel> itemModelList) {
		return itemDao.batchUpdateItemInfo(itemModelList);
	}

	/**
	 * 删除微信推荐顺序
	 */
	public Integer deleteItemWechate(String itemCode){
		return itemDao.deleteWechateWxOrder(itemCode);
	}

	@Transactional
	public void updateStockForOrderTrade(String actId,String actType, Integer periodId, String goodsId, Integer goodsNum, String createOper, Long bonusTotalvalue, ItemModel itemModel) {
		if (null == actId || "".equals(actId)){
			itemModel.setStock(itemModel.getStock()+1L); // 库存+1
			update(itemModel);
		}else {
			// 判断活动，荷兰拍回滚，其他活动不回滚。。。
			if (Contants.PROMOTION_PROM_TYPE_STRING_50.equals(actType)){
				String promId = actId;// 活动id
				String periodid = String.valueOf(periodId);
				String buyCount = "-" + String.valueOf(goodsNum); //回滚库存，减销量，所以传负数
				User user = new User();
				user.setId(createOper);
				promotionRedisDao.insertPromSaleInfo(promId, periodid, goodsId, buyCount,  user);
			}
		}

		if(null != bonusTotalvalue && bonusTotalvalue!=0){ //回滚积分池
			Map<String,Object> params = Maps.newHashMap();
			params.put("used_point",bonusTotalvalue);
			params.put("cur_month", DateHelper.getyyyyMM());
			pointPoolManager.dealPointPool(params);
		}
	}
}
