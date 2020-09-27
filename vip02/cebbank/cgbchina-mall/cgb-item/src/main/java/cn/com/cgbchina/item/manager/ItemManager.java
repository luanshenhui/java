/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.model.ItemModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

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
	 * @param itemModel
	 * @return
	 */
	public Integer update(ItemModel itemModel) {
		return itemDao.update(itemModel);
	}

	/**
	 * 根据单品code 删除单品（逻辑删除）
	 *
	 * @param code
	 * @author:tanliang
	 * @time:2016-6-14
	 */
	public boolean deleteItemByCode(String code) {
		Integer deleteResult = itemDao.deleteItemByCode(code);
		// 事物处理
		if (deleteResult != 1) {
			return Boolean.FALSE;
		}
		return Boolean.TRUE;
	}

	/**
	 * 编辑微信商品（更改排序）
	 *
	 * @param model
	 * @return
	 */
	public boolean editItemOrder(ItemModel model) {
		Integer editResult = itemDao.editItemOrder(model);
		// 事物处理
		if (editResult != 1) {
			return Boolean.FALSE;
		}
		return Boolean.TRUE;
	}
}
