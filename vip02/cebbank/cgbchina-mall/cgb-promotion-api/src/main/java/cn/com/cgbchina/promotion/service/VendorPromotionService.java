package cn.com.cgbchina.promotion.service;

import cn.com.cgbchina.promotion.dto.PromItemDto;
import cn.com.cgbchina.promotion.dto.PromParamDto;
import cn.com.cgbchina.promotion.dto.PromotionResultDto;
import cn.com.cgbchina.promotion.model.PromotionModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;
import java.util.Map;

/**
 * @author wangqi
 * @version 1.0
 * @Since 2016/6/13.
 */
public interface VendorPromotionService {

	/**
	 * 根据ID查询活动详情
	 * 
	 * @param id 活动
	 * @return 成功/失败
	 */
	public Response<PromotionResultDto> findByIdForVendor(@Param("id") Integer id);

	/**
	 * 根据活动ID和其他指定条件查询活动选品范围
	 * 
	 * @param params 查询条件
	 * @return
	 */
	public Response<List<PromItemDto>> findPromRangeByParam(Map<String, Object> params);

	/**
	 * * 新增活动
	 * 
	 * @param promParamDto 活动
	 * @return 成功/失败
	 */
	public Response<Boolean> vendorAddPromotion(@Param("promParamDto") PromParamDto promParamDto,
			@Param("user") User user);

	/**
	 * * 修改活动的商品范围(供应商平台)
	 * 
	 * @param createOperType 活动创建区分
	 * @param id 活动id
	 * @param promotionRange
	 * @param user 用户
	 * @return 成功/失败
	 */
	public Response<Boolean> vendorUpdatePromRange(@Param("createOperType") String createOperType,
			@Param("id") String id, @Param("promotionRange") String promotionRange, @Param("user") User user);

	/**
	 * 根据查询条件取得活动数据列表
	 * 
	 * @param checkStatus
	 * @param promType
	 * @param shortName
	 * @param beginDate
	 * @param endDate
	 * @param beginEntryDate
	 * @param endEntryDate
	 * @param goodsName
	 * @param entryState
	 * @return PromotionResultDto
	 */
	public Response<Pager<PromotionResultDto>> findPromotionListForVendor(@Param("checkStatus") String checkStatus,
			@Param("createOperType") String createOperType, @Param("promType") String promType,
			@Param("shortName") String shortName, @Param("promCode") String promCode,
			@Param("beginDate") String beginDate, @Param("endDate") String endDate,
			@Param("beginEntryDate") String beginEntryDate, @Param("endEntryDate") String endEntryDate,
			@Param("goodsName") String goodsName, @Param("entryState") String entryState,
			@Param("pageNo") Integer pageNo, @Param("size") Integer size);

	/**
	 * 根据查询条件取得平台活动数据列表
	 *
	 * @param checkStatus
	 * @param promType
	 * @param shortName
	 * @param beginDate
	 * @param endDate
	 * @param beginEntryDate
	 * @param endEntryDate
	 * @param goodsName
	 * @param entryState
	 * @param pageNo
	 * @param size
	 * @return
	 */
	public Response<Pager<PromotionResultDto>> findPromotionListForAdmin(@Param("checkStatus") String checkStatus, @Param("promType") String promType,
																		 @Param("shortName") String shortName, @Param("promCode") String promCode,
																		 @Param("beginDate") String beginDate, @Param("endDate") String endDate,
																		 @Param("beginEntryDate") String beginEntryDate, @Param("endEntryDate") String endEntryDate,
																		 @Param("goodsName") String goodsName, @Param("entryState") String entryState,
																		 @Param("pageNo") Integer pageNo, @Param("size") Integer size);
	/**
	 * 根据vendorID获取当前正在参加活动的单品IdList
	 *
	 * @param vendorId 查询条件
	 * @return
	 * @author yanjie.cao
	 */
	public Response<List<String>> findItemCodesByVendorId(String vendorId);

}
