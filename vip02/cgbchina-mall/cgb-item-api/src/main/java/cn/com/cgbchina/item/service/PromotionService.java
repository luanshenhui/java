package cn.com.cgbchina.item.service;

import java.util.List;
import java.util.Map;


import cn.com.cgbchina.item.dto.AdminPromotionAddDto;
import cn.com.cgbchina.item.dto.AdminPromotionDetailDto;
import cn.com.cgbchina.item.dto.AdminPromotionQueryDto;
import cn.com.cgbchina.item.dto.AdminPromotionStatisticsDto;
import cn.com.cgbchina.item.dto.AdminPromotionUpdateDto;
import cn.com.cgbchina.item.dto.PromItemDto;
import cn.com.cgbchina.item.model.PromotionModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/13.
 */
public interface PromotionService {
	Response<Pager<PromotionModel>> adminPromotionPagination(@Param("pageNo") Integer pageNo,
															 @Param("size") Integer size, @Param("id") String id, @Param("shortName") String shortName,
															 @Param("promType") Integer promType, @Param("state") Integer state,
															 @Param("createOperType") Integer createOperType, @Param("beginDate") String beginDate,
															 @Param("endDate") String endDate, @Param("sourceId") String sourceId, @Param("tabType") String tabType);

	/**
	 * 创建活动（内管、供应商共用）
	 *
	 * @param createOperType 创建人类型(0 内管，1 供应商）
	 * @param promotionModel 活动信息
	 * @param user 用户信息
	 * @return
	 */
	public Response<String> addAdminPromotion(String createOperType, AdminPromotionAddDto promotionModel, User user);

	public Response<String> updateAdminPromotion(AdminPromotionUpdateDto adminPromotionUpdateDto, User user);

	public Response<Boolean> updateCheckStatus(Integer id, User user, String auditLog, Integer checkStatus);

	public Response<AdminPromotionDetailDto> findDetailById(@Param("promotionId") Integer promotionId);

	public Response<Boolean> doubleCheckRange(Integer id, Integer promotionId, String auditLog, Integer status,
			User user, String itemId);

	public Response<Pager<PromItemDto>> findRanges(Integer promotionId, Integer checkStatus, String vendorName,
												   String itemName);

	/**
	 * 根据单品查活动信息 购物车使用
	 *
	 * @param map map中一个key叫selectCode 就是单品id 暂时就一个 其他留着扩展
	 * @return
	 */
	public Response<List<PromotionModel>> findPromotionByRange(Map<String, Object> map);

	public Response<Pager<AdminPromotionQueryDto>> findCheckManage(@Param("id") String id,
																   @Param("shortName") String shortName, @Param("promType") String promType,
																   @Param("checkStatus") String checkStatus, @Param("createOperType") String createOperType,
																   @Param("beginDate") String beginDate, @Param("endDate") String endDate, @Param("pageNo") Integer pageNo,
																   @Param("size") Integer size, @Param("sourceId") String sourceId);

	public Response<Pager<AdminPromotionQueryDto>> findDoubleCheck(@Param("id") String id,
			@Param("shortName") String shortName, @Param("promType") String promType,
			@Param("createOperType") String createOperType, @Param("beginDate") String beginDate,
			@Param("endDate") String endDate, @Param("doubleCheckStatus") String checkStatus,
			@Param("pageNo") Integer pageNo, @Param("size") Integer size,@Param("sourceId") String sourceId);

	public Response<Boolean> doubleCheckPromotion(Integer promotionId, String auditLog, Integer status, User user);

	/**
	 * 删除活动与下线
	 *
	 * @param promotionId
	 * @param checkStatus
	 * @return
	 */
	public Response<Boolean> offAndDelete(Integer promotionId, Integer checkStatus);

	/**
	 * 下线活动
	 * 
	 * @param promotionId
	 * @param status
	 * @param user
	 * @return
	 */
	public Response<Boolean> updateOffLine(Integer promotionId, Integer status, User user);

	/**
	 * 统计活动销量
	 * 
	 * @param id 活动id
	 * @param selectCode 活动单品code
	 * @param selectName 单品名称 模糊查询
	 * @param pageNo 第几页
	 * @param size 一页显示多少
	 * @return
	 */
	public Response<Pager<AdminPromotionStatisticsDto>> findPromStatistics(@Param("promId") Integer id,
																		   @Param("itemCode") String selectCode, @Param("itemName") String selectName, @Param("pageNo") Integer pageNo,
																		   @Param("size") Integer size);

	/**
	 *
	 * @param promId 活动id
	 * @param selectCode 单品号
	 * @param saleCount 销量 买了多少件
	 * @return
	 */
	public Response<Boolean> updateSaleCount(Integer promId, String selectCode, Integer saleCount);

/*	*//**
	 * Description :获取所有当前有效活动信息
	 * 
	 * @return
	 * @author xiewl
	 *//*
	public Response<List<PromotionFormalModel>> findAllActPromotions(String promotionType);*/

	/**
	 * 根据活动类型查询活动对应的单品id
	 * @param promotionType
	 * @param sourceId 渠道 00商城 01 CC 02 IVR 03 手机商城 04 短信 05微信广发银行 06微信广发信用卡 09APP
	 * @return
	 */
	public Response<List<String>> findPromotionsGoods(String promotionType,String sourceId);

	public Response<Boolean>  getStatusByItemCode(String goodsCode);

	/**
	 * 同步商品的活动索引信息
	 *
	 * @param  args [0] 活动id[1] 状态 ON_SHELF("02", "上架"),OFF_SHELF("01", "下架"), DELETED("-1", "删除")
	 * @return
	 */
	Response<Boolean> syncPromoDataToIndexStart(String... args);

    /**
     * 同步商品的活动索引信息
     *
     * @param  args [0] 活动id[1] 状态 ON_SHELF("02", "上架"),OFF_SHELF("01", "下架"), DELETED("-1", "删除")
     * @return
     */
    Response<Boolean> syncPromoDataToIndexEnd(String... args);

	/**
	 * 根据活动ids返回活动信息
	 * @param promotionIds
	 * @return
     */
	public Response<List<PromotionModel>> findPromotionByIds(List<Integer> promotionIds);
}
