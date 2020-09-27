package cn.com.cgbchina.promotion.service;

import static com.google.common.base.Preconditions.checkArgument;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.util.*;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.elasticsearch.common.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.Optional;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
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
import cn.com.cgbchina.promotion.dto.PromItemDto;
import cn.com.cgbchina.promotion.dto.PromParamDto;
import cn.com.cgbchina.promotion.dto.PromotionResultDto;
import cn.com.cgbchina.promotion.manager.PromotionManager;
import cn.com.cgbchina.promotion.model.PromotionModel;
import cn.com.cgbchina.promotion.model.PromotionRangeModel;
import cn.com.cgbchina.promotion.model.PromotionVendorModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.Optional;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * @author wangqi
 * @version 1.0
 * @Since 2016/6/13.
 */
@Service
@Slf4j
public class VendorPromotionServiceImpl implements VendorPromotionService {
	private final DateTimeFormatter dateTimeFormat = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
	DateFormat dateFormat = DateFormat.getTimeInstance();// 只显示出时分秒

	public static final JsonMapper JSON_MAPPER = JsonMapper.nonEmptyMapper();
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
	private BackCategoriesService backCategoriesService;
	@Resource
	private BrandService brandService;
	@Resource
	private VendorService vendorService;

	// 本地缓存(单品信息)
	private final LoadingCache<Integer, Optional<PromotionModel>> cacheProm;

	// 构造函数
	public VendorPromotionServiceImpl() {
		cacheProm = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
				.build(new CacheLoader<Integer, Optional<PromotionModel>>() {
					public Optional<PromotionModel> load(Integer id) throws Exception {
						// 允许为空
						return Optional.fromNullable(promotionDao.findById(id));
					}
				});
	}

	/**
	 * 根据ID取得活动信息
	 *
	 * @param id 活动Id
	 * @return
	 */
	@Override
	public Response<PromotionResultDto> findByIdForVendor(Integer id) {
		Response<PromotionResultDto> response = new Response<PromotionResultDto>();
		try {
			if (id == null) {
				response.setSuccess(true);
				response.setResult(new PromotionResultDto());
				return response;
			}
			// 根据活动ID取得活动主表信息
			PromotionModel promModel = this.findPromById(id);
			PromotionResultDto resultDto = new PromotionResultDto();
			// resultDto = BeanUtils.copy(promModel, PromotionResultDto.class);
			BeanUtils.copyProperties(promModel, resultDto);
			if (promModel != null) {
				// 销售渠道Map
				Map<String, String> sourceMap = new HashMap<String, String>();
				sourceMap.put(Contants.PROMOTION_SOURCE_ID_00, Contants.PROMOTION_SOURCE_NAME_00);
				sourceMap.put(Contants.PROMOTION_SOURCE_ID_01, Contants.PROMOTION_SOURCE_NAME_01);
				sourceMap.put(Contants.PROMOTION_SOURCE_ID_02, Contants.PROMOTION_SOURCE_NAME_02);
				sourceMap.put(Contants.PROMOTION_SOURCE_ID_03, Contants.PROMOTION_SOURCE_NAME_03);
				sourceMap.put(Contants.PROMOTION_SOURCE_ID_04, Contants.PROMOTION_SOURCE_NAME_04);
				sourceMap.put(Contants.PROMOTION_SOURCE_ID_05, Contants.PROMOTION_SOURCE_NAME_05);
				sourceMap.put(Contants.PROMOTION_SOURCE_ID_06, Contants.PROMOTION_SOURCE_NAME_06);
				sourceMap.put(Contants.PROMOTION_SOURCE_ID_09, Contants.PROMOTION_SOURCE_NAME_09);
				// 销售渠道Map
				Map<Integer, String> promtypeMap = new HashMap<Integer, String>();
				promtypeMap.put(Contants.PROMOTION_PROM_TYPE_1, Contants.PROMOTION_PROM_TYPE_NAME_1);
				promtypeMap.put(Contants.PROMOTION_PROM_TYPE_2, Contants.PROMOTION_PROM_TYPE_NAME_2);
				promtypeMap.put(Contants.PROMOTION_PROM_TYPE_3, Contants.PROMOTION_PROM_TYPE_NAME_3);
				promtypeMap.put(Contants.PROMOTION_PROM_TYPE_4, Contants.PROMOTION_PROM_TYPE_NAME_4);
				promtypeMap.put(Contants.PROMOTION_PROM_TYPE_5, Contants.PROMOTION_PROM_TYPE_NAME_5);

				// 活动状态名称
				String promName = promtypeMap.get(promModel.getPromType());
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
				if (promModel.getLoopBeginTime1() != null) {
				} else if (promModel.getLoopEndTime1() != null) {
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
					java.text.DecimalFormat df = new java.text.DecimalFormat("#.0");
					resultDto.setRuleDiscountRateFormat(df.format(resultDto.getRuleDiscountRate()));
				}

				/************* 优惠规则 *************/
				/************* 编辑商品范围 *************/
				List<PromItemDto> promItemList = new ArrayList<PromItemDto>();
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("promotionId", id);
				Response<List<PromItemDto>> range = findPromRangeByParam(params);
				if (range.isSuccess()) {
					promItemList = range.getResult();
				}
				resultDto.setPromItemList(promItemList);
				/************* 编辑商品范围 *************/
				// 活动创建者
				if (Contants.PROMOTION_CREATE_OPER_TYPE_0 == resultDto.getCreateOperType()) {
					resultDto.setCreateOperTypeName(Contants.PROMOTION_CREATE_OPER_TYPE_NAME_0);
				} else if (Contants.PROMOTION_CREATE_OPER_TYPE_1 == resultDto.getCreateOperType()) {
					resultDto.setCreateOperTypeName(Contants.PROMOTION_CREATE_OPER_TYPE_NAME_1);
				}
				// 处理渠道数据
				if (StringUtils.isNotEmpty(promModel.getSourceId())) {
					List<String> sourceIdsList = Splitter.on("||").omitEmptyStrings().trimResults()
							.splitToList(promModel.getSourceId());
					String sourceName = "";
					for (String sourceId : sourceIdsList) {
						if (StringUtils.isNotEmpty(sourceName)) {
							sourceName = sourceName + "，";
						}
						sourceName = sourceName + sourceMap.get(sourceId);
					}
					resultDto.setSourceName(sourceName);
				}
			} else {
				response.setError("VendorPromotionServiceImpl.findById.eroor.PromotionModel.null");
				response.setSuccess(false);
				return response;
			}
			response.setSuccess(true);
			response.setResult(resultDto);
		} catch (Exception e) {
			log.error("findById.VendorPromotionServiceImpl.error", Throwables.getStackTraceAsString(e));
			response.setError("findById.VendorPromotionServiceImpl.error");
			response.setSuccess(false);
		}
		// 返回执行结果
		return response;
	}

	/**
	 * 根据活动ID和其他指定条件查询活动选品范围
	 * 
	 * @param params 查询条件
	 * @return
	 */
	public Response<List<PromItemDto>> findPromRangeByParam(Map<String, Object> params) {
		Response<List<PromItemDto>> response = new Response<List<PromItemDto>>();
		try {
			List<PromotionRangeModel> promRangeList = promotionRangeDao.findByParams(params);
			List<PromItemDto> promItemList = new ArrayList<PromItemDto>();

			if (promRangeList != null) {
				for (PromotionRangeModel model : promRangeList) {
					PromItemDto dto = new PromItemDto();
					String backCategoryName = "";
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
					ItemModel itemModel = itemService.findItemDetailByCode(model.getSelectCode());
					if (itemModel != null) {
						GoodsModel goodsModel = goodsService.findById(itemModel.getGoodsCode()).getResult();
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
								if (com.alibaba.dubbo.common.utils.StringUtils
										.isNotEmpty(backCategoryList.get(0).getName())) {
									dto.setBackCategory1Name(backCategoryList.get(0).getName());
									backCategoryName = backCategoryList.get(0).getName();
								}
								if (com.alibaba.dubbo.common.utils.StringUtils
										.isNotEmpty(backCategoryList.get(1).getName())) {
									dto.setBackCategory2Name(backCategoryList.get(1).getName());
									backCategoryName = backCategoryName + ">" + backCategoryList.get(0).getName();
								}
								if (com.alibaba.dubbo.common.utils.StringUtils
										.isNotEmpty(backCategoryList.get(2).getName())) {
									dto.setBackCategory3Name(backCategoryList.get(2).getName());
									backCategoryName = backCategoryName + ">" + backCategoryList.get(0).getName();
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
					if (!"".equals(backCategoryName)) {
						// 编辑后 类目
						dto.setBackCategoryName(backCategoryName);
					}
					promItemList.add(dto);
				}
			}
			response.setResult(promItemList);
			response.setSuccess(true);
		} catch (Exception e) {
			log.error("findPromRangeByParam.VendorPromotionServiceImpl.error", Throwables.getStackTraceAsString(e));
			response.setError("findPromRangeByParam.VendorPromotionServiceImpl.error");
			response.setSuccess(false);
		}
		return response;
	}

	/**
	 * 新增活动（折扣、满减）
	 *
	 * @param promParamDto 活动
	 * @param user
	 * @return
	 */
	@Override
	public Response<Boolean> vendorAddPromotion(PromParamDto promParamDto, User user) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			if (promParamDto == null) {
				response.setError("PromotionServiceImpl.vendorAdd.eroor.PromotionModel.can.not.be.null");
				return response;
			}
			PromotionModel promotionModel = promParamDto.getPromotionModel();
			List<PromotionRangeModel> list = promParamDto.getPromotionRangeModelList();
			PromotionVendorModel promotionVendorModel = promParamDto.getPromotionVendorModel();
			// 校验
			// 非空项目（活动类型、活动简称、活动名称、销售渠道、活动时间）
			if (StringUtils.isEmpty(promotionModel.getShortName()) || StringUtils.isEmpty(promotionModel.getName())
					|| promotionModel.getPromType() == null || promotionModel.getBeginDate() == null
					|| promotionModel.getEndDate() == null) {
				response.setResult(false);
				response.setError("PromotionServiceImpl.vendorAdd.eroor.PromotionModel.can.not.be.null");
				return response;
			}
			// TODO 唯一key
			promotionModel.setPromCode("W000000001");
			// 是否需要报名（0：不需要 1：需要）
			promotionModel.setIsSignup(Contants.PROMOTION_IS_SIGNUP_0);
			// 状态
			// promotionModel.setState(Contants.PROMOTION_STATE_3);
			// 有效状态（0：删除 1：正常）
			promotionModel.setIsValid(Contants.IS_VALID_1);
			// 创建人
			promotionModel.setCreateOper(user.getId());
			// 创建时间
			promotionModel.setCreateTime(new Date());
			// 修改时间
			promotionModel.setModifyOper(user.getId());
			// 修改人
			promotionModel.setModifyTime(new Date());
			/************* 活动选品表 *************/
			// List<PromotionRangeModel> modelList = idetPromRangeList("", promotionRange, user);

			/************* 活动选品表 *************/
			/************* 活动供应商表 *************/
			promotionVendorModel = promParamDto.getPromotionVendorModel();
			promotionVendorModel.setCreateDate(new Date());
			promotionVendorModel.setIsValid(Contants.IS_VALID_1);
			promotionVendorModel.setVendorId(user.getId());
			/************* 活动供应商表 *************/
			promotionManager.vendorAdd(promotionModel, promotionVendorModel, list);
			response.setResult(true);
			return response;
		} catch (Exception e) {
			log.error("addPromotion.PromotionService.error", Throwables.getStackTraceAsString(e));
			response.setError("addPromotion.PromotionService.error");
			response.setResult(false);
		}
		// 返回执行结果
		return response;
	}

	/**
	 * 修改商品范围 / 报名（平台活动）
	 *
	 * @param createOperType 活动创建区分
	 * @param id 活动id
	 * @param promotionRange "|"分割的josn格式字符串
	 * @param user 用户
	 * @return
	 */
	public Response<Boolean> vendorUpdatePromRange(String createOperType, String id, String promotionRange, User user) {
		// 新增/修改商品范围
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 取得供应商ID TODO
			String vendorId = user.getId();
			if (id == null) {
				response.setError("");
				response.setResult(false);
				return response;
			}
			Integer promId = Integer.valueOf(id.trim());
			// 校验
			PromotionModel checkModel = this.findPromById(promId);
			// 活动状态校验(待审批以外不可报名)
			Response<Boolean> checkResult = checkPromAvailable(promId, vendorId);
			if (!checkResult.getResult()) {
				return checkResult;
			}
			PromotionModel promotionModel = new PromotionModel();
			promotionModel.setId(promId);
			promotionModel.setCreateOper(vendorId);
			promotionManager.changePromotionRange(promotionModel, promotionRange, "1");
			/*
			 * List<PromotionRangeModel> modelList = this.idetPromRangeList(id, promotionRange, user); //
			 * 新增/修改活动商品（供应商用） boolean updateResult = promotionManager.addRangeForVendor(modelList);
			 */
			response.setResult(true);
		} catch (Exception e) {
			log.error("addPromotion.PromotionService.error", Throwables.getStackTraceAsString(e));
			response.setError("addPromotion.PromotionService.error");
			response.setResult(false);
		}
		return response;
	}

	/**
	 * 编辑活动商品List
	 * 
	 * @param promotionRange
	 * @param user
	 * @return
	 */
	private List<PromotionRangeModel> idetPromRangeList(String id, String promotionRange, User user) {
		List<PromotionRangeModel> modelList = new ArrayList<PromotionRangeModel>();
		try {
			ObjectMapper mapper = new ObjectMapper();
			Map filterMap = StringUtils.isNotBlank(promotionRange) ? mapper.readValue(promotionRange, Map.class) : null;
			List<Map> rangeList = (List<Map>) filterMap.get("range");

			for (Map map : rangeList) {
				PromotionRangeModel model = new PromotionRangeModel();
				// 参数非空校验
				if (StringUtils.isBlank((String) map.get("promotionId"))
						|| StringUtils.isBlank((String) map.get("selectCode"))
						|| StringUtils.isBlank((String) map.get("selectName"))
						|| StringUtils.isBlank((String) map.get("stock"))
						|| StringUtils.isBlank((String) map.get("price"))
						|| StringUtils.isBlank((String) map.get("seq"))) {

					return new ArrayList<PromotionRangeModel>();
				}
				// 活动ID web参数
				String promotionId = (String) map.get("promotionId");
				model.setPromotionId(Integer.valueOf(promotionId.trim()));
				// 选品ID web参数
				String selectCode = (String) map.get("selectCode");
				model.setSelectCode(selectCode.trim());
				// 选品名称 web参数
				String selectName = (String) map.get("selectName");
				model.setSelectName(selectName); // 选品名称 web参数
				// 库存 web参数
				String stock = (String) map.get("stock");
				model.setStock(Integer.valueOf(stock.trim())); // 库存 web参数
				// 售价 web参数
				String price = (String) map.get("price");
				model.setPrice(new BigDecimal(Double.valueOf(price.trim())));
				// 排序 web参数
				String seq = (String) map.get("seq");
				model.setSeq(Integer.valueOf(seq.trim()));
				// 费用承担方(0 行方 1 供应商)
				model.setCostBy(1);
				// 是否可以使用优惠卷(1 可以 0 不可以) web参数
				model.setCouponEnable(Contants.PROMOTION_COUPONENABLE_1);
				model.setRangeType(0); // 范围类型（0 单品）
				model.setIsValid(Contants.IS_VALID_1); // 有效状态：0删除，1正常
				model.setCreateTime(new Date()); // 创建时间
				model.setCreateOper(user.getId()); // 创建者
				model.setCreateOperType(Contants.PROMOTION_CREATE_OPER_TYPE_1); // 创建者类型
				model.setModifyTime(new Date()); // 修改时间
				model.setModifyOper(user.getId()); // 修改者
				model.setModifyOperType(Contants.PROMOTION_CREATE_OPER_TYPE_1); // 修改者类型
				model.setCheckStatus(Contants.PROMOTION_RANGE_CHECK_STATUS_0); // 选品状态
				modelList.add(model);
			}
		} catch (Exception e) {
			log.error("vendorUpdate.PromotionService.error", Throwables.getStackTraceAsString(e));
		}
		return modelList;
	}
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
	@Override
	public Response<Pager<PromotionResultDto>> findPromotionListForAdmin(@Param("checkStatus") String checkStatus, @Param("promType") String promType,
																		  @Param("shortName") String shortName, @Param("promCode") String promCode,
																		  @Param("beginDate") String beginDate, @Param("endDate") String endDate,
																		  @Param("beginEntryDate") String beginEntryDate, @Param("endEntryDate") String endEntryDate,
																		  @Param("goodsName") String goodsName, @Param("entryState") String entryState,
																		  @Param("pageNo") Integer pageNo, @Param("size") Integer size) {

		Response<Pager<PromotionResultDto>> pagerResponse = new Response<Pager<PromotionResultDto>>();
		Pager<PromotionModel> response = new Pager<PromotionModel>();
		Pager<PromotionResultDto> resultDtoPager = new Pager<PromotionResultDto>();
		try {

			PageInfo pageInfo = new PageInfo(pageNo, size);
			Map<String, Object> params = new HashMap<String, Object>();
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
				params.put("shortName", "%" + shortName + "%");
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
			params.put("isValid", "1");
			params.put("createOperType","0");
			if (StringUtils.isEmpty(goodsName)) {
				response = promotionDao.findBySelectNameForAdminPage(params, pageInfo.getOffset(), pageInfo.getLimit());
			} else {
				Map<String, Object> rangeParams = new HashMap<String, Object>();
				params.put("selectName", "%" + goodsName + "%");

				List<PromotionRangeModel> promotionRangeModelList = new ArrayList<PromotionRangeModel>();
				promotionRangeModelList = promotionRangeDao.findByParams(rangeParams);

				String promotionIdList = "";
				for (PromotionRangeModel promotionRangeModel : promotionRangeModelList) {
					promotionIdList += "," + promotionRangeModel.getPromotionId();
				}

				params.put("promotionIdList", promotionIdList);

				response = promotionDao.findBySelectNameForAdminPage(params, pageInfo.getOffset(), pageInfo.getLimit());
			}

			List<PromotionResultDto> list = new ArrayList<PromotionResultDto>();

			User user = UserUtil.getUser();
			String vendorId = user.getVendorId(); // 供应商ID

			List<PromotionModel> modelList = response.getData();
			// 列表中活动当前供应商是否可以报名
			for (PromotionModel promotionModel : modelList) {
				PromotionResultDto result = new PromotionResultDto();
				BeanUtils.copyProperties(promotionModel, result);
				// 活动ID
				Integer promotionId = promotionModel.getId();
				// 活动当前供应商是否可以报名
				Response<Boolean> checkResult = checkPromAvailable(promotionId, vendorId);
				result.setPromAvailable(checkResult.getResult());
				list.add(result);
			}
			resultDtoPager.setData(list);
			resultDtoPager.setTotal(Long.valueOf(list.size()));
		} catch (Exception e) {
			log.error("vendorFindPromotionList.PromotionService.error", Throwables.getStackTraceAsString(e));
		}
		pagerResponse.setResult(resultDtoPager);
		return pagerResponse;
	}

	/**
	 * 根据查询条件取得供应商活动数据列表
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
	@Override
	public Response<Pager<PromotionResultDto>> findPromotionListForVendor(@Param("checkStatus") String checkStatus,
			@Param("createOperType") String createOperType, @Param("promType") String promType,
			@Param("shortName") String shortName, @Param("promCode") String promCode,
			@Param("beginDate") String beginDate, @Param("endDate") String endDate,
			@Param("beginEntryDate") String beginEntryDate, @Param("endEntryDate") String endEntryDate,
			@Param("goodsName") String goodsName, @Param("entryState") String entryState,
			@Param("pageNo") Integer pageNo, @Param("size") Integer size) {

		Response<Pager<PromotionResultDto>> pagerResponse = new Response<Pager<PromotionResultDto>>();
		Pager<PromotionModel> response = new Pager<PromotionModel>();
		Pager<PromotionResultDto> resultDtoPager = new Pager<PromotionResultDto>();
		try {

			PageInfo pageInfo = new PageInfo(pageNo, size);
			Map<String, Object> params = new HashMap<String, Object>();
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
				params.put("shortName", "%" + shortName + "%");
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
			params.put("isValid", "1");
			params.put("createOperType","1");
			if (StringUtils.isEmpty(goodsName)) {
				response = promotionDao.findBySelectNamePage(params, pageInfo.getOffset(), pageInfo.getLimit());
			} else {
				Map<String, Object> rangeParams = new HashMap<String, Object>();
				params.put("selectName", "%" + goodsName + "%");

				List<PromotionRangeModel> promotionRangeModelList = new ArrayList<PromotionRangeModel>();
				promotionRangeModelList = promotionRangeDao.findByParams(rangeParams);

				String promotionIdList = "";
				for (PromotionRangeModel promotionRangeModel : promotionRangeModelList) {
					promotionIdList += "," + promotionRangeModel.getPromotionId();
				}

				params.put("promotionIdList", promotionIdList);

				response = promotionDao.findBySelectNamePage(params, pageInfo.getOffset(), pageInfo.getLimit());
			}

			List<PromotionResultDto> list = new ArrayList<PromotionResultDto>();

			User user = UserUtil.getUser();
			String vendorId = user.getVendorId(); // 供应商ID

			List<PromotionModel> modelList = response.getData();
			// 列表中活动当前供应商是否可以报名
			for (PromotionModel promotionModel : modelList) {
				PromotionResultDto result = new PromotionResultDto();
				BeanUtils.copyProperties(promotionModel, result);
				// 活动ID
				Integer promotionId = promotionModel.getId();
				// 活动当前供应商是否可以报名
				Response<Boolean> checkResult = checkPromAvailable(promotionId, vendorId);
				result.setPromAvailable(checkResult.getResult());
				list.add(result);
			}
			resultDtoPager.setData(list);
			resultDtoPager.setTotal(Long.valueOf(list.size()));
		} catch (Exception e) {
			log.error("vendorFindPromotionList.PromotionService.error", Throwables.getStackTraceAsString(e));
		}
		pagerResponse.setResult(resultDtoPager);
		return pagerResponse;
	}

	/**
	 * 返回有效的活动
	 *
	 * @param promotionId
	 * @param vendorId
	 * @return
	 */
	private Response<Boolean> checkPromAvailable(Integer promotionId, String vendorId) {
		Response<Boolean> response = new Response<Boolean>();
		boolean result = false;
		// 根据ID取得活动主表信息
		PromotionModel promotionModel = findPromById(promotionId);
		Map<String, Object> params = new HashMap<String, Object>();

		if (promotionModel == null) {
			// TODO 错误信息待修改
			response.setError("该活动不存在");
			response.setResult(false);
			return response;
		}
		// 尚未开始的活动并且可用的活动
		if (promotionModel.getBeginDate() != null && promotionModel.getIsValid() != null) {
			// 已开始的活动或不可用的活动
			if (promotionModel.getBeginDate().getTime() <= new Date().getTime() || promotionModel.getIsValid() != 1) {
				// TODO 错误信息待修改
				response.setError("该活动已开始或已失效");
				response.setResult(false);
				return response;
			}
		} else {
			// TODO 错误信息待修改
			response.setError("该活动数据异常");
			response.setResult(false);
			return response;
		}
		// 供应商自建活动，未提交状态下可修改
		if (promotionModel.getCreateOperType() == Contants.PROMOTION_CREATE_OPER_TYPE_1
				&& Contants.PROMOTION_STATE_0.equals(promotionModel.getCheckStatus())) {
			// 供应商自建活动，无需判断是否可报名
			response.setResult(true);
			return response;
		}
		// 需要报名
		if (promotionModel.getIsSignup() == Contants.PROMOTION_IS_SIGNUP_1) {
			params.put("promotionId", promotionId);
			Integer promCount = promotionVendorDao.promAvailable(params);
			if (promCount > 0) {
				params.put("promotionId", promotionId);
				params.put("vendorId", vendorId);
				promCount = promotionVendorDao.promAvailable(params);
				if (promCount > 0) {
					if (Contants.PROMOTION_STATE_3.equals(promotionModel.getCheckStatus())
							|| Contants.PROMOTION_STATE_5.equals(promotionModel.getCheckStatus())
							|| Contants.PROMOTION_STATE_6.equals(promotionModel.getCheckStatus())
							|| Contants.PROMOTION_STATE_7.equals(promotionModel.getCheckStatus())
							|| Contants.PROMOTION_STATE_8.equals(promotionModel.getCheckStatus())) {
						// 可用（需要报名，并且包含当前供应商 ）
						response.setResult(true);
					} else {
						// 不可用
						response.setResult(false);
					}
				} else {
					// 不可用（需要报名，但不包含当前供应商）
					response.setError("该活动已开始或已失效");
					response.setResult(false);
				}
			} else {
				if (Contants.PROMOTION_STATE_3.equals(promotionModel.getCheckStatus())
						|| Contants.PROMOTION_STATE_5.equals(promotionModel.getCheckStatus())
						|| Contants.PROMOTION_STATE_6.equals(promotionModel.getCheckStatus())
						|| Contants.PROMOTION_STATE_7.equals(promotionModel.getCheckStatus())
						|| Contants.PROMOTION_STATE_8.equals(promotionModel.getCheckStatus())) {
					// 可用
					response.setResult(true);
				} else {
					// 不可用
					response.setResult(false);
				}
			}
		} else {
			// 不可用（不需要报名）
			response.setError("该活动无需报名");
			response.setResult(false);
		}
		return response;
	}

	/*
	 * 根据CODE取得单品信息
	 *
	 * @return 单品信息
	 */
	private PromotionModel findPromById(Integer id) {
		Optional<PromotionModel> model = this.cacheProm.getUnchecked(id);
		if (model.isPresent()) {
			return model.get();
		}
		return null;
	}

	/**
	 * 根据vendorID获取当前正在参加活动的单品IdList
	 *
	 * @param vendorId 查询条件
	 * @return
	 * @author yanjie.cao
	 */
	@Override
	public Response<List<String>> findItemCodesByVendorId(String vendorId) {
		Response<List<String>>response=new Response<>();
		List<Integer>promotionIds=Lists.newArrayList();
		List<String>itemCodes=Lists.newArrayList();
		try{
			checkArgument(StringUtils.isNotBlank(vendorId), "vendorId.can.not.be.empty");
			Map<String,Object>promotionMap= Maps.newHashMap();
			promotionMap.put("currentDate", DateTime.now());
			promotionIds=promotionDao.findPromotionIds(promotionMap);
			if (promotionIds.isEmpty()||promotionIds==null){
				response.setResult(itemCodes);
				return response;
			}
			Map<String,Object>promotionRangeMap=Maps.newHashMap();
			promotionRangeMap.put("promotionIds",promotionIds);
			promotionRangeMap.put("vendor_id",vendorId);
			itemCodes=promotionRangeDao.findItemCodes(promotionRangeMap);
            response.setResult(itemCodes);
			return response;
		}catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e){
			log.error("VendorPromotionServiceImpl.findItemCodesByVendorId.qury.error", Throwables.getStackTraceAsString(e));
			response.setError("VendorPromotionServiceImpl.findItemCodesByVendorId.qury.error");
			return response;
		}
	}

}
