package com.cebbank.ccis.cebmall.item.manager;

import com.cebbank.ccis.cebmall.item.dao.ItemDao;
import com.cebbank.ccis.cebmall.item.model.ItemModel;
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
}
