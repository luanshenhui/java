package cn.com.cgbchina.promotion.service;

import cn.com.cgbchina.promotion.dto.*;
import cn.com.cgbchina.promotion.model.PromotionModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;
import java.util.Map;

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
			@Param("endDate") String endDate, @Param("sourceId") String sourceId);

	/**
	 * 创建活动（内管、供应商共用）
	 *
	 * @param createOperType 创建人类型(0 内管，1 供应商）
	 * @param promotionModel 活动信息
	 * @param user 用户信息
	 * @return
	 */
	public Response<Boolean> addAdminPromotion(String createOperType, AdminPromotionAddDto promotionModel, User user);

	public Response<Boolean> updateAdminPromotion(AdminPromotionUpdateDto adminPromotionUpdateDto, User user);

	public Response<Boolean> updateCheckStatus(Integer id, User user, String auditLog, Integer checkStatus);

	public Response<AdminPromotionDetailDto> findDetailById(@Param("promotionId") Integer promotionId);

	public Response<Boolean> doubleCheckRange(Integer id, Integer promotionId, String auditLog, Integer status,
			User user);

	public Response<Pager<PromItemDto>> findRanges(Integer promotionId, Integer checkStatus, String vendorName,
			String itemName, PageInfo pageInfo);

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
			@Param("size") Integer size);

	public Response<Pager<AdminPromotionQueryDto>> findDoubleCheck(@Param("id") String id,
			@Param("shortName") String shortName, @Param("promType") String promType,
			@Param("createOperType") String createOperType, @Param("beginDate") String beginDate,
			@Param("endDate") String endDate, @Param("checkStatus") String checkStatus, @Param("pageNo") Integer pageNo,
			@Param("size") Integer size);

	public Response<Boolean> doubleCheckPromotion(Integer promotionId, String auditLog, Integer status, User user);

	/**
	 * 删除活动与下线
	 * 
	 * @param promotionId
	 * @param checkStatus
	 * @return
	 */
	public Response<Boolean> offAndDelete(Integer promotionId, Integer checkStatus);

	public Response<List<PromotionModel>> getPromotionForBatch(Map<String, Object> map);
}
