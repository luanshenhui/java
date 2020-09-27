package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.CouponScaleDao;
import cn.com.cgbchina.item.dao.PointPoolDao;
import cn.com.cgbchina.item.model.CouponScaleModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by niufw on 16-3-18.
 */
@Transactional
@Component
public class CouponScaleManager {
	@Resource
	private CouponScaleDao couponScaleDao;

	/**
	 * 积分池编辑
	 *
	 * @param couponScaleModels
	 * @return
	 */
	public boolean update(List<CouponScaleModel> couponScaleModels) {
		boolean result = true;
		// 循环更新
		for (CouponScaleModel couponScaleModel : couponScaleModels) {
			boolean updateResult = couponScaleDao.update(couponScaleModel) == 1;
			result = result && updateResult;
		}
		return result;
	}

}
