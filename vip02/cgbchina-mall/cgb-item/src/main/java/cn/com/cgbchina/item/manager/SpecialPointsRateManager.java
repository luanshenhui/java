/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.SpecialPointScaleDao;
import cn.com.cgbchina.item.model.SpecialPointScaleModel;
import com.spirit.common.model.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 2016/05/31
 */
@Component
@Transactional
public class SpecialPointsRateManager {
	@Autowired
	private SpecialPointScaleDao specialPointScaleDao;

	public boolean delete(SpecialPointScaleModel specialPointScaleModel) {
		return specialPointScaleDao.delete(specialPointScaleModel) == 1;
	}

	/**
	 * 批量特殊积分倍率删除
	 *
	 * @param
	 * @return
	 */
	public Integer updateAllRejectGoods(Map<String, Object> paramMap) {
		return specialPointScaleDao.deleteAll(paramMap);
	}

	public boolean create(SpecialPointScaleModel specialPointScaleModel) {
		return specialPointScaleDao.insert(specialPointScaleModel) == 1;
	}

	public boolean update(SpecialPointScaleModel specialPointScaleModel) {
		return specialPointScaleDao.update(specialPointScaleModel) == 1;
	}

	/**
	 * 根据type和typeId进行更新
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	public boolean updateByTypeId(SpecialPointScaleModel specialPointScaleModel) {
		boolean result = specialPointScaleDao.updateByTypeId(specialPointScaleModel) == 1;
		return result;
	}
}
