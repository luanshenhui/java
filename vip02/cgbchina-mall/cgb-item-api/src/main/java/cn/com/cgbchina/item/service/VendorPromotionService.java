package cn.com.cgbchina.item.service;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.dto.PromItemDto;
import cn.com.cgbchina.item.dto.PromParamDto;
import cn.com.cgbchina.item.dto.PromotionResultDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;


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
	public Response<PromotionResultDto> findByIdForVendor(@Param("id") Integer id, @Param("User") User user);

	/**
	 * 根据活动ID和其他指定条件查询活动选品范围
	 * 
	 * @param params 查询条件
	 * @return
	 */
	public Response<List<PromItemDto>> findPromRangeByParam(Map<String, Object> params);



	/**
	 * * 修改活动的商品范围(供应商平台)
	 * 
	 * @param createOperType 活动创建区分
	 * @param id 活动id
	 * @param promotionRange
	 * @param user 用户
	 * @return 成功/失败
	 */
	public Response<String> vendorUpdatePromRange(@Param("createOperType") String createOperType,
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
	 * @param entryState
	 * @return PromotionResultDto
	 */
	public Response<Pager<PromotionResultDto>> findPromotionListForVendor(@Param("checkStatus") String checkStatus,
																		  @Param("createOperType") String createOperType, @Param("promType") String promType,
																		  @Param("shortName") String shortName, @Param("promCode") String promCode,
																		  @Param("beginDate") String beginDate, @Param("endDate") String endDate,
																		  @Param("beginEntryDate") String beginEntryDate, @Param("endEntryDate") String endEntryDate,
																		  @Param("entryState") String entryState,
																		  @Param("pageNo") Integer pageNo, @Param("size") Integer size, @Param("user") User user);

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
	 * @param entryState
	 * @param pageNo
	 * @param size
	 * @return
	 */
	public Response<Pager<PromotionResultDto>> findPromotionListForAdmin(@Param("checkStatus") String checkStatus,
			@Param("promType") String promType, @Param("shortName") String shortName,
			@Param("promCode") String promCode, @Param("beginDate") String beginDate, @Param("endDate") String endDate,
			@Param("beginEntryDate") String beginEntryDate, @Param("endEntryDate") String endEntryDate,
			@Param("entryState") String entryState,
			@Param("pageNo") Integer pageNo, @Param("size") Integer size, @Param("user") User user);

	/**
	 * 根据vendorID获取当前正在参加活动的单品IdList
	 *
	 * @param vendorId 查询条件
	 * @return
	 * @author yanjie.cao
	 */
	public Response<List<String>> findItemCodesByVendorId(String vendorId);

}
