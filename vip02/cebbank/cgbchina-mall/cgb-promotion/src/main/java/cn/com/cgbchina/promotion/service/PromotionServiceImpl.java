package cn.com.cgbchina.promotion.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.BackCategory;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.BackCategoriesService;
import cn.com.cgbchina.item.service.BrandService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.promotion.dao.PromotionDao;
import cn.com.cgbchina.promotion.dao.PromotionRangeDao;
import cn.com.cgbchina.promotion.dao.PromotionVendorDao;
import cn.com.cgbchina.promotion.dto.*;
import cn.com.cgbchina.promotion.manager.PromotionManager;
import cn.com.cgbchina.promotion.model.PromotionModel;
import cn.com.cgbchina.promotion.model.PromotionRangeModel;
import cn.com.cgbchina.promotion.model.PromotionVendorModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.*;

@Service
@Slf4j
public class PromotionServiceImpl implements PromotionService {
	private final static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	private String insertError = "insert.error";
	// private final DateTimeFormatter dateTimeFormat = DateTimeFormat.forPattern("yyyy-MM-dd");
	private final DateTimeFormatter dateTimeFormat = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
	private final DateTimeFormatter dateTimeFormatCal = DateTimeFormat.forPattern("yyyy-MM-dd");
	// LocalDateTime.now().toString(DateTimeFormat.forPattern("yyyy/MM/dd HH:mm:ss")
	// private final DateTimeFormatter dateTimeFormat = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
	private String mallSystemCode = "yg";
	@Resource
	private PromotionDao promotionDao;
	@Resource
	private PromotionRangeDao promotionRangeDao;
	@Resource
	private PromotionManager promotionManager;
	@Resource
	private PromotionVendorDao promotionVendorDao;
	@Resource
	private VendorService vendorService;
	@Resource
	private ItemService itemService;
	@Resource
	private GoodsService goodsService;
	@Resource
	private BackCategoriesService backCategoriesService;
	@Resource
	private BrandService brandService;
	@Resource
	private VendorPromotionService vendorPromotionService;

	@Override
	public Response<Pager<PromotionModel>> adminPromotionPagination(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("id") String id, @Param("shortName") String shortName,
			@Param("promType") Integer promType, @Param("state") Integer state,
			@Param("createOperType") Integer createOperType, @Param("beginDate") String beginDate,
			@Param("endDate") String endDate, @Param("sourceId") String sourceId) {

		Response<Pager<PromotionModel>> response = new Response<>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> queryMap = Maps.newHashMap();
		queryMap.put("offset", pageInfo.getOffset());
		queryMap.put("limit", pageInfo.getLimit());
		if (StringUtils.isNotEmpty(id)) {
			queryMap.put("id", id);
		}
		if (StringUtils.isNotEmpty(shortName)) {
			queryMap.put("shortName", shortName);
		}
		if (promType != null) {
			queryMap.put("promType", promType);
		}
		if (state != null) {
			queryMap.put("checkStatus", state);
		}
		if (createOperType != null) {
			queryMap.put("createOperType", createOperType);
		}
		if (StringUtils.isNotEmpty(beginDate)) {
			DateTime dateTime = dateTimeFormatCal.parseDateTime(beginDate);
			queryMap.put("beginDate", dateTime.toDate());
		}

		if (StringUtils.isNotEmpty(endDate)) {
			DateTime dateTime = dateTimeFormatCal.parseDateTime(endDate);
			queryMap.put("endDate", dateTime.toDate());
		}
		if (StringUtils.isNotEmpty(sourceId)) {
			queryMap.put("sourceId", sourceId);
		}
		Pager<PromotionModel> promotionModelPager = null;
		try {
			promotionModelPager = promotionDao.findByAdminPage(queryMap);
			response.setResult(promotionModelPager);
		} catch (Exception e) {
			log.error("failed to query promotion", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	/**
	 * 创建活动（内管、供应商共用）
	 *
	 * @param createOperType 创建人类型(0 内管，1 供应商）
	 * @param adminPromotionAddDto 活动信息
	 * @param user 用户信息
	 * @return
	 */
	@Override
	public Response<Boolean> addAdminPromotion(String createOperType, AdminPromotionAddDto adminPromotionAddDto,
			User user) {
		Response<Boolean> response = new Response<>();
		try {
			PromotionModel promotionModel = new PromotionModel();
			if(StringUtils.isNotEmpty(adminPromotionAddDto.getId())){
				promotionModel.setId(Integer.parseInt(adminPromotionAddDto.getId()));//geshuo:修改后保存时,已经存在id
			}
			// adminPromotionAddDto.getBeginDate()
			promotionModel.setCreateOperType(Integer.valueOf(createOperType));
			promotionModel.setOrdertypeId(mallSystemCode);// 通过此接口创建的都是广发商城
			promotionModel.setIsValid(1);// 默认正常状态
			promotionModel.setCreateOper(user.getId());
			promotionModel.setName(adminPromotionAddDto.getName());// 活动名称
			promotionModel.setShortName(adminPromotionAddDto.getShortName());// 简称
			promotionModel.setPromType(adminPromotionAddDto.getPromType());// 设置活动类型
			promotionModel.setDescription(adminPromotionAddDto.getDescription());// 设置描述=
			Date beginDate = adminPromotionAddDto.getBeginDate();// 活动开始时间
			Date endDate = adminPromotionAddDto.getEndDate();// 活动结束时间
			if (adminPromotionAddDto.getPromType() == 10 || adminPromotionAddDto.getPromType() == 20) {
				/* change start by geshuo 20160709:只有平台创建活动时需要报名时间 ------------ */
				if (StringUtils.isNotEmpty(createOperType) && "0".equals(createOperType)) {// 创建者类型 0内管 1供应商
					Date beginEntryDate = dateTimeFormatCal.parseLocalDate(adminPromotionAddDto.getBeginEntryDate())
							.toDate();// 报名开始时间
					Date endEntryDate = dateTimeFormatCal.parseLocalDate(adminPromotionAddDto.getEndEntryDate()).toDate();// 报名结束时间
					// 时间先后
					if (!endDate.after(beginDate) || !endEntryDate.after(beginEntryDate)
							|| !beginDate.after(endEntryDate)) {
						response.setError("update.error");
						return response;
					}
					promotionModel.setBeginEntryDate(beginEntryDate);
					promotionModel.setEndEntryDate(endEntryDate);
				}
				/* change end by geshuo 20160709 ------------------------------------------- */
				// 时间没问题
				promotionModel.setBeginDate(adminPromotionAddDto.getBeginDate());
				promotionModel.setEndDate(adminPromotionAddDto.getEndDate());
			} else {
				// 后三种活动情况
				if (beginDate.after(endDate)) {
					response.setError("update.error");
					return response;

				}
				promotionModel.setBeginDate(beginDate);
				promotionModel.setEndDate(endDate);
			}

			// 优惠规则处理
			String errorMessage = "";
			// 优惠规则校验
			switch (adminPromotionAddDto.getPromType()) {

			case (10): {
				// 折扣情况
				BigDecimal ruleDiscountRate = adminPromotionAddDto.getRuleDiscountRate();// 折扣比例
				if (ruleDiscountRate.compareTo(BigDecimal.ONE) != 1
						|| ruleDiscountRate.compareTo(BigDecimal.TEN) != -1) {
					response.setError("insert.error");
					return response;
				}
				promotionModel.setRuleDiscountRate(ruleDiscountRate);
				Integer ruleLimitBuyCount = adminPromotionAddDto.getRuleLimitBuyCount();// 限购数量
				if (ruleLimitBuyCount <= 0) {
					response.setError("insert.error");
					return response;
				}
				promotionModel.setRuleLimitBuyCount(ruleLimitBuyCount);
				Integer ruleLimitBuyType = adminPromotionAddDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
				if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
					response.setError("insert.error");
					return response;
				}
				promotionModel.setRuleLimitBuyType(ruleLimitBuyType);
				promotionModel.setIsSignup(1);
				break;
			}
			case (20): {
				// 满减
				// 最多十条的满减优惠
				String fullCutJson = adminPromotionAddDto.getFullCut();
				if (StringUtils.isEmpty(fullCutJson)) {
					response.setError("insert.error");
					return response;
				}
				List<FullCutDto> fullCutDtoList = jsonMapper.fromJson(fullCutJson,
						jsonMapper.createCollectionType(List.class, FullCutDto.class));
				// 反射处理set方法 按顺序填入满减规则
				for (int i = 0; i < fullCutDtoList.size(); i++) {
					Method setFullMethod = promotionModel.getClass().getMethod("setRuleMinPay" + (i + 1),
							Integer.class);
					setFullMethod.invoke(promotionModel, fullCutDtoList.get(i).getFull());
					Method setCutMethod = promotionModel.getClass().getMethod("setRuleFee" + (i + 1), Integer.class);
					setCutMethod.invoke(promotionModel, fullCutDtoList.get(i).getCut());
				}
				// 满减需要报名
				promotionModel.setIsSignup(1);
				break;
			}
			case (30):
			case (40): {
				// 秒杀、团购一样
				Integer ruleLimitBuyCount = adminPromotionAddDto.getRuleLimitBuyCount();// 限购数量
				if (ruleLimitBuyCount <= 0) {
					response.setError("insert.error");
					return response;
				}
				promotionModel.setRuleLimitBuyCount(adminPromotionAddDto.getRuleLimitBuyCount());
				Integer ruleLimitBuyType = adminPromotionAddDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
				if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
					response.setError("insert.error");
					return response;
				}
				promotionModel.setRuleLimitBuyType(adminPromotionAddDto.getRuleLimitBuyType());
				promotionModel.setIsSignup(0);
				break;
			}

			case (50): {
				Integer ruleFrequency = adminPromotionAddDto.getRuleFrequency();// 降价频率
				if (ruleFrequency <= 0) {
					response.setError("insert.error");
					return response;
				}
				promotionModel.setRuleFrequency(ruleFrequency);

				Integer ruleLimitBuyCount = adminPromotionAddDto.getRuleLimitBuyCount();// 限购数量
				if (ruleLimitBuyCount <= 0) {
					response.setError("insert.error");
					return response;
				}
				promotionModel.setRuleLimitBuyCount(ruleLimitBuyCount);
				Integer ruleLimitBuyType = adminPromotionAddDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
				if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
					response.setError("insert.error");
					return response;
				}
				promotionModel.setRuleLimitBuyType(ruleLimitBuyType);

				promotionModel.setRuleLimitTicket(adminPromotionAddDto.getRuleLimitTicket());
				;// 可拍次数
				promotionModel.setRuleGroupCount(adminPromotionAddDto.getRuleGroupCount());// 可拍次数
				promotionModel.setIsSignup(0);
				break;
			}
			}

			if (errorMessage.length() != 0) {
				// 优惠规则数据编辑格式不正确，终止返回
				response.setError(errorMessage);
				return response;
			}
			// 循环任务check
			// 非空 表示有循环任务
			if (StringUtils.isNotEmpty(adminPromotionAddDto.getLoopType())) {

				// 类型只有三种 d 按天循环 w按星期循环 m按月循环
				if (!"d".equals(adminPromotionAddDto.getLoopType()) && !"w".equals(adminPromotionAddDto.getLoopType())
						&& !"m".equals(adminPromotionAddDto.getLoopType())) {
					response.setError(errorMessage);
					return response;
				}
				promotionModel.setLoopType(adminPromotionAddDto.getLoopType());
				// 循环任务时间先后
				/*
				 * if (adminPromotionAddDto.getLoopBeginTime1().after(adminPromotionAddDto.getLoopEndTime1()) ||
				 * adminPromotionAddDto.getLoopBeginTime2().after(adminPromotionAddDto.getLoopEndTime2())) { //
				 * 开始时间晚于结束时间 报错 response.setError(errorMessage); return response; }
				 */
				// 其他业务合理性不做判断

				// 循环任务判断成功准备插入
				promotionModel.setLoopType(adminPromotionAddDto.getLoopType());
				promotionModel.setLoopData(adminPromotionAddDto.getLoopData());
				promotionModel.setLoopBeginTime1(adminPromotionAddDto.getLoopBeginTime1());
				promotionModel.setLoopBeginTime2(adminPromotionAddDto.getLoopBeginTime2());
				promotionModel.setLoopEndTime1(adminPromotionAddDto.getLoopEndTime1());
				promotionModel.setLoopEndTime2(adminPromotionAddDto.getLoopEndTime2());
			}
			// 销售渠道WEB端已处理，此处不需要后续处理
			promotionModel.setSourceId(adminPromotionAddDto.getSourceId());

			Integer checkStatus = 0;
			if (StringUtils.isNotEmpty(createOperType) && "0".equals(createOperType)) {// 创建者类型 0内管 1供应商
				// 保存
				/*
				 * if ("0".equals(adminPromotionAddDto.getSaveType())) { checkStatus = 0;// 添加(未提交审批) 0 } else { // 提交
				 * // 提交这就有说头了 if (adminPromotionAddDto.getPromType() == Contants.PROMOTION_PROM_TYPE_1 ||
				 * adminPromotionAddDto.getPromType() == Contants.PROMOTION_PROM_TYPE_2) { // 内管创建的折扣和满减活动 需要初审
				 * 所以此处设置状态为2待初审 } else { // 内管创建的其他活动类型 没有初审 直接复审 所以设置标志位5 带复审 checkStatus = 5; }
				 * 
				 * } promotionModel.setCheckStatus(checkStatus);// 放入处理完成的活动状态 // 折扣 满减 设置需报名参见 其他活动类型不用报名参加 if
				 * (adminPromotionAddDto.getPromType() == Contants.PROMOTION_PROM_TYPE_1 ||
				 * adminPromotionAddDto.getPromType() == Contants.PROMOTION_PROM_TYPE_2) {
				 * promotionModel.setIsSignup(Contants.PROMOTION_IS_SIGNUP_1); } else {
				 * promotionModel.setIsSignup(Contants.PROMOTION_IS_SIGNUP_0); } // 创建人类型内管
				 * promotionModel.setCreateOperType(Contants.PROMOTION_CREATE_OPER_TYPE_0);
				 */
				promotionModel.setCheckStatus(adminPromotionAddDto.getCheckStatus());
				// 平台选品处理
				promotionManager.insertAdminPromotion(promotionModel, adminPromotionAddDto.getRange());
			} else if (StringUtils.isNotEmpty(createOperType) && "1".equals(createOperType)) {// 供应商创建活动
				// 保存
				String saveType = adminPromotionAddDto.getSaveType();
				if ("0".equals(saveType)) {
					checkStatus = 0;// 添加(未提交审批) 0
				} else { // 提交
					checkStatus = 5;// 待复审 5 供应商创建活动 跳过初审阶段
				}
				if (promotionModel.getId() == null) {
					// 不需要报名
					promotionModel.setIsSignup(Contants.PROMOTION_IS_SIGNUP_0);
					// 创建人类型供应商
					promotionModel.setCreateOperType(Contants.PROMOTION_CREATE_OPER_TYPE_1);
				} else {
					promotionModel.setModifyOper(user.getId());
					promotionModel.setModifyOperType(Contants.PROMOTION_CREATE_OPER_TYPE_1);
				}
				// 供应商选品处理
				promotionModel.setCheckStatus(checkStatus);// 放入处理完成的活动状态
				promotionManager.changePromotionForVendor(promotionModel, adminPromotionAddDto.getRange(), saveType);
			}
			response.setResult(Boolean.TRUE);
		} catch (IllegalArgumentException e) {
			log.error("fail to create promotion", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());

		} catch (Exception e) {
			log.error("fail to create promotion", Throwables.getStackTraceAsString(e));
			response.setError("create.error");
		}
		return response;
	}

	/**
	 *
	 * @param adminPromotionUpdateDto
	 * @param user
	 * @return
	 */
	@Override
	public Response<Boolean> updateAdminPromotion(AdminPromotionUpdateDto adminPromotionUpdateDto, User user) {
		Response<Boolean> response = new Response<>();
		try {
			// 当前活动编辑前的旧对象
			PromotionModel oldPromotion = promotionDao.findById(adminPromotionUpdateDto.getId());
			if (oldPromotion == null || oldPromotion.getCheckStatus() != 0) {
				// 不是添加未提交审批的活动 不允许编辑
				response.setError("promotion.edit.refuse");
				return response;
			}
			// 构建活动更新对象
			PromotionModel promotionModel = new PromotionModel();
			// adminPromotionAddDto.getBeginDate()
			promotionModel.setId(adminPromotionUpdateDto.getId());// 活动
			promotionModel.setModifyOperType(0);// 修改类型写死 都是内管
			promotionModel.setModifyOper(user.getId());// 修改人类型
			promotionModel.setName(adminPromotionUpdateDto.getName());// 活动名称
			promotionModel.setShortName(adminPromotionUpdateDto.getShortName());// 简称
			promotionModel.setPromType(adminPromotionUpdateDto.getPromType());// 设置活动类型 活动类型不让改
			promotionModel.setDescription(adminPromotionUpdateDto.getDescription());// 设置描述=
			// 折扣 满减 设置需报名参加 其他活动类型不用报名参加 活动类型不能变 所以能否报名状态更新的时候状态不会变
			/*
			 * if (adminPromotionUpdateDto.getPromType() == 10 || adminPromotionUpdateDto.getPromType() == 20) {
			 * promotionModel.setIsSignup(0); } else { promotionModel.setIsSignup(1); }
			 */
			Date beginDate = adminPromotionUpdateDto.getBeginDate();// 活动开始时间
			Date endDate = adminPromotionUpdateDto.getEndDate();// 活动结束时间
			if (adminPromotionUpdateDto.getPromType() == 10 || adminPromotionUpdateDto.getPromType() == 20) {
				Date beginEntryDate = dateTimeFormatCal.parseLocalDate(adminPromotionUpdateDto.getBeginEntryDate())
						.toDate();// 报名开始时间
				Date endEntryDate = dateTimeFormatCal.parseLocalDate(adminPromotionUpdateDto.getEndEntryDate())
						.toDate();// 报名结束时间
				// 时间先后
				if (!endDate.after(beginDate) || !endEntryDate.after(beginEntryDate)
						|| !beginDate.after(endEntryDate)) {
					response.setError("update.error");
					return response;
				}
				// 时间没问题
				promotionModel.setBeginDate(adminPromotionUpdateDto.getBeginDate());
				promotionModel.setEndDate(adminPromotionUpdateDto.getEndDate());
				promotionModel.setBeginEntryDate(beginEntryDate);
				promotionModel.setEndEntryDate(endEntryDate);
			} else {
				// 后三种活动情况
				if (beginDate.after(endDate)) {
					response.setError("update.error");
					return response;

				}
				promotionModel.setBeginDate(beginDate);
				promotionModel.setEndDate(endDate);
			}

			// 优惠规则处理
			String errorMessage = "";
			// 优惠规则校验
			switch (adminPromotionUpdateDto.getPromType()) {

			case (10): {
				// 折扣情况
				BigDecimal ruleDiscountRate = adminPromotionUpdateDto.getRuleDiscountRate();// 折扣比例
				if (ruleDiscountRate.compareTo(BigDecimal.ONE) != 1
						|| ruleDiscountRate.compareTo(BigDecimal.TEN) != -1) {
					response.setError("update.error");
					return response;
				}
				promotionModel.setRuleDiscountRate(adminPromotionUpdateDto.getRuleDiscountRate());
				Integer ruleLimitBuyCount = adminPromotionUpdateDto.getRuleLimitBuyCount();// 限购数量
				if (ruleLimitBuyCount <= 0) {
					response.setError("update.error");
					return response;
				}
				promotionModel.setRuleLimitBuyCount(adminPromotionUpdateDto.getRuleLimitBuyCount());
				Integer ruleLimitBuyType = adminPromotionUpdateDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
				if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
					response.setError("update.error");
					return response;
				}
				promotionModel.setRuleLimitBuyType(adminPromotionUpdateDto.getRuleLimitBuyType());
				break;
			}
			case (20): {
				// 满减
				// 最多十条的满减优惠
				String fullCutJson = adminPromotionUpdateDto.getFullCut();
				if (StringUtils.isEmpty(fullCutJson)) {
					response.setError("insert.error");
					return response;
				}
				List<FullCutDto> fullCutDtoList = jsonMapper.fromJson(fullCutJson,
						jsonMapper.createCollectionType(List.class, FullCutDto.class));
				// 反射处理set方法 按顺序填入满减规则
				for (int i = 0; i < fullCutDtoList.size(); i++) {
					Method setFullMethod = promotionModel.getClass().getMethod("setRuleMinPay" + (i + 1),
							Integer.class);
					setFullMethod.invoke(promotionModel, fullCutDtoList.get(i).getFull());
					Method setCutMethod = promotionModel.getClass().getMethod("setRuleFee" + (i + 1), Integer.class);
					setCutMethod.invoke(promotionModel, fullCutDtoList.get(i).getCut());
				}
				// 满减需要报名
				promotionModel.setIsSignup(1);
				break;
			}
			case (30):
			case (40): {
				// 秒杀和团购一样
				Integer ruleLimitBuyCount = adminPromotionUpdateDto.getRuleLimitBuyCount();// 限购数量
				if (ruleLimitBuyCount <= 0) {
					response.setError("update.error");
					return response;
				}
				promotionModel.setRuleLimitBuyCount(adminPromotionUpdateDto.getRuleLimitBuyCount());
				Integer ruleLimitBuyType = adminPromotionUpdateDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
				if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
					response.setError("update.error");
					return response;
				}
				promotionModel.setRuleLimitBuyType(adminPromotionUpdateDto.getRuleLimitBuyType());
				break;
			}

			case (50): {
				Integer ruleFrequency = adminPromotionUpdateDto.getRuleFrequency();// 降价频率
				if (ruleFrequency <= 0) {
					response.setError("update.error");
					return response;
				}
				promotionModel.setRuleFrequency(adminPromotionUpdateDto.getRuleFrequency());

				Integer ruleLimitBuyCount = adminPromotionUpdateDto.getRuleLimitBuyCount();// 限购数量
				if (ruleLimitBuyCount <= 0) {
					response.setError("update.error");
					return response;
				}
				promotionModel.setRuleLimitBuyCount(adminPromotionUpdateDto.getRuleLimitBuyCount());
				Integer ruleLimitBuyType = adminPromotionUpdateDto.getRuleLimitBuyType();// 限购种类，0 单日内限购，1 整个活动限购
				if (ruleLimitBuyType != 0 && ruleLimitBuyType != 1) {
					response.setError("update.error");
					return response;
				}
				promotionModel.setRuleLimitBuyType(adminPromotionUpdateDto.getRuleLimitBuyType());

				promotionModel.setRuleLimitTicket(adminPromotionUpdateDto.getRuleLimitTicket());// 可拍次数
				promotionModel.setRuleGroupCount(adminPromotionUpdateDto.getRuleGroupCount());// 可拍次数
				break;
			}
			}

			if (errorMessage.length() != 0) {
				// 说明有优惠规则传得数据格式不对 返回不让往数据库插入
				response.setError(errorMessage);
				return response;
			}
			// 循环任务check
			// 不是空说明有循环任务
			if (StringUtils.isNotEmpty(adminPromotionUpdateDto.getLoopType())) {

				// 类型只有三种 d 按天循环 w按星期循环 m按月循环
				if (!"d".equals(adminPromotionUpdateDto.getLoopType())
						&& !"w".equals(adminPromotionUpdateDto.getLoopType())
						&& !"m".equals(adminPromotionUpdateDto.getLoopType())) {
					response.setError(errorMessage);
					return response;
				}
				promotionModel.setLoopType(adminPromotionUpdateDto.getLoopType());
				// 循环任务时间先后
				if (adminPromotionUpdateDto.getLoopBeginTime1().after(adminPromotionUpdateDto.getLoopEndTime1())
						|| adminPromotionUpdateDto.getLoopBeginTime2()
								.after(adminPromotionUpdateDto.getLoopEndTime2())) {
					// 开始时间晚于结束时间 报错
					response.setError(errorMessage);
					return response;
				}
				// 其他业务合理性不做判断

				// 循环任务判断成功准备插入
				promotionModel.setLoopType(adminPromotionUpdateDto.getLoopType());
				promotionModel.setLoopData(adminPromotionUpdateDto.getLoopData());
				promotionModel.setLoopBeginTime1(adminPromotionUpdateDto.getLoopBeginTime1());
				promotionModel.setLoopBeginTime2(adminPromotionUpdateDto.getLoopBeginTime2());
				promotionModel.setLoopEndTime1(adminPromotionUpdateDto.getLoopEndTime1());
				promotionModel.setLoopEndTime2(adminPromotionUpdateDto.getLoopEndTime2());
			}
			// 销售渠道前台已处理 后台直接拿
			promotionModel.setSourceId(adminPromotionUpdateDto.getSourceId());
			promotionModel.setOrdertypeId("YG");
			// 处理活动范
			promotionModel.setCheckStatus(adminPromotionUpdateDto.getCheckStatus());// 设置状态，前台已经处理好

			promotionManager.updateAdminPromotion(promotionModel, adminPromotionUpdateDto.getRange());

			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("fail to create promotion", Throwables.getStackTraceAsString(e));
			response.setError("update.error");
		}
		return response;
	}

	/**
	 * 审核状态
	 *
	 * @return
	 */
	@Override
	public Response<Boolean> updateCheckStatus(Integer id, User user, String auditLog, Integer checkStatus) {
		Response<Boolean> response = new Response<>();
		try {

			promotionManager.updateCheckStatus(id, user, auditLog, checkStatus);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("fail to update promotion", Throwables.getStackTraceAsString(e));
			response.setError("update.error");
		}
		return response;
	}

	/**
	 * 活动删除与下线
	 * 
	 * @param promotionId
	 * @param checkStatus
	 * @return
	 */
	@Override
	public Response<Boolean> offAndDelete(Integer promotionId, Integer checkStatus) {
		Response<Boolean> response = new Response<>();
		try {

			Map<String, Object> map = Maps.newHashMap();
			map.put("checkStatus", checkStatus);
			map.put("id", promotionId);
			promotionDao.offAndDelete(map);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("fail to update promotion", Throwables.getStackTraceAsString(e));
			response.setError("update.error");
		}
		return response;
	}

	/**
	 * 查看详情
	 * 
	 * @param promotionId
	 * @return
	 */

	@Override
	public Response<AdminPromotionDetailDto> findDetailById(Integer promotionId) {
		Response<AdminPromotionDetailDto> response = new Response<>();
		try {
			PromotionModel promotionModel = promotionDao.findById(promotionId);// 活动本身数据
			AdminPromotionDetailDto adminPromotionDetailDto = new AdminPromotionDetailDto();
			// 活动范围分两种，一种是那供应商 一种是拿单品
			if (promotionModel.getPromType() == 10 || promotionModel.getPromType() == 20) {
				List<PromotionVendorModel> promotionVendors = promotionVendorDao.findByPromotion(promotionId);
				// 如果查不到的话 说明是所有供应商都参加的状态
				if (promotionVendors.size() == 0) {
					adminPromotionDetailDto.setVendorIdNameDtos(Collections.<VendorIdNameDto> emptyList());
				} else {
					// 有供应商的话 查询所有供应商
					// 得到查询id集合
					List<String> vendorIds = Lists.newArrayList();
					for (PromotionVendorModel promotionVendorModel : promotionVendors) {

						vendorIds.add(promotionVendorModel.getVendorId());
					}

					Response<List<VendorInfoModel>> vendorInfoResult = vendorService.findByVendorIds(vendorIds);
					if (!vendorInfoResult.isSuccess()) {
						log.error("fail to excute interface vendorService findBy VendorIds",
								vendorInfoResult.getError());
						response.setError("query,error");
						return response;
					}
					List<VendorInfoModel> vendorInfoModels = vendorInfoResult.getResult();
					List<VendorIdNameDto> list = BeanMapper.<VendorIdNameDto> mapList(vendorInfoModels,
							VendorIdNameDto.class);
					adminPromotionDetailDto.setVendorIdNameDtos(list);

				}
				// 得到当前活动所有供应商已经报名的单品 供审核用
				Map<String, Object> promo = Maps.newHashMap();
				promo.put("promotionId", promotionId);
				promo.put("offset", 0);
				promo.put("limit", 10);
				// 因为这里只有查看详情页显示第一个默认的十条数据 第二页不通过此接口获取 所以写死只返回十条即可
				Response<List<PromItemDto>> promRangeByParam = vendorPromotionService.findPromRangeByParam(promo);
				adminPromotionDetailDto.setPromItemDtos(promRangeByParam.getResult());

			} else if (promotionModel.getPromType() == 30 || promotionModel.getPromType() == 40
					|| promotionModel.getPromType() == 50) {

				List<PromotionRangeModel> promotionRangeModels = promotionRangeDao.findByPromId(promotionId);// 活动选品数据
				// 活动详情里面的活动选品的数据 第一个就是10条 最多200条 此处需求可能变更 所以直接截取10条list
				// 通过选品数据 把选品对应的单品详情查出来
				List<PromItemDto> promItemList = new ArrayList<PromItemDto>();
				if (promotionRangeModels != null) {
					for (PromotionRangeModel model : promotionRangeModels) {
						PromItemDto dto = new PromItemDto();
						dto.setId(model.getId()); // 活动选取范围ID
						dto.setItemCode(model.getSelectCode()); // 选品编码
						dto.setGoodsName(model.getSelectName()); // 选品名称
						dto.setPrice(model.getPrice()); // 选品价格
						dto.setStock(model.getStock()); // 选品库存
						dto.setAuditLog(model.getAuditLog()); // 审核日志
						dto.setCostBy(model.getCostBy());// 费用承担方
						dto.setSort(String.valueOf(model.getSeq()));// 排序
						dto.setCouponEnable(model.getCouponEnable());// 是否使用优惠卷
						dto.setLevelPrice(model.getLevelPrice());// 阶梯之售价
						dto.setStartPrice(model.getStartPrice());// 起拍价
						dto.setMinPrice(model.getMinPrice());// 最低价
						dto.setFeeRange(model.getFeeRange());// 降价金额
						Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(model.getVendorId());// 得到供应商信息
						if (!vendorInfoDtoResponse.isSuccess()) {
							response.setError("find.detail.error");
							return response;
						}
						dto.setVendor(vendorInfoDtoResponse.getResult().getSimpleName());// 供应商简称 用于前台显示

						ItemModel itemModel = itemService.findItemDetailByCode(model.getSelectCode());
						if (itemModel != null) {
							Response<GoodsModel> goodsModelResponse = goodsService.findById(itemModel.getGoodsCode());
							GoodsModel goodsModel = goodsModelResponse.getResult();
							if (goodsModel != null) {
								// 后台类目
								List<Long> backCategoryIdList = Lists.newArrayList();
								backCategoryIdList.add(goodsModel.getBackCategory1Id());
								backCategoryIdList.add(goodsModel.getBackCategory2Id());
								backCategoryIdList.add(goodsModel.getBackCategory3Id());
								Response<List<BackCategory>> backCategoryRespone = backCategoriesService
										.findByIds(backCategoryIdList);
								if (backCategoryRespone.isSuccess()) {
									List<BackCategory> backCategoryList = backCategoryRespone.getResult();
									if (StringUtils.isNotEmpty(backCategoryList.get(0).getName())) {
										dto.setBackCategory1Name(backCategoryList.get(0).getName());
									}
									if (StringUtils.isNotEmpty(backCategoryList.get(1).getName())) {
										dto.setBackCategory2Name(backCategoryList.get(1).getName());
									}
									if (StringUtils.isNotEmpty(backCategoryList.get(2).getName())) {
										dto.setBackCategory3Name(backCategoryList.get(2).getName());
									}
								}
								// 品牌
								GoodsBrandModel goodsBrandModel = brandService
										.findBrandInfoById(goodsModel.getGoodsBrandId()).getResult();
								dto.setGoodsBrandName(goodsBrandModel.getBrandName());
							}
						}

						promItemList.add(dto);
					}
				}

				adminPromotionDetailDto.setPromItemDtos(promItemList);

			} else {
				response.setError("promotion.type.error");
				return response;
			}
			// 处理一些编号类的字段 便于前台显示
			AdminPromotionResultDto adminPromotionResultDto = new AdminPromotionResultDto();
			BeanMapper.copy(promotionModel, adminPromotionResultDto);

			if (promotionModel.getPromType() == 10) {
				// 格式化折扣比例
				adminPromotionResultDto.setRuleDiscountRateFormat(promotionModel.getRuleDiscountRate().toString());
			}
			if (promotionModel.getPromType() == 20) {
				// 格式化满减数据 把十个字段变成一个List
				List<Integer> ruleMinPays = Lists.newArrayList();
				List<Integer> ruleFees = Lists.newArrayList();
				int seq = 1;
				Method getRuleMinPay = promotionModel.getClass().getMethod("getRuleMinPay" + seq);// ruleMinPay
				Method getRuleFee = promotionModel.getClass().getMethod("getRuleFee" + seq);
				while (getRuleMinPay.invoke(promotionModel, null) != null) {
					ruleMinPays.add((Integer) getRuleMinPay.invoke(promotionModel, null));
					ruleFees.add((Integer) getRuleFee.invoke(promotionModel, null));
					seq++;
					getRuleMinPay = promotionModel.getClass().getMethod("getRuleMinPay" + seq);
					getRuleFee = promotionModel.getClass().getMethod("getRuleFee" + seq);
				}
				adminPromotionResultDto.setRuleMinPays(ruleMinPays);
				adminPromotionResultDto.setRuleFees(ruleFees);

			}

			// 处理渠道数据
			String[] sourceIds = promotionModel.getSourceId().split("\\|\\|");
			// 渠道数据结果
			StringBuffer sourceResult = new StringBuffer();
			for (String temp : Arrays.copyOfRange(sourceIds, 1, sourceIds.length)) {
				sourceResult.append(getSourceName(temp) + ",");
			}
			adminPromotionResultDto.setSourceNames(sourceResult.substring(0, sourceResult.length() - 1));// 渠道数据处理
			// 处理循环任务数据
			if (promotionModel.getLoopType() != null) {
				switch (promotionModel.getLoopType()) {
				case ("d"): {
					// 如果是每天
					adminPromotionResultDto.setLoopJobFormat("每天");
					break;
				}
				case ("w"): {
					adminPromotionResultDto.setLoopJobFormat("每周");
					break;
				}
				case ("m"): {
					adminPromotionResultDto.setLoopJobFormat("每月");
					break;
				}
				}
			}
			// 处理活动类型
			adminPromotionResultDto.setPromTypeName(getTypeName(promotionModel.getPromType()));
			if (promotionModel.getCreateOperType() == 0) {
				adminPromotionResultDto.setCreateOperTypeName("内管");
			} else {
				adminPromotionResultDto.setCreateOperTypeName("供应商");
			}
			adminPromotionDetailDto.setAdminPromotionResultDto(adminPromotionResultDto);
			response.setResult(adminPromotionDetailDto);
		} catch (Exception e) {
			log.error("fail to find detail promotion", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;

	}

	private String getTypeName(Integer sourcesId) {
		String result = null;
		switch (sourcesId) {
		case 10: {
			result = "折扣";
			break;
		}
		case 20: {
			result = "满减";
			break;
		}
		case 30: {
			result = "秒杀";
			break;
		}
		case 40: {
			result = "团购";
			break;
		}
		case 50: {
			result = "荷兰拍";
			break;
		}
		default: {
			result = "类型有误";
			break;
		}
		}
		return result;
	}

	private String getSourceName(String type) {
		String result = null;
		switch (type) {
		case "00": {
			result = "商城";
			break;
		}
		case "01": {
			result = "CC";
			break;
		}
		case "02": {
			result = "IVR";
			break;
		}
		case "03": {
			result = "手机商城";
			break;
		}
		case "04": {
			result = "短信";
			break;
		}
		case "05": {
			result = "微信广发银行";
			break;
		}
		case "06": {
			result = "微信广发信用卡";
			break;
		}
		case "09": {
			result = "APP";
			break;
		}

		default: {
			result = "渠道有误";
			break;
		}
		}
		return result;
	}

	/**
	 * 复审活动 一次一个活动 要过都过 要不过都不过
	 * 
	 * @param promotionId
	 * @param auditLog
	 * @param status 7通过复审 6 未通过复审
	 * @param user
	 * @return
	 */
	@Override
	public Response<Boolean> doubleCheckPromotion(Integer promotionId, String auditLog, Integer status, User user) {
		Response<Boolean> response = new Response<>();
		try {
			promotionManager.doubleCheckPromotion(promotionId, auditLog, status, user);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("fail to check promotion", Throwables.getStackTraceAsString(e));
			response.setError("promotion.check.error");
		}

		return response;
	}

	/**
	 * 复审单品 一次一条 只适用于有供应商报名的时候 内管审核供应商下报名上来的单品 每审核一条单品 这种情况 每审核一条单品 都需要根据range计算出主活动表应该有什么样的状态 并改之
	 * 
	 * @param id 通过的是那条单品
	 * @param promotionId
	 * @param status
	 * @param user
	 * @return
	 */
	@Override
	public Response<Boolean> doubleCheckRange(Integer id, Integer promotionId, String auditLog, Integer status,
			User user) {
		Response<Boolean> response = new Response<>();
		try {
			PromotionModel promotionModel = promotionDao.findById(promotionId);
			// 把当前本条单品的审核状态改了
			Map<String, Object> rangeMap = Maps.newHashMap();
			rangeMap.put("checkStatus", status);
			rangeMap.put("id", id);
			rangeMap.put("promotionId", promotionId);
			rangeMap.put("auditOper", user.getId());
			if (status == 1) {
				// 通过
				rangeMap.put("auditLog", LocalDateTime.now().toString(dateTimeFormat) + "通过审核，审核意见:【】," + "审核员:【"
						+ user.getName() + "】");
			} else {
				// 拒绝
				rangeMap.put("auditLog", promotionModel.getAuditLog() + LocalDateTime.now().toString(dateTimeFormat)
						+ "拒绝审核，审核意见:【" + auditLog + "】," + "审核员:【" + user.getName() + "】");
			}
			// 把总活动的状态算出来 改了
			RangeStatusDto rangeStatusDto = promotionRangeDao.rangeStatus(promotionId);
			Map<String, Object> promotionMap = Maps.newHashMap();
			promotionMap.put("id", promotionId);
			// 如果此次操作是通过
			if (status == 1) {
				// 这条单品如果通过了 那么主活动只能有两种状态
				// 全部通过复审
				if (rangeStatusDto.getAlready() + 1 == rangeStatusDto.getAll()) {
					// 如果已经通过复审的数量 加上现在通过复审的一条等于活动商品总数
					promotionMap.put("checkStatus", 7);

				} else { // 部分通过复审
					// 其他都是部分通过复审
					promotionMap.put("checkStatus", 8);
				}
			} else {
				// status 2 这条单品被拒绝了
				// 这个参数的值不是1 就是2

				if (rangeStatusDto.getAlready() > 0) {
					// 已经有审核通过的了 部分通过
					promotionMap.put("checkStatus", 8);

				} else if (rangeStatusDto.getRefuse() + 1 == rangeStatusDto.getAll()) {
					// 当前活动下的单品 已经被全部拒绝了 那么置活动主状态为复审未通过
					promotionMap.put("checkStatus", 6);
				} else {
					// 其他中情况 都处于待复审状态 只有活动刚开始报名 并且审核的前些条商品都被拒了 才有可能保持待复审状态
					// 走过了带复审 就无法通过任何操作回到带复审了
					promotionMap.put("checkStatus", 5);
				}

			}

			promotionManager.doubleCheckRange(rangeMap, promotionMap);
			response.setSuccess(Boolean.TRUE);
		} catch (Exception e) {
			log.error("fail to find promotion range", Throwables.getStackTraceAsString(e));
			response.setError("promotion.item.check.error");
		}
		return response;
	}

	// 查询接口
	@Override
	public Response<Pager<PromItemDto>> findRanges(Integer promotionId, Integer checkStatus, String vendorName,
			String itemName, PageInfo pageInfo) {
		Response<Pager<PromItemDto>> response = new Response<>();
		try {
			Map<String, Object> queryMap = Maps.newHashMap();

			if (StringUtils.isNotEmpty(vendorName)) {

				Response<List<String>> vendorServiceIdByName = vendorService.findIdByName(vendorName);
				queryMap.put("vendorIds", vendorServiceIdByName.getResult());
			}
			if (checkStatus != null) {
				queryMap.put("checkStatus", checkStatus);
			}
			if (StringUtils.isNotEmpty(itemName)) {
				queryMap.put("selectName", itemName);
			}
			queryMap.put("promotionId", promotionId);
			queryMap.put("offset", pageInfo.getOffset());
			queryMap.put("limit", pageInfo.getLimit());
			Integer resultCount = promotionRangeDao.promRangeByParamCount(queryMap);
			if (resultCount == 0) {
				response.setResult(Pager.empty(PromItemDto.class));
				return response;
			}
			Response<List<PromItemDto>> promRangeByParam = vendorPromotionService.findPromRangeByParam(queryMap);
			if (!promRangeByParam.isSuccess()) {
				response.setError("query.error");
				return response;
			}
			response.setResult(new Pager<PromItemDto>(Long.valueOf(resultCount), promRangeByParam.getResult()));
		} catch (Exception e) {
			log.error("fail to find range", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}

		return response;
	}

	@Override
	public Response<List<PromotionModel>> findPromotionByRange(Map<String, Object> map) {
		Response<List<PromotionModel>> response = new Response<>();
		try {
			// 当前单品code参加的所有活动
			List<Integer> promotionIds = promotionRangeDao.findPromotionId(map);
			// 拿到所有活动
			List<PromotionModel> promotionByIds = promotionDao.findPromotionByIds(promotionIds);
			response.setResult(promotionByIds);
		} catch (Exception e) {
			log.error("fail to find promotion by itemId", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	@Override
	public Response<Pager<AdminPromotionQueryDto>> findCheckManage(@Param("id") String id,
			@Param("shortName") String shortName, @Param("promType") String promType,
			@Param("checkStatus") String checkStatus, @Param("createOperType") String createOperType,
			@Param("beginDate") String beginDate, @Param("endDate") String endDate, @Param("pageNo") Integer pageNo,
			@Param("size") Integer size) {
		Response<Pager<AdminPromotionQueryDto>> response = new Response<>();
		// 只有内管添加的折扣和满减有初审 其他情况没有初审 所以初审页面写死两个查询条件 一个是创建类型为内管 一个活动类型为折扣和满减
		Map<String, Object> queryMap = Maps.newHashMap();
		if (StringUtils.isNotEmpty(id)) {
			queryMap.put("id", id);
		}
		if (StringUtils.isNotEmpty(shortName)) {
			queryMap.put("shortName", shortName);
		}
		if (StringUtils.isNotEmpty(promType)) {
			queryMap.put("promType", promType);
		}
		if (StringUtils.isNotEmpty(checkStatus)) {
			queryMap.put("checkStatus", checkStatus);
		}
		if (StringUtils.isNotEmpty(beginDate)) {
			queryMap.put("beginDate", beginDate);
		}
		if (StringUtils.isNotEmpty(endDate)) {
			queryMap.put("endDate", endDate);
		}
		PageInfo pageInfo = new PageInfo(pageNo, size);
		queryMap.put("offset", pageInfo.getOffset());
		queryMap.put("limit", pageInfo.getLimit());
		try {
			Integer resultCount = promotionDao.checkManagerCount(queryMap);
			if (resultCount == 0) {
				response.setResult(Pager.empty(AdminPromotionQueryDto.class));
				return response;
			}
			List<PromotionModel> checkManager = promotionDao.findCheckManager(queryMap);
			List<AdminPromotionQueryDto> list = BeanMapper.mapList(checkManager, AdminPromotionQueryDto.class);
			response.setResult(new Pager<AdminPromotionQueryDto>(Long.valueOf(resultCount), list));
		} catch (Exception e) {
			log.error("fail to query", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	@Override
	public Response<Pager<AdminPromotionQueryDto>> findDoubleCheck(@Param("id") String id,
			@Param("shortName") String shortName, @Param("promType") String promType,
			@Param("createOperType") String createOperType, @Param("beginDate") String beginDate,
			@Param("endDate") String endDate, @Param("checkStatus") String checkStatus, @Param("pageNo") Integer pageNo,
			@Param("size") Integer size) {

		Response<Pager<AdminPromotionQueryDto>> response = new Response<>();
		Map<String, Object> queryMap = Maps.newHashMap();
		if (StringUtils.isNotEmpty(id)) {
			queryMap.put("id", id);
		}
		if (StringUtils.isNotEmpty(shortName)) {
			queryMap.put("shortName", shortName);
		}
		if (StringUtils.isNotEmpty(promType)) {
			queryMap.put("promType", promType);
		}
		if (StringUtils.isNotEmpty(checkStatus)) {
			queryMap.put("checkStatus", checkStatus);
		}
		if (StringUtils.isNotEmpty(createOperType)) {
			queryMap.put("createOperType", createOperType);
		}
		if (StringUtils.isNotEmpty(beginDate)) {
			queryMap.put("beginDate", beginDate);
		}
		if (StringUtils.isNotEmpty(endDate)) {
			queryMap.put("endDate", endDate);
		}
		PageInfo pageInfo = new PageInfo(pageNo, size);
		queryMap.put("offset", pageInfo.getOffset());
		queryMap.put("limit", pageInfo.getLimit());
		try {
			Integer resultCount = promotionDao.doubleCheckManagerCount(queryMap);
			if (resultCount == 0) {
				response.setResult(Pager.empty(AdminPromotionQueryDto.class));
				return response;
			}

			List<PromotionModel> doubleCheckManager = promotionDao.findDoubleCheckManager(queryMap);
			// 格式化返回数据
			List<AdminPromotionQueryDto> list = BeanMapper.<AdminPromotionQueryDto>mapList(doubleCheckManager,
					AdminPromotionQueryDto.class);
			response.setResult(new Pager<AdminPromotionQueryDto>(Long.valueOf(resultCount), list));
		} catch (Exception e) {
			log.error("fail to query promotion ", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;

	}

	/**
	 *
	 * @param map
	 * @return
	 */
	@Override
	public Response<List<PromotionModel>> getPromotionForBatch(Map<String, Object> map) {
		Response<List<PromotionModel>> response = new Response<>();
		try {
			List<PromotionModel> promotionForBatch = promotionDao.getPromotionForBatch(map);
			response.setResult(promotionForBatch);
		} catch (Exception e) {
			log.error("fail to find promotion for batch paras ={},cause by {}", map,
					Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}
}
