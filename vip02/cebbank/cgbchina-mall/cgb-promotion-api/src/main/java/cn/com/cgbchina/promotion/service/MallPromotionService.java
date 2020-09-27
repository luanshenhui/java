package cn.com.cgbchina.promotion.service;

import cn.com.cgbchina.promotion.dto.GoodsGroupBuyDto;
import cn.com.cgbchina.promotion.dto.MallPromotionResultDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;
import java.util.Map;


public interface MallPromotionService {

	/**
	 * 获取广发团信息
	 *
	 * @return
	 *
	 * geshuo 20160704
	 */
	public Response<Map<String,Object>> findGroupBuyData(@Param("ids") List<Long> ids);

	/**
	 * 根据类目id查询商品列表
	 *
	 * @return
	 *
	 * geshuo 20160705
	 */
	public Response<List<GoodsGroupBuyDto>> findGroupBuyGoodsByCategory(List<Integer> promotionIdList, Long categoryId);

	/**
	 * 根据活动ID 获取活动基本信息和活动选品集合（List）
	 *
	 * @param promId 活动ID
	 * @return
	 * wangqi 20160713
	 */
	public Response<MallPromotionResultDto> findPromotionByPromId(String promId);

	/**
	 * 取得正在进行或即将开始的活动
	 *
	 * @return
	 * wangqi 20160713
	 */
	public Response<MallPromotionResultDto> findPromInfoForOnline();

	/**
	 * 根据活动类型获取活动基本信息列表（距离现时点最近的活动包含选品列表）
	 *
	 * @return
	 * wangqi 20160713
	 */
	public Response<List<MallPromotionResultDto>> findPromListByPromType();

	/**
	 * 根据单品CODE 获取现时点参加的活动
	 *
	 * @param type 0:包含即将开始活动 1：只需要进行中活动
	 * @param itemCodes 单品CODE 逗号分隔拼接
	 * @return 活动信息
	 * wangqi 20160713
	 */
	public Response<MallPromotionResultDto> findPromByItemCodes(String type, String itemCodes);

	/**
	 * 根据活动ID、选品ID、用户ID 记录销售数量（同时判断是否达到限购标准）
	 *
	 * @param promId
	 * @param itemCode
	 * @param user
	 * @return 是否更新成功
	 * wangqi 20160713
	 */
	public Response<Boolean> changePromSaleInfo(String promId, String itemCode, User user);

	/**
	 * 根据活动ID 获取活动参加情报
	 *
	 * @param promId
	 * @param itemCode
	 * @param user
	 * @return 活动参加情报
	 * wangqi 20160713
	 */
	public Response<MallPromotionResultDto> findPromSaleInfoByPromId(String promId, String itemCode, User user);

}
