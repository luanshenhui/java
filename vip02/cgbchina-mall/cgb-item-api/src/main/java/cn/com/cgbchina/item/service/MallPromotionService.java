package cn.com.cgbchina.item.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.dto.GoodsGroupBuyDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.dto.MallPromotionSaleInfoDto;
import cn.com.cgbchina.item.dto.PromotionItemResultDto;
import cn.com.cgbchina.item.dto.PromotionPeriodDetailDto;
import cn.com.cgbchina.item.dto.UserHollandaucLimit;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

public interface MallPromotionService {


	/**
	 * 获取广发团信息
	 *
	 * @return
	 *
	 * 		geshuo 20160704
	 */
	public Response<Map<String, Object>> findGroupBuyData();

	/**
	 * 根据类目id查询商品列表
	 *
	 * @return
	 *
	 * 		geshuo 20160705
	 */
	public Response<Map<String,Object>> findGoodsByPromAndPeriod(Integer promotionId,Integer periodId);


	/**
	 * 根据活动Id和场次id获取活动基本信息
	 * @param promId
	 * @param periodId
     * @return
     */
	public Response<MallPromotionResultDto> findPromotionByPromIdAndPeriodId(String promId,String periodId);

	public Response<List<GoodsGroupBuyDto>> findGroupGoodsByClassifyAndProm(Integer promotionId,Long classifyId,Integer periodId);
	/**
	 * 取得荷兰拍数据
	 *
	 * @return wangqi 20160713
	 */
	public Response<MallPromotionResultDto> findHollandauc();

	/**
	 * 取得已拍卖完的单品
	 *
	 * @return wangqi 20160723
	 */
	public Response<List<PromotionItemResultDto>> findHollandaucForOver(String promId, String periodId);

	/**
	 * 取得秒杀活动列表（距离现时点最近的活动包含选品列表）
	 *
	 * @return wangqi 20160713
	 */
	public Response<List<MallPromotionResultDto>> findPromListByPromType(String promType);

	/**
	 * 根据单品CODE 获取现时点参加的活动
	 *
	 * @param type 0:包含即将开始活动 1：只需要进行中活动
	 * @param itemCode 单品CODE 逗号分隔拼接
	 * @return 活动信息 wangqi 20160713
	 * @param itemCode 单品CODE
	 * @param sourceId 渠道（如空值，默认商城渠道）
	 * @return 活动信息 wangqi 20160713
	 */
	public Response<MallPromotionResultDto> findPromByItemCodes(String type, String itemCode, String sourceId);

	/**
	 * 根据活动ID、选品ID、用户ID 记录销售数量（同时判断是否达到限购标准）
	 *
	 * @param promId
	 * @param itemCode
	 * @param user
	 * @return 是否更新成功 wangqi 20160713
	 */
	public Response<Boolean> updatePromSaleInfo(String promId, String periodId, String itemCode, String buyCount,
			User user);

	/**
	 * 根据活动ID 获取活动销售信息
	 *
	 * @param promId
	 * @param itemCode
	 * @return 活动参加情报 wangqi 20160713
	 * @return 活动参加情报 wangqi 20160713
	 */
	public Response<MallPromotionSaleInfoDto> findPromSaleInfoByPromId(String promId, String periodId, String itemCode);

	/**
	 * 根据活动ID 检验活动是否有效
	 *
	 * @param promId 活动ID
	 * @return true:有效 false:无效 wangqi 20160713
	 */
	public Response<Boolean> findPromValidByPromId(String promId, String periodId);

	/**
	 * 根据活动ID、购买数量 检验用户是否达到限购
	 *
	 * @param promId 活动ID
	 * @param buyCount 购买数量
	 * @param user 用户信息
	 * @return true:有效 false:无效 wangqi 20160713
	 */
	public Response<Boolean> checkPromBuyCount(String promId, String periodId, String buyCount, User user,String itemCode);

	/**
	 *
	 * @param promId 活动id
	 * @param periodId 场次id
	 * @param user 用户
     * @return  获取当前用户当前活动的当前场次出手了多少次  一共让出手多少次
     */
	public Response<UserHollandaucLimit> getUserHollandaucLimit(String promId, String periodId, User user);

	/**
	 * 根据活动ID、单品CODE、购买数量 检验是否超过库存
	 *
	 * @param promId 活动ID
	 * @param periodId 场次 id
	 * @param buyCount 购买数量
	 * @param itemCode 单品code
	 * @return true:有效 false:无效 wangqi 20160713
	 */
	public Response<Boolean> checkPromItemStock(String promId, String periodId, String itemCode, String buyCount);

	/**
	 * 查询活动场次列表
	 * 
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 *         geshuo 20160721
	 */
	public Response<Pager<PromotionPeriodDetailDto>> findPromotionPeriodList(Map<String, Object> paramMap);

	/**
	 * 根据参数查询活动是否存在
	 * 
	 * @param promotionId 活动 id
	 * @param sourceId 渠道
	 * @param itemCode 单品 id
	 * @return 是否存在
	 *
	 *         geshuo 20160725
	 */
	public Response<Boolean> findPromotionExists(String promotionId, String sourceId, String itemCode);

	/**
	 * 根据活动ID、场次ID、用户ID 记录拍卖次数
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @param user 用户ID
	 * @return true:有效 false:无效 wangqi 20160713
	 */
	public Response<Long> insertPromForHollandauc(String promId, String periodId, User user);

	/**
	 * 根据单品CODE、活动ID、场次ID 取得拍卖时点价格数据
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @param itemCode 单品CODE
	 * @return wangqi 20160713
	 */
	public Response<PromotionItemResultDto> findHollandaucByItemCode(String promId, String periodId, String itemCode);

	/**
	 * 判定 荷兰拍拍卖资格
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @param itemCode 单品CODE
	 * @return wangqi 20160713
	 */
	public Response<Boolean> checkAuction(String promId, String periodId, String itemCode, User user);

	/**
	 * 根据活动ID、用户ID 记录销售数量 更新活动库存
	 *
	 * @param promItemMap
	 * @return 是否更新成功
	 */
	Response<Boolean> updatePromotionStock(List<Map<String, String>> promItemMap);


	/**
	 * 根据活动ID、用户ID 记录销售数量 回滚活动库存
	 *
	 * @param promItemMap
	 * @return 是否更新成功
	 */
	Response<Boolean> updateRollbackPromotionStock(List<Map<String, Object>> promItemMap);

	/**
	 * 根据渠道、活动场次分页查询现时参加的活动列表
	 * @param origin
	 * @param promtionId
	 * @param pageInfo
	 * @return
	 */
	Response<Pager<PromotionPeriodDetailDto>> findMiaoShaoPromotionPeroidList(String origin, String promtionId, PageInfo pageInfo);
}
