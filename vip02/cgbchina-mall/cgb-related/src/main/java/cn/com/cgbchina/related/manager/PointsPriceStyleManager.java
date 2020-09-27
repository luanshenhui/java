/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.manager;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cn.com.cgbchina.related.dao.CfgPriceSystemDao;
import cn.com.cgbchina.related.dao.TblConfigDao;
import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import cn.com.cgbchina.related.model.TblConfigModel;

/**
 * @author niufw
 * @version 1.0
 * @Since 16-08-10.
 */
@Component
@Transactional
public class PointsPriceStyleManager {
	@Resource
	private CfgPriceSystemDao cfgPriceSystemDao;
	@Resource
	private TblConfigDao tblConfigDao;

	/**
	 * 价格体系维护-金普卡积分系数-新增 niufw
	 *
	 * @param cfgPriceSystemModel
	 * @return
	 */
	public boolean create(CfgPriceSystemModel cfgPriceSystemModel) {
		boolean result = cfgPriceSystemDao.insert(cfgPriceSystemModel) == 1;
		return result;
	}

	/**
	 * 价格体系维护-编辑 niufw
	 *
	 * @param cfgPriceSystemModel
	 * @return
	 */
	public boolean update(CfgPriceSystemModel cfgPriceSystemModel) {
		boolean result = cfgPriceSystemDao.update(cfgPriceSystemModel) == 1;
		return result;
	}

	/**
	 * 价格体系维护-金普卡积分系数-删除 niufw
	 *
	 * @param cfgPriceSystemModel
	 * @return
	 */
	public boolean updateForDel(CfgPriceSystemModel cfgPriceSystemModel) {
		boolean result = cfgPriceSystemDao.updateForDel(cfgPriceSystemModel) == 1;
		return result;
	}

	/**
	 * 价格体系维护-采购价上浮系数-编辑 niufw
	 *
	 * @param tblConfigModel
	 * @return
	 */
	public boolean purchaseUpdate(TblConfigModel tblConfigModel) {
		boolean result = tblConfigDao.purchaseUpdate(tblConfigModel) == 1;
		return result;
	}
}
