package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.spirit.common.model.Response;

import java.util.Map;

/**
 * @author
 * @version 1.0
 * @Since 2016/6/6.
 */
public interface GoodsPayWayService {

	/**
	 * 返回支付方式信息
	 *
	 * @return
	 */
	public Response<TblGoodsPaywayModel> findGoodsPayWayInfo(String goodsPaywayId);
	/**
	 * 通过单品ＩＤ和分期数查询返回支付方式信息
	 *
	 * @return
	 */
	public Response<TblGoodsPaywayModel> findByItemCodeAndStagesCode(Map<String, Object> params);
}
