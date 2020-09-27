/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.SpecialPointScaleModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 2016/05/31
 */
public interface SpecialPointsRateService {
	/**
	 * 分页查询特殊积分倍率
	 *
	 * @param pageNo
	 * @param size
	 * @return
	 */
	public Response<Pager<SpecialPointScaleModel>> findAll(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size);

	/**
	 * 删除特殊积分倍率
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	public Response<Boolean> delete(SpecialPointScaleModel specialPointScaleModel);

	/**
	 * 批量特殊积分倍率删除
	 *
	 * @param deteleAllSpecial
	 * @return
	 */
	public Response<Integer> updateAllRejectGoods(List<Long> deteleAllSpecial);

	/**
	 * 添加特殊积分倍率
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	public Response<Boolean> create(SpecialPointScaleModel specialPointScaleModel);

	/**
	 * 更新特殊积分倍率
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	public Response<Boolean> update(SpecialPointScaleModel specialPointScaleModel);

	/**
	 * 计算最佳倍率
	 * @param goodsModel
	 * @return
	 */
	public Response<BigDecimal> calculateBestRate(GoodsModel goodsModel);

	/**
	 * 查询商品是否显示全积分比例兑换
	 * @param goodsId 单品id
	 * @return 是否显示
	 *
	 * geshuo 20160816
	 */
	public Response<Boolean> findDisplayFlag(String goodsId);

}
