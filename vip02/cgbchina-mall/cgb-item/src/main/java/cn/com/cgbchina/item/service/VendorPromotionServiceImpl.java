package cn.com.cgbchina.item.service;

import static com.google.common.base.Preconditions.checkArgument;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;
import javax.annotation.Resource;

import cn.com.cgbchina.item.dao.GroupClassifyRedisDao;
import cn.com.cgbchina.item.model.GroupClassify;
import com.google.common.base.Function;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.Interval;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.search.Pair;
import com.spirit.user.User;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.EscapeUtil;
import cn.com.cgbchina.item.dao.PromotionDao;
import cn.com.cgbchina.item.dao.PromotionRangeDao;
import cn.com.cgbchina.item.dao.PromotionVendorDao;
import cn.com.cgbchina.item.dto.PromItemDto;
import cn.com.cgbchina.item.dto.PromotionResultDto;
import cn.com.cgbchina.item.manager.PromotionManager;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PromotionModel;
import cn.com.cgbchina.item.model.PromotionRangeModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author wangqi
 * @version 1.0
 */
@Service
@Slf4j
public class VendorPromotionServiceImpl implements VendorPromotionService {
	private DateFormat dateFormat = DateFormat.getTimeInstance();// 只显示出时分秒
	@Resource
	private PromotionManager promotionManager;
	@Resource
	private PromotionDao promotionDao;
	@Resource
	private PromotionRangeDao promotionRangeDao;
	@Resource
	private PromotionVendorDao promotionVendorDao;
	@Resource
	private ItemService itemService;
	@Resource
	private GoodsService goodsService;
	@Resource
	private BrandService brandService;
	@Resource
	private VendorService vendorService;
	@Resource
	private GroupClassifyRedisDao groupClassifyRedisDao;


	private final Map<Integer, String> typeNameMap = ImmutableMap.<Integer, String>builder().put(10, "折扣")
			.put(20, "满减").put(30, "秒杀").put(40, "团购").put(50, "荷兰拍").build();
	private final ImmutableMap<String, String> sourceNameMap = ImmutableMap.<String, String>builder().put("00", "商城")
			.put("01", "CC").put("02", "IVR").put("03", "手机商城").put("04", "短信").put("05", "微信广发银行").put("06", "微信广发信用卡")
			.put("09", "APP").build();

	/**
	 * 根据ID取得活动信息
	 *
	 * @param id 活动Id
	 */
	@Override
	public Response<PromotionResultDto> findByIdForVendor(Integer id, User user) {
		Response<PromotionResultDto> response = new Response<>();
		try {
			if (id == null) {
				response.setError("query.error");
				return response;
			}
			// 根据活动ID取得活动主表信息
			// PromotionModel promModel = this.findPromById(id);
			PromotionModel promModel = promotionDao.findById(id);
			PromotionResultDto resultDto = new PromotionResultDto();
			// resultDto = BeanUtils.copy(promModel, PromotionResultDto.class);
			if (promModel != null) {
				BeanUtils.copyProperties(promModel, resultDto);

				// 活动状态名称
				String promName = typeNameMap.get(promModel.getPromType());
				if (promName != null) {
					resultDto.setPromTypeName(promName);
				}
				/************* 循环执行规则 *************/
				// 每天（10：50-15：30）
				String loopJobFormat = "";
				if (Contants.PROMOTION_LOOP_TYPE_D.equals(promModel.getLoopType())) {
					loopJobFormat = "每天";
				} else if (Contants.PROMOTION_LOOP_TYPE_W.equals(promModel.getLoopType())) {
					loopJobFormat = "每周";
				} else if (Contants.PROMOTION_LOOP_TYPE_M.equals(promModel.getLoopType())) {
					loopJobFormat = "每月";
				}
				if (promModel.getLoopBeginTime1() != null && promModel.getLoopEndTime1() != null) {
					dateFormat.format(promModel.getLoopBeginTime1());
					loopJobFormat = loopJobFormat + "（" + dateFormat.format(promModel.getLoopBeginTime1()) + "-"
							+ dateFormat.format(promModel.getLoopEndTime1().getTime()) + "）";
				}

				if (promModel.getLoopBeginTime2() != null && promModel.getLoopEndTime2() != null) {
					loopJobFormat = loopJobFormat + "（" + dateFormat.format(promModel.getLoopBeginTime2()) + "-"
							+ dateFormat.format(promModel.getLoopEndTime2()) + "）";
				}
				resultDto.setLoopJobFormat(loopJobFormat);

				/************* 循环执行规则 *************/
				/************* 优惠规则 *************/
				if (resultDto.getRuleDiscountRate() != null) {
					java.text.DecimalFormat df = new java.text.DecimalFormat("0.00");
					resultDto.setRuleDiscountRateFormat(df.format(resultDto.getRuleDiscountRate()));
				}

				/************* 优惠规则 *************/
				/************* 编辑商品范围 *************/
				List<PromItemDto> promItemList = new ArrayList<>();
				Map<String, Object> params = new HashMap<>();
				params.put("promotionId", id);
				params.put("vendorId", user.getVendorId());
				Response<List<PromItemDto>> range = findPromRangeByParam(params);
				if (range.isSuccess()) {
					promItemList = range.getResult();
				}
				resultDto.setPromItemList(promItemList);
				/************* 编辑商品范围 *************/
				// 活动创建者
				if (Contants.PROMOTION_CREATE_OPER_TYPE_0.equals(resultDto.getCreateOperType())) {
					resultDto.setCreateOperTypeName(Contants.PROMOTION_CREATE_OPER_TYPE_NAME_0);
				} else if ((Contants.PROMOTION_CREATE_OPER_TYPE_1).equals(resultDto.getCreateOperType())) {
					resultDto.setCreateOperTypeName(Contants.PROMOTION_CREATE_OPER_TYPE_NAME_1);
				}
				// 处理渠道数据
				if (StringUtils.isNotEmpty(promModel.getSourceId())) {
					List<String> sourceIdsList = Splitter.on("||").omitEmptyStrings().trimResults()
							.splitToList(promModel.getSourceId());
					StringBuffer sourceName = new StringBuffer();
					for (String sourceId : sourceIdsList) {
						if (StringUtils.isNotEmpty(sourceName)) {
							sourceName.append(", ");
						}
						sourceName.append(sourceNameMap.get(sourceId));
					}
					resultDto.setSourceName(String.valueOf(sourceName));
				}
			} else {
				response.setError("VendorPromotionServiceImpl.findById.eroor.PromotionModel.null");
				return response;
			}
			response.setResult(resultDto);
		} catch (Exception e) {
			log.error("findById.VendorPromotionServiceImpl.error", e);
			response.setError("findById.VendorPromotionServiceImpl.error");
		}
		// 返回执行结果
		return response;
	}

	/**
	 * 根据活动ID和其他指定条件查询活动选品范围
	 *
	 * @param params 查询条件
	 */
	public Response<List<PromItemDto>> findPromRangeByParam(Map<String, Object> params) {
		Response<List<PromItemDto>> response = new Response<>();
		try {
			List<PromotionRangeModel> promRangeList = promotionRangeDao.findByParams(params);
			List<GroupClassify> groupClassifies = groupClassifyRedisDao.allGroupClassify();
			ImmutableMap<Long, GroupClassify> longGroupClassifyImmutableMap = Maps.uniqueIndex(groupClassifies, new Function<GroupClassify, Long>() {
				@Override
				public Long apply(GroupClassify groupClassify) {
					return groupClassify.getId();
				}
			});
			List<PromItemDto> promItemList = new ArrayList<>();

			if (promRangeList != null) {
				for (PromotionRangeModel model : promRangeList) {
					PromItemDto dto = new PromItemDto();
					dto.setId(model.getId()); // 活动选取范围ID
					if (model.getSeq() != null) {
						dto.setSort(model.getSeq().toString());
					}
					dto.setItemCode(model.getSelectCode()); // 选品编码
					dto.setGoodsName(model.getSelectName()); // 选品名称
					dto.setPrice(model.getPrice()); // 选品价格
					dto.setStock(model.getStock()); // 选品库存
					dto.setAuditLog(model.getAuditLog()); // 审核日志
					dto.setCostBy(model.getCostBy());// 费用承担方
					dto.setCheckStatus(model.getCheckStatus());// 选品状态
					dto.setSort(String.valueOf(model.getSeq()));// 排序
					dto.setStartPrice(model.getStartPrice());// 起拍价
					dto.setMinPrice(model.getMinPrice());// 最低价
					dto.setFeeRange(model.getFeeRange());// 降价金额
					dto.setCouponEnable(model.getCouponEnable());// 是否使用优惠卷
					dto.setLevelPrice(model.getLevelPrice());// 阶梯
					dto.setPerStock(model.getPerStock());//单场库存 如果是整场 该字段与整体库存数一致
					//团购分类
					GroupClassify groupClassify = longGroupClassifyImmutableMap.get(model.getGroupClassify());
					if(groupClassify!=null){
					dto.setGroupClassifyName(groupClassify.getName());
					}
					ItemModel itemModel = itemService.findItemDetailByCode(model.getSelectCode());
                    StringBuilder backCategoryName = new StringBuilder();
					StringBuilder backCategoryIds = new StringBuilder();
					if (itemModel != null) {
						GoodsModel goodsModel = goodsService.findById(itemModel.getGoodsCode()).getResult();
						if (goodsModel != null) {
							// 后台类目
							Response<List<Pair>> pairResponse = goodsService.findCategoryByGoodsCode(goodsModel.getCode());
							if (!pairResponse.isSuccess()) {
                                log.error("findPromRangeByParam.findCategoryByGoodsCode.error{}", pairResponse.getError());
                                response.setError(pairResponse.getError());
								return response;
							}
							List<Pair> pairList = pairResponse.getResult();
                            int size = pairList.size();
                            Pair pair;
                            // 第一级是所有分类，不需要显示
                            for (int i = 1; i < size; i++) {
                                pair = pairList.get(i);
                                switch (i) {
                                    case 1:
                                        dto.setBackCategory1Name(pair.getName());
                                        backCategoryName.append(pair.getName());
                                        backCategoryIds.append(pair.getId().toString());
                                        break;
                                    case 2:
                                        dto.setBackCategory2Name(pair.getName());
                                        backCategoryName.append(">");
                                        backCategoryName.append(pair.getName());
                                        backCategoryIds.append(",");
                                        backCategoryIds.append(pair.getId().toString());
                                        break;
                                    case 3:
                                        dto.setBackCategory3Name(pair.getName());
                                        backCategoryName.append(">");
                                        backCategoryName.append(pair.getName());
                                        backCategoryIds.append(",");
                                        backCategoryIds.append(pair.getId().toString());
                                        break;
                                    default:
                                        break;
                                }
                            }

							// 品牌
							GoodsBrandModel goodsBrandModel = brandService
									.findBrandInfoById(goodsModel.getGoodsBrandId()).getResult();
							dto.setGoodsBrandName(goodsBrandModel.getBrandName());
							// 供应商 通过供应商id查询供应商名
							Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(model.getVendorId());
							dto.setVendor(vendorInfoDtoResponse.getResult().getSimpleName());
						}
					}
                    dto.setBackCategoryName(backCategoryName.length() == 0 ? null : backCategoryName.toString());
                    dto.setBackCategory(backCategoryIds.length() == 0 ? null : backCategoryIds.toString());
					promItemList.add(dto);
				}
			}
			response.setResult(promItemList);
		} catch (Exception e) {
			log.error("findPromRangeByParam.VendorPromotionServiceImpl.error{}", Throwables.getStackTraceAsString(e));
			response.setError("findPromRangeByParam.VendorPromotionServiceImpl.error");
		}
		return response;
	}


	/**
	 * 修改商品范围 / 报名（平台活动）
	 *
	 * @param createOperType 活动创建区分
	 * @param id 活动id
	 * @param promotionRange "|"分割的josn格式字符串
	 * @param user 用户
	 */
	public Response<String> vendorUpdatePromRange(String createOperType, String id, String promotionRange, User user) {
		// 新增/修改商品范围
		Response<String> response = new Response<>();
		try {
			// 取得供应商ID
			String vendorId = user.getVendorId();
			if (id == null) {
				response.setError("vendor.not.exist.error");
				return response;
			}
			Integer promId = Integer.valueOf(id.trim());
			// 活动状态校验(待审批以外不可报名)
			Response<Boolean> checkResult = checkPromAvailableForAdmin(promId, vendorId);
			if (checkResult.getResult()==null || !checkResult.getResult()) {
				response.setError("prom.signup.expired.error");
				return response;
			}
			//得到活动基本信息 传过去必须的数据 不要传审核状态 审核状态用于判断是否属于报名
			PromotionModel promotionModel = promotionDao.findById(Integer.valueOf(StringUtils.trim(id)));
			PromotionModel para=new PromotionModel();
			para.setId(promotionModel.getId());//活动id
			para.setBeginDate(promotionModel.getBeginDate());//活动开始时间
			para.setEndDate(promotionModel.getEndDate());
			para.setCreateOper(user.getId());//把供应商报名的人通过promotion传过去  这个字段此时不当做活动创建人使用  活动创建人是内管的userid
			//活动报名的时候只更新活动范围 不更新活动基本信息 此字段无用
			String resultInfo = promotionManager.changePromotionRange(para, promotionRange, vendorId);

			response.setResult(resultInfo);
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("vendorUpdatePromRange.PromotionService.error {}", Throwables.getStackTraceAsString(e));
			response.setError("vendorUpdatePromRange.PromotionService.error");
		}
		return response;
	}


	/**
	 * 根据查询条件取得平台活动数据列表
	 */
	@Override
	public Response<Pager<PromotionResultDto>> findPromotionListForAdmin(@Param("checkStatus") String checkStatus,
			@Param("promType") String promType, @Param("shortName") String shortName,
			@Param("promCode") String promCode, @Param("beginDate") String beginDate, @Param("endDate") String endDate,
			@Param("beginEntryDate") String beginEntryDate, @Param("endEntryDate") String endEntryDate,
			@Param("entryState") String entryState, @Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("user") User user) {

		Response<Pager<PromotionResultDto>> pagerResponse = new Response<>();
		Pager<PromotionModel> response;
		Pager<PromotionResultDto> resultDtoPager = new Pager<>();
		try {

			PageInfo pageInfo = new PageInfo(pageNo, size);
			Map<String, Object> params = new HashMap<>();
			if (StringUtils.isNotEmpty(checkStatus)) {
				params.put("checkStatus", checkStatus);
			}
			if (StringUtils.isNotEmpty(promCode)) {
				params.put("id", promCode);
			}
			if (StringUtils.isNotEmpty(promType)) {
				params.put("promType", promType);
			}
			if (StringUtils.isNotEmpty(shortName)) {
				params.put("shortName", EscapeUtil.allLikeStr(shortName));
			}
			if (StringUtils.isNotEmpty(beginDate)) {
				params.put("beginDate", beginDate);
			}
			if (StringUtils.isNotEmpty(endDate)) {
				params.put("endDate", endDate);
			}
			if (StringUtils.isNotEmpty(beginEntryDate)) {
				params.put("beginEntryDate", beginEntryDate);
			}
			if (StringUtils.isNotEmpty(endEntryDate)) {
				params.put("endEntryDate", endEntryDate);
			}
			params.put("isValid", 1);
			params.put("createOperType", 0);
			response = promotionDao.findBySelectNameForAdminPage(params, pageInfo.getOffset(), pageInfo.getLimit());
			List<PromotionResultDto> list = new ArrayList<>();
			String vendorId = user.getVendorId(); // 供应商ID
			List<PromotionModel> modelList = response.getData();
			// 列表中活动当前供应商是否可以报名
			for (PromotionModel promotionModel : modelList) {
				PromotionResultDto result = new PromotionResultDto();
				BeanUtils.copyProperties(promotionModel, result);
				// 活动ID
				Integer promotionId = promotionModel.getId();
				// 活动当前供应商是否可以报名
				Response<Boolean> checkResult = checkPromAvailableForAdmin(promotionId, vendorId);
				result.setPromAvailable(checkResult.getResult());
				list.add(result);
			}
			resultDtoPager.setData(list);
			resultDtoPager.setTotal((long)list.size());
		} catch (Exception e) {
			log.error("vendorFindPromotionList.PromotionService.error:{}", Throwables.getStackTraceAsString(e));
		}
		pagerResponse.setResult(resultDtoPager);
		return pagerResponse;
	}

	/**
	 * 根据查询条件取得供应商活动数据列表
	 *
	 */
	@Override
	public Response<Pager<PromotionResultDto>> findPromotionListForVendor(@Param("checkStatus") String checkStatus,
			@Param("createOperType") String createOperType, @Param("promType") String promType,
			@Param("shortName") String shortName, @Param("promCode") String promCode,
			@Param("beginDate") String beginDate, @Param("endDate") String endDate,
			@Param("beginEntryDate") String beginEntryDate, @Param("endEntryDate") String endEntryDate,
			@Param("entryState") String entryState, @Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("user") User user) {

		Response<Pager<PromotionResultDto>> pagerResponse = new Response<>();
		Pager<PromotionModel> response;
		Pager<PromotionResultDto> resultDtoPager = new Pager<>();
		try {

			PageInfo pageInfo = new PageInfo(pageNo, size);
			Map<String, Object> params = new HashMap<>();
			if (StringUtils.isNotEmpty(checkStatus)) {
				params.put("checkStatus", checkStatus);
			}
			if (StringUtils.isNotEmpty(promCode)) {
				params.put("id", promCode);
			}
			if (StringUtils.isNotEmpty(promType)) {
				params.put("promType", promType);
			}
			if (StringUtils.isNotEmpty(shortName)) {
				params.put("shortName", EscapeUtil.allLikeStr(shortName));
			}
			if (StringUtils.isNotEmpty(beginDate)) {
				params.put("beginDate", beginDate);
			}
			if (StringUtils.isNotEmpty(endDate)) {
				params.put("endDate", endDate);
			}
			if (StringUtils.isNotEmpty(beginEntryDate)) {
				params.put("beginEntryDate", beginEntryDate);
			}
			if (StringUtils.isNotEmpty(endEntryDate)) {
				params.put("endEntryDate", endEntryDate);
			}
			if (StringUtils.isNotEmpty(createOperType)) {
				params.put("createOperType", createOperType);
			}
			// params.put("entryState", entryState);
			params.put("isValid", 1);
			params.put("createOperType", 1);
			if (user != null) {
				params.put("createOper", user.getId());
			}

			response = promotionDao.findBySelectNamePage(params, pageInfo.getOffset(), pageInfo.getLimit());

			List<PromotionResultDto> list = new ArrayList<>();

			List<PromotionModel> modelList = response.getData();
			// 列表中活动当前供应商是否可以报名
			for (PromotionModel promotionModel : modelList) {
				PromotionResultDto result = new PromotionResultDto();
				BeanUtils.copyProperties(promotionModel, result);
				// 活动ID
				Integer promotionId = promotionModel.getId();
				// 活动当前供应商是否可以报名
				Response<Boolean> checkResult = checkPromAvailableForVendor(promotionId);
				result.setPromAvailable(checkResult.getResult());
				list.add(result);
			}
			resultDtoPager.setData(list);
			resultDtoPager.setTotal(Long.valueOf(list.size()));
		} catch (Exception e) {
			log.error("vendorFindPromotionList.PromotionService.error{}", Throwables.getStackTraceAsString(e));
		}
		pagerResponse.setResult(resultDtoPager);
		return pagerResponse;
	}

	/**
	 * 用于判断供应商自建活动是否可编辑
	 *
	 */
	private Response<Boolean> checkPromAvailableForVendor(Integer promotionId) {
		Response<Boolean> response = new Response<>();
		// 默认为false
		response.setResult(false);
		// 根据ID取得活动主表信息
		PromotionModel promotionModel = promotionDao.findById(promotionId);
		if (promotionModel == null) {
			response.setError("该活动不存在");
			return response;
		}
		// 供应商自建活动，未提交状态下可修改
		if (Contants.PROMOTION_CREATE_OPER_TYPE_1.equals(promotionModel.getCreateOperType())
				&& Contants.PROMOTION_STATE_0.equals(promotionModel.getCheckStatus())) {
			response.setResult(true);
			return response;
		}
		// 被内管拒绝后可修改
		if (6 == promotionModel.getCheckStatus()) {
			response.setResult(true);
		}
		return response;

	}

	/**
	 * 返回有效的活动
	 */
	private Response<Boolean> checkPromAvailableForAdmin(Integer promotionId, String vendorId) {
		Response<Boolean> response = new Response<>();
		// 根据ID取得活动主表信息
		PromotionModel promotionModel = promotionDao.findById(promotionId);
		if (promotionModel == null) {
			response.setError("该活动不存在");
			return response;
		}
		// 尚未开始的活动并且可用的活动
		if (promotionModel.getBeginDate() != null && promotionModel.getIsValid() != null) {
			// 已开始的活动或不可用的活动
			if (promotionModel.getBeginDate().getTime() <= new Date().getTime() || promotionModel.getIsValid() != 1) {
				response.setError("该活动已开始或已失效");
				return response;
			}
		} else {
			response.setError("该活动数据异常");
			return response;
		}
		// 需要报名
		if (Contants.PROMOTION_IS_SIGNUP_1.equals(promotionModel.getIsSignup())) {
			Interval interval = new Interval(promotionModel.getBeginEntryDate().getTime(),
					promotionModel.getEndEntryDate().getTime());
			if (!interval.contains(DateTime.now())) {
				response.setResult(false);
				return response;
			} else {
				Map<String, Object> params = new HashMap<>();
				params.put("promotionId", promotionId);
				Integer promCount = promotionVendorDao.promAvailable(params);
				if (promCount > 0) {
					params.put("vendorId", vendorId);
					promCount = promotionVendorDao.promAvailable(params);
					if (promCount > 0) {
						response.setResult(true);
					} else {
						// 不可用（需要报名，但不包含当前供应商）
						response.setError("当前供应商不在报名范围内");
					}
				} else {
					response.setResult(true);
				}
			}
		} else {
			// 不可用（不需要报名）
			response.setError("该活动无需报名");
		}
		return response;
	}

	/**
	 * 根据vendorID获取当前正在参加活动的单品IdList
	 *
	 * @param vendorId 查询条件
	 */
	@Override
	public Response<List<String>> findItemCodesByVendorId(String vendorId) {
		Response<List<String>> response = new Response<>();
		List<String> itemCodes = Lists.newArrayList();
		try {
			checkArgument(StringUtils.isNotBlank(vendorId), "vendorId.can.not.be.empty");
			Map<String, Object> promotionMap = Maps.newHashMap();
			promotionMap.put("currentDate", new Date());
			List<Integer> promotionIds = promotionDao.findPromotionIds(promotionMap);
			if (promotionIds.isEmpty()) {
				response.setResult(itemCodes);
				return response;
			}
			Map<String, Object> promotionRangeMap = Maps.newHashMap();
			promotionRangeMap.put("promotionIds", promotionIds);
			promotionRangeMap.put("vendor_id", vendorId);
			itemCodes = promotionRangeDao.findItemCodes(promotionRangeMap);
			response.setResult(itemCodes);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("VendorPromotionServiceImpl.findItemCodesByVendorId.qury.error{}",
					Throwables.getStackTraceAsString(e));
			response.setError("VendorPromotionServiceImpl.findItemCodesByVendorId.qury.error");
			return response;
		}
	}

}
