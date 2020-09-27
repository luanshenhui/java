package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.GroupClassifyRedisDao;
import cn.com.cgbchina.item.dao.PromotionDao;
import cn.com.cgbchina.item.dao.PromotionPeriodDao;
import cn.com.cgbchina.item.dao.PromotionRangeDao;
import cn.com.cgbchina.item.dao.PromotionRedisDao;
import cn.com.cgbchina.item.dto.GoodsGroupBuyDto;
import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.dto.MallPromotionSaleInfoDto;
import cn.com.cgbchina.item.dto.PromotionItemResultDto;
import cn.com.cgbchina.item.dto.PromotionPeriodDetailDto;
import cn.com.cgbchina.item.dto.UserHollandaucLimit;
import cn.com.cgbchina.item.manager.PromotionManager;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.GroupClassify;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PromotionModel;
import cn.com.cgbchina.item.model.PromotionPeriodModel;
import cn.com.cgbchina.item.model.PromotionRangeModel;
import cn.com.cgbchina.item.model.PromotionRedisModel;
import com.google.common.base.Function;
import com.google.common.base.MoreObjects;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.category.service.AttributeService;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.utils.DistributedLocks;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.Duration;
import org.joda.time.Interval;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
@SuppressWarnings("unchecked")
public class MallPromotionServiceImpl implements MallPromotionService {

	@Resource
	private PromotionDao promotionDao;
	@Resource
	private PromotionRangeDao promotionRangeDao;
	@Resource
	private PromotionPeriodDao promotionPeriodDao;
	@Resource
	private PromotionRedisDao promotionRedisDao;
	@Resource
	private ItemService itemService;
	@Resource
	private GoodsDao goodsDao;
	@Resource
    private AttributeService attributeService;
	@Resource
	private GroupClassifyRedisDao groupClassifyRedisDao;
	@Resource
	private JedisTemplate jedisTemplate;

	private DateTimeFormatter df1 = DateTimeFormat.forPattern("yyyyMMdd");
	private DateTimeFormatter dft = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
	@Resource
	private PromotionManager promotionManager;


	/* 荷兰拍判定用区分 */
	private ThreadLocal<Boolean> ollandauchFlg=new ThreadLocal<Boolean>(){
		@Override
		protected Boolean initialValue() {
			return Boolean.FALSE;
		}
	};


	/**
	 * 获取广发团信息
	 *
	 * @return geshuo 20160704
	 */
	@Override
	public Response<Map<String, Object>> findGroupBuyData() {
		Response<Map<String, Object>> response = new Response<>();
		try {
			Integer firstPromotionId = null;
			Map<String, Object> result = Maps.newHashMap();
			// 查询活动
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_YG);// 广发商城
			paramMap.put("promType", Contants.PROMOTION_PROM_TYPE_4);// 活动类型:团购

			// 已提交(已通过) 已提交(部分通过) 正在进行
			paramMap.put("statusList", ImmutableList.of(Contants.PROMOTION_STATE_7,Contants.PROMOTION_STATE_8,Contants.PROMOTION_STATE_9));
            paramMap.put("sourceId",Contants.PROMOTION_SOURCE_ID_00);
			List<PromotionPeriodModel> periodList = Lists.newArrayList();
			List<PromotionModel> periodPromotionList;
			Map<Integer, PromotionModel> promotionMap = Maps.newHashMap();// 团购活动map
			// 查询主表，查询当前有效的活动的id列表
			List<Integer> availableIdList = promotionDao.findAvailablePromotionIds(paramMap);
			if (availableIdList.size() > 0) {
				periodList = promotionPeriodDao.findNowPromotion(availableIdList);// 循环执行的活动id列表
				if (periodList.size() > 0) {
					periodPromotionList = promotionDao.findPromotionByIds(Lists.transform(periodList, new Function<PromotionPeriodModel, Integer>() {
						@Override
						public Integer apply(PromotionPeriodModel promotionPeriodModel) {
							return promotionPeriodModel.getPromotionId();
						}
					}));
					if(periodPromotionList.size()!=0){
						firstPromotionId = periodPromotionList.get(0).getId();
						for (PromotionModel promModel : periodPromotionList) {
							if (promModel.getPromType().equals(Contants.PROMOTION_PROM_TYPE_4)) {
								Integer promId = promModel.getId();
								promotionMap.put(promId, promModel);// id作为key
							}
						}
					}
				}
			}

			/* 构造nav bar数据开始 ------------------------------------------------- */
			List<MallPromotionResultDto> navBarList = Lists.newArrayList();
			// 分场次取得活动,每个活动id为一场

				for(PromotionPeriodModel periodModel:periodList){
					Integer promotionId = periodModel.getPromotionId();
					MallPromotionResultDto promDto = new MallPromotionResultDto();
					promDto.setPromStatus("0");//正在进行的活动
					promDto.setId(promotionId);
					promDto.setPeriodId(String.valueOf(periodModel.getId()));
					promDto.setBeginDate(periodModel.getBeginDate());

					PromotionModel tempProm = promotionMap.get(promotionId);
					promDto.setShortName(tempProm.getShortName());
					navBarList.add(promDto);
				}

			// 查询未来的活动列表,导航栏用
			List<PromotionPeriodModel> futurePeriodList = promotionPeriodDao.findFuturePeriod();
			if(futurePeriodList.size() > 0){
				//收集所有类型的活动id
				paramMap.put("idList",Lists.transform(futurePeriodList, new Function<PromotionPeriodModel, Integer>() {
					@Override
					public Integer apply(PromotionPeriodModel promotionPeriodModel) {
						return promotionPeriodModel.getPromotionId();
					}
				}));

				//过滤出团购活动
				List<PromotionModel> filterPromotion = promotionDao.findByIdListAndType(paramMap);
				List<Integer> filterIdList = Lists.newArrayList();//id列表
				for(PromotionModel promotionModel:filterPromotion){
					Integer promotionId = promotionModel.getId();
					filterIdList.add(promotionId);
					promotionMap.put(promotionId,promotionModel);
				}
				for(PromotionPeriodModel periodModel:futurePeriodList){
					if(filterIdList.contains(periodModel.getPromotionId())){
						Integer promotionId = periodModel.getPromotionId();
						MallPromotionResultDto promDto = new MallPromotionResultDto();
						promDto.setPromStatus("1");//未来的活动
						promDto.setId(promotionId);
						promDto.setPeriodId(String.valueOf(periodModel.getId()));
						promDto.setBeginDate(periodModel.getBeginDate());
						PromotionModel tempProm = promotionMap.get(promotionId);
						promDto.setShortName(tempProm.getShortName());//团购简称
						navBarList.add(promDto);
					}
				}

				if(firstPromotionId == null && navBarList.size() > 0){
					firstPromotionId = navBarList.get(0).getId();
				}
			}
			/* 构造nav bar数据结束 ------------------------------------------------- */

			if(firstPromotionId == null){
				//现在和将来都没有活动
				response.setResult(result);
				return response;
			}

			result.put("promotionId", firstPromotionId);// 当前活动id
			result.put("navBarList",navBarList);
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("MallPromotionServiceImpl.findGroupBuyData.error{}", Throwables.getStackTraceAsString(e));
			response.setError("MallPromotionServiceImpl.findGroupBuyData.error");
			return response;
		}
	}



	/**
	 * 根据 活动id场次id获取团购活动商品列表
	 *
	 */
	@Override
	public Response<Map<String,Object>> findGoodsByPromAndPeriod(Integer promotionId,Integer periodId){
		// 定义返回结果
		Response<Map<String,Object>> response = Response.newResponse();
		Map<String,Object> resultMap = Maps.newHashMap();
		try {
			List<GroupClassify> groupClassifyList = groupClassifyRedisDao.allGroupClassify();
            resultMap.put("groupClassifies",groupClassifyList);
			//场次切换
			PromotionPeriodModel periodModel = promotionPeriodDao.findById(periodId);
			resultMap.put("beginDate",periodModel.getBeginDate().getTime());
			resultMap.put("endDate",periodModel.getEndDate().getTime());
			resultMap.put("nowTime",DateTime.now().toDate().getTime());
			// 查询活动商品详情
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("promotionId", promotionId);
			List<PromotionRangeModel> rangeAllList = promotionRangeDao.findByPromIdAndClassify(paramMap);
			Long firstClassify=groupClassifyList.size()>0?groupClassifyList.get(0).getId():-1L;//有分类 取第一个 没有什么都不取  前台默认选中第一个
			paramMap.put("groupClassify",firstClassify);
			List<PromotionRangeModel> rangeList = promotionRangeDao.findByPromIdAndClassify(paramMap);
			resultMap.put("promotionGoodsList",findRangeDetail(rangeList,promotionId,periodId));
			resultMap.put("allGoodsList",findRangeDetail(rangeAllList,promotionId,periodId));//全部类目商品
			resultMap.put("currentPromStatus",isOnlinePromotion(new DateTime(periodModel.getBeginDate().getTime()).toString(dft),new DateTime(periodModel.getEndDate().getTime()).toString(dft)));
			//当前活动状态  0：进行中 1：待开始 2：已结束 ""：失败
			response.setResult(resultMap);
			return response;
		} catch (Exception e) {
			log.error("prom.find.group.error{}",
					Throwables.getStackTraceAsString(e));
			response.setError("prom.find.group.error");
			return response;
		}
	}
	@Override
	public Response<List<GoodsGroupBuyDto>> findGroupGoodsByClassifyAndProm(Integer promotionId,Long classifyId,Integer periodId){
		Response<List<GoodsGroupBuyDto>> response=Response.newResponse();
		try {
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("promotionId", promotionId);
			paramMap.put("groupClassify",classifyId);
			List<PromotionRangeModel> rangeList = promotionRangeDao.findByPromIdAndClassify(paramMap);
			List<GoodsGroupBuyDto> rangeDetail = findRangeDetail(rangeList, promotionId, periodId);
			response.setResult(rangeDetail);
		}catch (Exception e){
			log.error("查询团购商品信息失败",e);
			response.setError("prom.find.group.error");
		}
		return response;
	}



	/**
	 * 查询团购商品详细信息
	 * @param rangeList 活动商品
	 * @return 详细信息
	 *
	 * geshuo 20160908
	 */
	private List<GoodsGroupBuyDto> findRangeDetail(List<PromotionRangeModel> rangeList,Integer promotionId,Integer periodId){
		// 活动单品id列表
		List<String> itemCodesList = Lists.newArrayList();
		Map<String, PromotionRangeModel> rangeMap = Maps.newHashMap();
		for (PromotionRangeModel rangeItem : rangeList) {
			String itemCode = rangeItem.getSelectCode();
			itemCodesList.add(itemCode);// 单品id
			rangeMap.put(itemCode, rangeItem);
		}

		// 查询活动单品详细
		Response<List<ItemGoodsDetailDto>> itemDetailResponse = itemService.findByIds(itemCodesList);
		if (!itemDetailResponse.isSuccess()) {
			throw new ResponseException("itemService.findByIds.error");
		}

		List<ItemGoodsDetailDto> itemDetailList = itemDetailResponse.getResult();
		List<GoodsGroupBuyDto> goodsList = Lists.newArrayList();
		// 获取类目下的活动商品
		for (ItemGoodsDetailDto itemDetailDto : itemDetailList) {
			String goodsCode = itemDetailDto.getGoodsCode();
			String itemCode = itemDetailDto.getCode();
			PromotionRangeModel rangeItem = rangeMap.get(itemCode);// 活动商品Model

			GoodsGroupBuyDto promotionGoodsItem = new GoodsGroupBuyDto();
			promotionGoodsItem.setGoodsCode(goodsCode);// 商品编码
			promotionGoodsItem.setItemCode(itemCode);// 单品id
			promotionGoodsItem.setGoodsImg(itemDetailDto.getImage1());// 使用单品第一张图片

			String number = StringUtils.isEmpty(itemDetailDto.getMaxNumber()) ? "1" : itemDetailDto.getMaxNumber();// 如果分期数为空，默认为1
			promotionGoodsItem.setInstallmentNumber(number);// 分期数
			BigDecimal newPrice = rangeItem.getLevelPrice();
			promotionGoodsItem
					.setGroupPrice(String.valueOf(newPrice.divide(new BigDecimal(number), 2, BigDecimal.ROUND_HALF_UP)));// 价格

			// 显示商品名称 = 商品名称+单品属性
			promotionGoodsItem.setGoodsName(itemDetailDto.getGoodsName());

			Response<MallPromotionSaleInfoDto> saleInfoResponse = findPromSaleInfoByPromId(
					String.valueOf(promotionId), String.valueOf(periodId), itemCode);
			if (saleInfoResponse.isSuccess()) {
				MallPromotionSaleInfoDto saleInfoResult = saleInfoResponse.getResult();
				if (saleInfoResult != null) {
					Integer buyCount = (saleInfoResult.getSaleAmountAll() == null) ? Integer.valueOf(0)
							: saleInfoResult.getSaleAmountAll();
					promotionGoodsItem.setBuyCount(String.valueOf(buyCount));
				}
			}

			goodsList.add(promotionGoodsItem);
		}
		return goodsList;
	}

	@Override
	public Response<MallPromotionResultDto> findPromotionByPromIdAndPeriodId(String promId,String periodId) {
		Response<MallPromotionResultDto> response = new Response<>();
		// 当前日期
		String nowDate = LocalDate.now().toString(df1);
		try {
			if (StringUtils.isNotEmpty(promId)) {
				MallPromotionResultDto resultDto = new MallPromotionResultDto();
				// 活动基本信息
				PromotionRedisModel promotionRedisModel = promotionRedisDao.findPromById(promId);
				if(promotionRedisModel==null||promotionRedisModel.getId()==null){
					response.setError("promotion.not.exist");
					return response;
				}
				BeanUtils.copyProperties(promotionRedisModel, resultDto);
				if(StringUtils.isNotEmpty(periodId)){
					//根据场次id获取精确值
					PromotionPeriodModel periodModel = promotionPeriodDao.findById(Integer.valueOf(periodId));
                     resultDto.setBeginDate(periodModel.getBeginDate());
					 resultDto.setEndDate(periodModel.getEndDate());
					 resultDto.setPromNowDate(LocalDateTime.now().toDate());
					//计算出是否正在进行
					resultDto.setPromStatus(isOnlinePromotion(LocalDateTime.fromDateFields(resultDto.getBeginDate()).toString(dft),LocalDateTime.fromDateFields(resultDto.getEndDate()).toString(dft)));
				}
				// 活动所属单品信息
				Map<String, Object> params = Maps.newHashMap();
				params.put("promotionId", promId);
				params.put("checkStatus", "1");
				List<PromotionRangeModel> list = promotionRangeDao.findByParams(params);

				List<PromotionItemResultDto> dtoList = Lists.newArrayList();
				for (PromotionRangeModel range : list) {

					PromotionItemResultDto dto = new PromotionItemResultDto();
					BeanUtils.copyProperties(range, dto);
					ItemModel itemModel = itemService.findById(range.getSelectCode());
					dto.setInstallmentNumber(itemModel.getInstallmentNumber());
					dto.setImage1(itemModel.getImage1());
					dto.setNowDate(nowDate);
					dtoList.add(dto);
				}
				resultDto.setPromItemResultList(dtoList);
				response.setResult(resultDto);
			} else {
				response.setError("prom.query.error");
			}
		} catch (Exception e) {
			log.error("MallPromotionServiceImpl.findPromotionByPromId.error{}", Throwables.getStackTraceAsString(e));
			response.setError("prom.query.error");
		}
		return response;

	}



	/**
	 * 查找进行中活动 或 距离现时点最近的代开始活动
	 *
	 * @param searchPromType 查询条件
	 * @return MallPromotionResultDto
	 */
	private MallPromotionResultDto findPromOnline(Integer searchPromType) {
		// 当前日期
		String todayDate = LocalDate.now().toString(df1);
		Date promNowDate = LocalDateTime.now().toDate();
		MallPromotionResultDto resultDto = new MallPromotionResultDto();
		try {
			// 取得今日所有活动ID
			List<String> promIdList = promotionRedisDao.findPromIdListByDate(todayDate);
			for (String str : promIdList) {
				List<String> strList = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(str);
				if (strList.size() > 4) {
					String promId = strList.get(0); // 活动ID
					String promType = strList.get(1); // 活动类型
					String startDate = strList.get(2); // 开始时间
					String endDate = strList.get(3); // 结束时间
					String periodId = strList.get(4); // 场次ID

					Date bDate = dft.parseDateTime(startDate).toDate();
					Date eDate = dft.parseDateTime(endDate).toDate();
					// 指定类型
					if (StringUtils.isNotEmpty(promType) && promType.equals(String.valueOf(searchPromType))) {
						String isOnline = isOnlinePromotion(startDate, endDate);
						// 进行中 或 即将开始
						if ("0".equals(isOnline) || "1".equals(isOnline)) {
							// 取得活动基本
							PromotionRedisModel model = promotionRedisDao.findPromById(promId);
							// 商城渠道
							//荷兰拍被手动下线后  会有多余的荷兰拍留在列表中 变成空 在往下找可能还有荷兰拍存在
							if (model!=null && model.getId() == null) {
								continue;
							}
							if (model != null && model.getSourceId().contains(Contants.PROMOTION_SOURCE_ID_00)) {
								// 返回活动基本信息
								BeanUtils.copyProperties(model, resultDto);
								// 活动当前状态
								resultDto.setPromStatus(isOnline);
								// 当前时间
								resultDto.setPromNowDate(promNowDate);
								resultDto.setPeriodId(periodId);
								// 单场开始时间
								resultDto.setBeginDate(bDate);
								// 单场结束时间
								resultDto.setEndDate(eDate);
								return resultDto;
							}
						}
					}
				}
			}
		} catch (Exception e) {
			log.error("MallPromotionServiceImpl.findPromOnline.error{}", Throwables.getStackTraceAsString(e));
			return null;
		}
		return null;
	}

	/**
	 * 取得荷兰拍数据
	 *
	 * @return MallPromotionResultDto
	 */
	@Override
	public Response<MallPromotionResultDto> findHollandauc() {
		Response<MallPromotionResultDto> response = new Response<>();
		try {
			// 判定区分重置
			ollandauchFlg.set(Boolean.FALSE);
			response = this.idetHollandauc();
			if (response.isSuccess()) {
				// 需要重新取得荷兰拍数据
				if (ollandauchFlg.get()) {
					response = this.idetHollandauc();
				}
			}
			ollandauchFlg.remove();
		} catch (Exception e) {
			log.error("MallPromotionServiceImpl.findPromInfoForAuctions.error{}", Throwables.getStackTraceAsString(e));
			response.setError("MallPromotionServiceImpl.findPromInfoForAuctions.error");
		}
		return response;

	}

	/**
	 * 取得荷兰拍数据
	 *
	 * @return MallPromotionResultDto
	 */
	private Response<MallPromotionResultDto> idetHollandauc() {
		Response<MallPromotionResultDto> response = new Response<>();
		try {
			// 查找进行中活动 或 距离现时点最近的代开始活动
			MallPromotionResultDto resultDto = this.findPromOnline(Contants.PROMOTION_PROM_TYPE_5);
			if (resultDto == null) {
				response.setResult(new MallPromotionResultDto());
				return response;
			}
			if ("0".equals(resultDto.getPromStatus())) {
				// 活动ID
				String promId = String.valueOf(resultDto.getId());
				String periodId = resultDto.getPeriodId();
				// 判断已拍完数据是否存在
//				List<String> rangeIdList = new ArrayList<String>();
				// 取得栏位1-6数据
				List<Map<String, String>> mapList = promotionRedisDao.findAuctionsFieldsByKey(promId, periodId, 6);
				List<String> waitList = promotionRedisDao.findAuctionsRangeListByKey(promId, periodId);
				List<PromotionItemResultDto> itemList = Lists.newArrayList();
				Integer count = 0;
				for (Map<String, String> map : mapList) {
					String rangeId = map.get("rangeId");
					String startTime = map.get("startTime");
					if (StringUtils.isNotEmpty(rangeId)) {
						PromotionRangeModel model = promotionRangeDao.findById(Integer.valueOf(rangeId));
						PromotionItemResultDto dto = new PromotionItemResultDto();
						BeanUtils.copyProperties(model, dto);
						//每0.5秒降价金额
						BigDecimal money = dto.getFeeRange().divide(new BigDecimal(resultDto.getRuleFrequency()).multiply(
								new BigDecimal(2)), 2, BigDecimal.ROUND_HALF_EVEN);
						if (count < 3) {
							// 开拍时间
							dto.setStartDate(startTime);
							String nowTime = LocalDateTime.now().toString(dft);
							// 当前时间
							dto.setNowDate(nowTime);
							// 计算时间差
							DateTime dateTime1 = dft.parseDateTime(startTime);
							DateTime dateTime2 = dft.parseDateTime(nowTime);
							Duration duration = new Duration(dateTime1, dateTime2);
							int second = duration.toStandardSeconds().getSeconds();
							// 降至最低价所需的降价次数
							if (dto.getStartPrice() != null && dto.getFeeRange() != null) {
								BigDecimal nowPrice = dto.getStartPrice()
										.subtract(money.multiply(new BigDecimal(second * 2)));
								// 正在拍卖商品 计算当前时点价格
								dto.setPrice(nowPrice);
								// 小于最小金额，数据异常。终止活动
								if (dto.getMinPrice() != null && nowPrice.compareTo(dto.getMinPrice()) < 0) {
									// 刷新redis,终止数据取得操作
									this.batchProm();
									ollandauchFlg.set(Boolean.TRUE);
								}
							}
						}
						// 每0.5秒降价金额
						dto.setFeeRange(money);

						ItemModel itemModel = itemService.findById(dto.getSelectCode());
						if (itemModel != null) {
							GoodsModel goodModel = goodsDao.findById(itemModel.getGoodsCode());
							// 图片地址
							dto.setImage1(itemModel.getImage1());
							// 属性列表

							dto.setAttributeKey1(itemModel.getAttributeKey1());//销售属性 sku
                            dto.setAttributeKey2(itemModel.getAttributeKey2());
							dto.setAttributeName1(itemModel.getAttributeName1());
							dto.setAttributeName2(itemModel.getAttributeName2());
							dto.setSpuAttributes(attributeService.findSpuAttributesBy(goodModel.getProductId()));
                            dto.setIntroduction(goodModel.getIntroduction());
						}
						// rangeIdList.add(rangeId);
						itemList.add(dto);
					} else {
						itemList.add(new PromotionItemResultDto());
					}
					count = count + 1;
				}
				/*
				 * rangeIdList = new ArrayList<String>(); rangeIdList.addAll(waitList);
				 */
				if (waitList.size() > 0) {
					List<PromotionRangeModel> list = promotionRangeDao.findByRangIds(waitList);
					for (PromotionRangeModel model : list) {
						PromotionItemResultDto dto = new PromotionItemResultDto();
						BeanUtils.copyProperties(model, dto);
						// 每0.5秒减价数
						BigDecimal money = dto.getFeeRange().divide(new BigDecimal(resultDto.getRuleFrequency()).multiply(
								new BigDecimal(2)), 2, BigDecimal.ROUND_HALF_EVEN);
						// 每0.5秒降价金额
						dto.setFeeRange(money);
						ItemModel itemModel = itemService.findById(dto.getSelectCode());
						GoodsModel goodModel = goodsDao.findById(itemModel.getGoodsCode());
						dto.setIntroduction(goodModel.getIntroduction());

						// 图片地址
						dto.setImage1(itemModel.getImage1());
						// 属性列表
						dto.setSpuAttributes(attributeService.findSpuAttributesBy(goodModel.getProductId()));
						itemList.add(dto);
					}
				}

				resultDto.setPromItemResultList(itemList);
			} else if ("1".equals(resultDto.getPromStatus()) && resultDto.getId() != null) {
				// 活动所属单品信息
				Map<String, Object> params = Maps.newHashMap();
				params.put("promotionId", resultDto.getId());
				params.put("checkStatus", "1");
				List<PromotionRangeModel> list = promotionRangeDao.findByParams(params);

				List<PromotionItemResultDto> itemList = Lists.newArrayList();
				if (list != null) {
					itemList = BeanMapper.mapList(list, PromotionItemResultDto.class);
				}
				// 取图片地址
				for (PromotionItemResultDto dto : itemList) {
					// 取图片地址
					ItemModel itemModel = itemService.findById(dto.getSelectCode());
					GoodsModel goodModel = goodsDao.findById(itemModel.getGoodsCode());
					dto.setIntroduction(goodModel.getIntroduction());
					// 图片地址
					dto.setImage1(itemModel.getImage1());
					// 属性列表
					dto.setSpuAttributes(attributeService.findSpuAttributesBy(goodModel.getProductId()));

				}
				resultDto.setPromItemResultList(itemList);
			}
			response.setResult(resultDto);
		} catch (Exception e) {
			log.error("MallPromotionServiceImpl.findPromInfoForAuctions.error{}", Throwables.getStackTraceAsString(e));
			response.setError("MallPromotionServiceImpl.findPromInfoForAuctions.error");
		}
		return response;

	}

	/**
	 * 取得已拍卖完的单品列表
	 *
	 * @param promId 活动ID
	 * @return wangqi 20160723
	 */
	public Response<List<PromotionItemResultDto>> findHollandaucForOver(String promId, String periodId) {
		Response<List<PromotionItemResultDto>> response = Response.newResponse();
		List<PromotionItemResultDto> promotionItemResultDtoList = Lists.newArrayList();
		// 活动ID为空时，返回空值。
		if (StringUtils.isEmpty(promId)) {
			response.setResult(Collections.<PromotionItemResultDto>emptyList());
		} else {
			// 根据活动ID取得所包含活动单品信息
			Map<String, Object> params = Maps.newHashMap();
			params.put("promotionId", promId);
			params.put("checkStatus", "1");
			List<PromotionRangeModel> list = promotionRangeDao.findByParams(params);

			List<PromotionItemResultDto> itemList = BeanMapper.mapList(list, PromotionItemResultDto.class);
			for (PromotionItemResultDto dto : itemList) {
				// 取得当前活动销售以及库存信息
				Response<MallPromotionSaleInfoDto> responseSaleInfoDto = this.findPromSaleInfoByPromId(promId, periodId,
						dto.getSelectCode());
				if (responseSaleInfoDto.isSuccess()) {
					MallPromotionSaleInfoDto saleInfoDto = responseSaleInfoDto.getResult();
					// 判断是否是已售完单品
					if (saleInfoDto.getSaleAmountToday() != null && saleInfoDto.getStockAmountTody() != null &&
							MoreObjects.firstNonNull(saleInfoDto.getSaleAmountToday(),0)>=saleInfoDto.getStockAmountTody()) {
						ItemModel itemModel = itemService.findById(dto.getSelectCode());
						// 图片
						dto.setImage1(itemModel.getImage1());
						promotionItemResultDtoList.add(dto);
					}
				}
			}
		}
		// 返回已售完单品信息
		response.setResult(promotionItemResultDtoList);
		return response;
	}

	/**
	 * 判断 活动状态（现时点）
	 *
	 * @return 0：进行中 1：待开始 2：已结束 ""：失败
	 */
	private String isOnlinePromotion(String startDate, String endDate) {
		try {
			DateTime now = DateTime.now();
			Date bDate = dft.parseLocalDateTime(startDate).toDate();
			Date eDate = dft.parseLocalDateTime(endDate).toDate();
			Interval interval = new Interval(bDate.getTime(), eDate.getTime());
			if (interval.contains(now)) {
				return "0";
			} else if (eDate.before(now.toDate())) {

				return "2";
			} else if (bDate.after(now.toDate())) {
				return "1";
			} else {
				return "";
			}
		} catch (Exception e) {
			log.error("MallPromotionServiceImpl.isOnlinePromotion.error{}", Throwables.getStackTraceAsString(e));
			return "";
		}
	}

	/**
	 * 取得秒杀活动列表（距离现时点最近的活动包含选品列表）
	 *review
	 * @return wangqi 20160713
	 */
	@Override
	public Response<List<MallPromotionResultDto>> findPromListByPromType(String searchPromType) {
		Response<List<MallPromotionResultDto>> response = new Response<>();
		List<MallPromotionResultDto> resultList = Lists.newArrayList();
		List<MallPromotionResultDto> nowList=Lists.newArrayList();//正在进行或待开始
		List<MallPromotionResultDto> overList=Lists.newArrayList();//已经结束
		// 当前日期
		String todayDate = LocalDateTime.now().toString(df1);
		try {
			// 取得今日所有活动ID
			List<String> promIdList = promotionRedisDao.findPromIdListByDate(todayDate);
			for (String str : promIdList) {
				List<String> strList = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(str);
				MallPromotionResultDto resultDto = new MallPromotionResultDto();
				if (strList.size() > 4) {
					String promId = strList.get(0); // 活动ID
					String promType = strList.get(1); // 活动类型
					String startDate = strList.get(2); // 开始时间
					String endDate = strList.get(3); // 结束时间
					String periodId = strList.get(4); // 场次ID

					Date bDate = dft.parseLocalDateTime(startDate).toDate();
					Date eDate = dft.parseLocalDateTime(endDate).toDate();
					// 指定类型
					if (StringUtils.isNotEmpty(promType) && promType.equals(String.valueOf(searchPromType))) {
						// 取得活动基本
						PromotionRedisModel model = promotionRedisDao.findPromById(promId);
						// 商城渠道
						if (model != null && StringUtils.isNotEmpty(model.getSourceId())
								&& model.getSourceId().contains(Contants.PROMOTION_SOURCE_ID_00)) {
							// 返回活动基本信息
							BeanUtils.copyProperties(model, resultDto);
							//非活动本身的开始时间 有循环任务的话是循环任务的小时间段
							String isOnline = this.isOnlinePromotion(startDate, endDate);
							// 进行中 或 即将开始 只有活动中或即将开始的活动才回去查单品信息  已经结束的列表中显示在后面 默认不查单品信息
							if ("0".equals(isOnline) || "1".equals(isOnline)) {
								// 活动所属单品信息
								if (resultDto.getId() != null) {
									Map<String, Object> params = Maps.newHashMap();
									params.put("promotionId", resultDto.getId());
									params.put("checkStatus", 1);
									List<PromotionRangeModel> list = promotionRangeDao.findByParams(params);
									List<PromotionItemResultDto> itemList = Lists.newArrayList();
									if (list != null) {
										itemList = BeanMapper.mapList(list, PromotionItemResultDto.class);
									}
									resultDto.setPromItemResultList(itemList);
								}
							}
							// 活动当前状态
							resultDto.setPromNowDate(LocalDateTime.now().toDate());
							resultDto.setPromStatus(isOnline);
							resultDto.setPeriodId(periodId);
							// 单场开始时间
							resultDto.setBeginDate(bDate);
							// 单场结束时间
							resultDto.setEndDate(eDate);
							//根据活动状态进行分拣 0：进行中 1：待开始 2：已结束
							switch (isOnline){
								case "0":
								case "1":
									nowList.add(resultDto);
									break;
								case "2":
									overList.add(resultDto);
									break;
							}
						}
					}
				}
			}

			//分拣
            resultList.addAll(nowList);//正在进行或待开始放前面
			resultList.addAll(overList);//已经结束放后面
			response.setResult(resultList);
		} catch (Exception e) {
			log.error("MallPromotionServiceImpl.findPromListByPromType.error{}", Throwables.getStackTraceAsString(e));
			response.setError("MallPromotionServiceImpl.findPromListByPromType.error");
		}
		return response;

	}

	/**
	 * 根据单品CODE 获取现时点参加的活动
	 *
	 * @param type 0:包含即将开始活动 1：只需要进行中活动
	 * @param itemCode 单品CODE
	 * @param sourceId 渠道（如空值，默认商城渠道）
	 * @return 活动信息 wangqi 20160713s
	 */
	@Override
	public Response<MallPromotionResultDto> findPromByItemCodes(String type, String itemCode, String sourceId) {
		Response<MallPromotionResultDto> response = new Response<>();
		try {
			if (StringUtils.isEmpty(itemCode)) {
				response.setError("MallPromotionServiceImpl.findPromByItemCodes.error");
				return response;
			}
			// 当前日期
			String todayDate = LocalDate.now().toString(df1);
			Date promNowDate = LocalDateTime.now().toDate();
			// 商城渠道（如空值 默认商城渠道）
			if (StringUtils.isEmpty(sourceId)) {
				sourceId = Contants.PROMOTION_SOURCE_ID_00;
			}
			List<String> itemList = promotionRedisDao.findItemList(itemCode, todayDate);
			MallPromotionResultDto resultDto = null;
			for (String str : itemList) {
				List<String> strList = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(str);
				if (strList.size() > 3) {
					String promId = strList.get(0); // 活动ID
					String startDate = strList.get(1); // 开始时间
					String endDate = strList.get(2); // 结束时间
					String periodId = strList.get(3); // 场次ID

					Date bDate = dft.parseLocalDateTime(startDate).toDate();
					Date eDate = dft.parseLocalDateTime(endDate).toDate();
					// 取得活动基本
					PromotionRedisModel model = promotionRedisDao.findPromById(promId);
					// 渠道匹配
					if (StringUtils.isNotEmpty(model.getSourceId()) && model.getSourceId().contains(sourceId)) {
						// 判断是否是进行中或待开始的活动
						String isOnline = this.isOnlinePromotion(startDate, endDate);
						// 正在进行中或待开始的活动 同时返回所属单品信息。其余活动不返回单品信息
						if ("0".equals(type)) {
							if ("2".equals(isOnline)) {
								continue;
							}
						} else { // 只包含进行中活动
							if ("1".equals(isOnline) || "2".equals(isOnline)) {
								continue;
							}
						}
						resultDto = new MallPromotionResultDto();
						BeanUtils.copyProperties(model, resultDto);
						resultDto.setPromStatus(isOnline);
						resultDto.setPeriodId(periodId);
						resultDto.setPromNowDate(promNowDate);
						// 单场开始时间
						resultDto.setBeginDate(bDate);
						// 单场结束时间
						resultDto.setEndDate(eDate);
						break;
					}
				}
			}
			if (resultDto != null) {
				Map<String, Object> params = Maps.newHashMap();
				params.put("selectCode", itemCode);
				params.put("promotionId", resultDto.getId());
				params.put("checkStatus", "1");
				List<PromotionRangeModel> list = promotionRangeDao.findByParams(params);
				if (list != null && list.size() > 0) {
					List<PromotionItemResultDto> itemResultList = BeanMapper.mapList(list,
							PromotionItemResultDto.class);
					resultDto.setPromItemResultList(itemResultList);
					for (PromotionItemResultDto dto : itemResultList) {
						MallPromotionSaleInfoDto saleInfo = promotionRedisDao
								.findPromBuyCount(String.valueOf(resultDto.getId()), resultDto.getPeriodId(), itemCode);
						if (saleInfo.getSaleAmountAll() == null) {
							dto.setBuyCount(0);
						} else {
							dto.setBuyCount(saleInfo.getSaleAmountAll());
						}
					}
				}
			}
			response.setResult(resultDto);
		} catch (Exception e) {
			log.error("MallPromotionServiceImpl.findPromByItemCodes.error{}", Throwables.getStackTraceAsString(e));
			response.setError("MallPromotionServiceImpl.findPromByItemCodes.error");
		}
		return response;
	}

	/**
	 * 根据参数查询活动是否存在
	 *
	 * @param promotionId 活动 id
	 * @param sourceId 渠道
	 * @param itemCode 单品 id
	 * @return 是否存在
	 *         <p>
	 *         geshuo 20160725
	 */
	@Override
	public Response<Boolean> findPromotionExists(String promotionId, String sourceId, String itemCode) {
		Response<Boolean> response = new Response<>();
		try {
			Integer promotionIdInt = Integer.parseInt(promotionId);
			// 根据活动id、渠道查询活动是否存在
			Map<String, Object> promotionParamMap = Maps.newHashMap();
			// 开始构造活动查询参数
			promotionParamMap.put("id", promotionIdInt);// 活动id
			promotionParamMap.put("sourceKeyWord", sourceId);// 渠道
			promotionParamMap.put("isValid", 1);// 活动状态为有效
			List<Integer> statusList = Lists.newArrayList();
			statusList.add(Contants.PROMOTION_STATE_7);// 已提交(已通过)
			statusList.add(Contants.PROMOTION_STATE_8);// 已提交(部分通过)
			statusList.add(Contants.PROMOTION_STATE_9);// 正在进行
			promotionParamMap.put("statusList", statusList);

			List<PromotionModel> promotionModelList = promotionDao.findPromotionByParams(promotionParamMap);
			if (promotionModelList == null || promotionModelList.size() == 0) {// 活动不存在
				response.setResult(false);
				return response;
			}

			// 根据活动id查询活动是否是正在进行或者即将开始
			Map<String, Object> periodParamMap = Maps.newHashMap();
			periodParamMap.put("promotionId", promotionIdInt);// 活动 id
			periodParamMap.put("nowDate", new Date());
			List<PromotionPeriodModel> periodList = promotionPeriodDao.findPeriodByParams(periodParamMap);
			if (periodList == null || periodList.size() == 0) {// 活动已过期
				response.setResult(false);
				return response;
			}

			// 根据活动id、单品id查询是否存在
			Map<String, Object> rangeParamMap = Maps.newHashMap();
			rangeParamMap.put("promotionId", promotionIdInt);
			rangeParamMap.put("selectCode", itemCode);// 单品 id
			rangeParamMap.put("checkStatus", "1");
			List<PromotionRangeModel> rangeList = promotionRangeDao.findByParams(rangeParamMap);
			if (rangeList == null || rangeList.size() == 0) {
				response.setResult(false);
				return response;
			}
			response.setResult(true);
		} catch (Exception e) {
			log.error("MallPromotionServiceImpl.findPromByItemCodes.error{}", Throwables.getStackTraceAsString(e));
			response.setError("MallPromotionServiceImpl.findPromByItemCodes.error");
			return response;
		}
		return response;
	}

	/**
	 * 根据活动ID、选品ID、用户ID 记录销售数量（同时判断是否达到限购标准）
	 * redis中的销量不是最终付款后产生的销量 最终付款后产生的销量直接更db存到range表中
	 *  下单后就增加这个销量  从根本上类似于商品的锁定库存操作
	 *
	 * @return 是否更新成功 wangqi 20160713
	 */
	@Override
	public Response<Boolean> updatePromSaleInfo(String promId, String periodId, String itemCode, String buyCount,
			User user) {
		Response<Boolean> response = new Response<>();
		// 插入活动单品销量
		try {
			promotionRedisDao.insertPromSaleInfo(promId, periodId, itemCode, buyCount,  user);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("插入活动单品销量失败{}", Throwables.getStackTraceAsString(e));
			response.setError("insert.prom.item.sale.error");
		}
		return response;
	}

	/**
	 * 根据活动ID 获取销售情报
	 *
	 * @param promId 活动ID
	 * @param itemCode 单品code
	 * @return wangqi 20160713
	 */
	@Override
	public Response<MallPromotionSaleInfoDto> findPromSaleInfoByPromId(String promId, String periodId,
			String itemCode) {
		Response<MallPromotionSaleInfoDto> response = new Response<>();
		try {
			// 查询销量 包括单品对应的活动总销量 和单品 当日销量
			MallPromotionSaleInfoDto mallPromotionSaleInfoDto = promotionRedisDao.findPromBuyCount(promId, periodId,
					itemCode);
			if (mallPromotionSaleInfoDto.getStockAmountTody() == null) {
				// 库存为空 为 首次访问 调用db取得库存值插入redis 如果不为空 则直接使用redis
				// 这个值
				Map<String, Object> getStockMap = Maps.newHashMap();
				getStockMap.put("promotionId", Integer.valueOf(promId));// 转换成Int走索引
				getStockMap.put("selectCode", itemCode);
				// 获得当前db中的库存
				Long currentStock = promotionRangeDao.getPerStockByPromItem(getStockMap);
				// 把当前db中的库存同步到redis中并返回
				Long syncResult = promotionRedisDao.syncStockByPromItem(promId, periodId, itemCode, currentStock);
				mallPromotionSaleInfoDto.setStockAmountTody(syncResult);
			}
			response.setResult(mallPromotionSaleInfoDto);
		} catch (Exception e) {
			log.error("查询活动销量失败{}", Throwables.getStackTraceAsString(e));
			response.setError("query.prom.sale.error");
		}
		return response;
	}

	/**
	 * 根据活动ID 检验活动是否有效
	 *
	 * @param promId 活动ID
	 * @return true:有效 false:无效
	 */
	public Response<Boolean> findPromValidByPromId(String promId, String periodId) {
		Response<Boolean> response = Response.newResponse();
		try {
			// 取得活动基本
			PromotionRedisModel model = promotionRedisDao.findPromById(promId);
			if (model == null) {
				// 无效
				response.setResult(false);
				return response;
			} else {
				// 当前日期
				String todayDate = LocalDate.now().toString(df1);
				// 取得今日所有活动ID
				List<String> promIdList = promotionRedisDao.findPromIdListByDate(todayDate);
				for (String str : promIdList) {
					List<String> strList = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(str);
					if (strList.size() > 4) {
						String startDate = strList.get(2); // 开始时间
						String endDate = strList.get(3); // 结束时间
						String redisPeriodId = strList.get(4); // 场次ID
						if (redisPeriodId.equals(periodId)) {
							String isOnline = this.isOnlinePromotion(startDate, endDate);
							// 进行中
							if ("0".equals(isOnline)) {
								// 有效
								response.setResult(true);
								return response;
							} else {
								// 无效
								response.setResult(false);
								return response;
							}
						}
					}
				}
			}
			// 无效
			response.setResult(false);
		} catch (Exception e) {
			// 无效
			log.error("检验活动有效性失败{}", Throwables.getStackTraceAsString(e));
			response.setError("query.prom.sale.error");
		}
		response.setSuccess(true);
		return response;
	}

	/**
	 * 根据活动ID、购买数量 检验用户是否达到限购 用户自己的限购
	 * 下单即计数  就算没付款 也占名额 资格用尽就不让买了
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @param buyCount 购买数量
	 * @param user 用户信息
	 * @return true:有效 false:无效 wangqi 20160713
	 */
	public Response<Boolean> checkPromBuyCount(String promId, String periodId, String buyCount, User user,String itemCode) {
		Response<Boolean> response = new Response<>();
		try {
			// 根据活动ID、购买数量 检验用户是否达到限购
			Boolean aBoolean =  promotionRedisDao.checkUserLimitCount(promId, periodId, buyCount, user,itemCode);
			response.setResult(aBoolean);
		} catch (Exception e) {
			log.error("校验该用户是否达到限购失败 cause by{}", Throwables.getStackTraceAsString(e));
			response.setError("prom.check.user.buylimit.error");
		}
		return response;
	}

	/**
	 *
	 * @param promId 活动id
	 * @param periodId 场次id
	 * @param user 用户id
     * @return
     */
	@Override
	public Response<UserHollandaucLimit> getUserHollandaucLimit(String promId, String periodId, User user){
        Response<UserHollandaucLimit>  response=Response.newResponse();
		try {
			PromotionRedisModel promotionRedisModel = promotionRedisDao.findPromById(promId);
			Integer ruleLimitTicket = promotionRedisModel.getRuleLimitTicket();//可拍次数
			String promForHollandauc = promotionRedisDao.getPromForHollandauc(promId, periodId, user);
			UserHollandaucLimit userHolllandaucLimt = new UserHollandaucLimit(ruleLimitTicket,Integer.valueOf(MoreObjects.firstNonNull(promForHollandauc,"0")));
			response.setResult(userHolllandaucLimt);
		}catch (Exception e){
			log.error("find to getUserHollandaucLimit",e);
			response.setError("");
		}
		return response;
	}

	/**
	 * 根据活动ID、单品CODE、购买数量 检验是否超过库存
	 *
	 * @param promId 活动ID
	 * @param buyCount 购买数量
	 * @param itemCode 单品code
	 * @return true:有效 false:无效 wangqi 20160713
	 */
	public Response<Boolean> checkPromItemStock(String promId, String periodId, String itemCode, String buyCount) {
		Response<Boolean> response = new Response<>();
		try {
			//获取活动基本信息
			PromotionRedisModel promotionRedisModel = promotionRedisDao.findPromById(promId);
			// 取得指定活动内指定单品的销售和库存信息
			Response<MallPromotionSaleInfoDto> responseSaleInfo = this.findPromSaleInfoByPromId(promId, periodId,
					itemCode);
			if (responseSaleInfo.isSuccess()) {
				// 根据活动id和单品Id获得到期当前的状态
				MallPromotionSaleInfoDto promBuyCount = responseSaleInfo.getResult();
				Long stockAmountTody = promBuyCount.getStockAmountTody();// 今天的库存
				if (stockAmountTody == null) {
					stockAmountTody = 0L;
				}
				Integer saleAmountToday = promBuyCount.getSaleAmountToday();// 今天的销量
				if (saleAmountToday == null) {
					saleAmountToday = 0;
				}
				//如果活动类型是荷兰拍的话
				if(Contants.PROMOTION_PROM_TYPE_5.equals(promotionRedisModel.getPromType())){
					log.info("校验荷兰拍库存stockAmountToday={},saleAmountToday={}",stockAmountTody,saleAmountToday);
					if(!stockAmountTody.equals(0L) && stockAmountTody>=saleAmountToday ){
						response.setResult(Boolean.TRUE);
					}else {
						response.setResult(Boolean.FALSE);
					}
					return response;
				}
				// 销量加上将要购买的数量小于等于当前的库存才允许购买 否则不让买 防止超卖
				if ((Long.parseLong(String.valueOf(saleAmountToday)) + Long.parseLong(buyCount)) <= stockAmountTody) {
					response.setResult(Boolean.TRUE);
				} else {
					response.setResult(Boolean.FALSE);
				}
			} else {
				response.setResult(Boolean.FALSE);
			}
		} catch (Exception e) {
			log.error("校验活动是否可购买失败{}", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}



	/**
	 * 查询活动场次列表
	 *
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *         <p>
	 *         geshuo 20160723
	 */
	public Response<Pager<PromotionPeriodDetailDto>> findPromotionPeriodList(Map<String, Object> paramMap) {
		Response<Pager<PromotionPeriodDetailDto>> response = Response.newResponse();
		try {
			Pager<PromotionPeriodDetailDto> resultPager = Pager.empty(PromotionPeriodDetailDto.class);
			List<PromotionPeriodDetailDto> dataList = Lists.newArrayList();

			Map<String, Object> promotionParamMap = Maps.newHashMap();
			// 开始构造活动查询参数
			promotionParamMap.put("sourceKeyWord", paramMap.get("sourceId"));// 渠道
			promotionParamMap.put("isValid", 1);// 活动状态为有效
			List<Integer> statusList = Lists.newArrayList();
			statusList.add(Contants.PROMOTION_STATE_7);// 已提交(已通过)
			statusList.add(Contants.PROMOTION_STATE_8);// 已提交(部分通过)
			statusList.add(Contants.PROMOTION_STATE_9);// 正在进行
			promotionParamMap.put("statusList", statusList);
			promotionParamMap.put("promType", paramMap.get("promType"));// 活动类型

			if (paramMap.get("promotionId") != null) {
				// 有id的情况，查询指定活动的场次
				Integer promotionId = Integer.parseInt(String.valueOf(paramMap.get("promotionId")));
				promotionParamMap.put("id", promotionId);
			}

			// 根据id、渠道、审核状态查询活动
			List<PromotionModel> modelList = promotionDao.findPromotionByParams(promotionParamMap);
			if (modelList == null || modelList.size() == 0) {
				// 活动不存在
				response.setResult(resultPager);
				return response;
			}
			int offset = Integer.parseInt(String.valueOf(paramMap.get("offset")));// 当前页数
			int limit = Integer.parseInt(String.valueOf(paramMap.get("limit")));// 每页显示数据数量
			List<Integer> promotionIdList = Lists.newArrayList();// 有效的活动id列表，用于查询场次
			Map<Integer, PromotionModel> promotionMap = Maps.newHashMap();// 活动map，用于遍历
			for (PromotionModel model : modelList) {
				Integer promotionId = model.getId();
				promotionIdList.add(promotionId);
				promotionMap.put(promotionId, model);
			}
			Map<String, Object> periodParamMap = Maps.newHashMap();
			periodParamMap.put("promotionIdList", promotionIdList);// 放入活动id参数
			periodParamMap.put("nowDate",new Date());
			// 查询场次
			Pager<PromotionPeriodModel> periodPager = promotionPeriodDao.findByPage(periodParamMap, offset, limit);

			resultPager.setTotal(periodPager.getTotal());// 设置 总数
			if (periodPager.getData() != null) {
				for (PromotionPeriodModel period : periodPager.getData()) {
					PromotionPeriodDetailDto dto = new PromotionPeriodDetailDto();
					Integer promotionId = period.getPromotionId();
					dto.setPromotionId(promotionId);// 活动 id
					dto.setBeginDate(period.getBeginDate());// 场次开始时间
					dto.setEndDate(period.getEndDate());// 场次结束时间
					PromotionModel promotionModel = promotionMap.get(promotionId);
					if (promotionModel != null) {
						dto.setPromotionName(promotionModel.getName());// 活动名称
						dto.setDescription(promotionModel.getDescription());// 描述
					}
					dataList.add(dto);
				}
			}
			resultPager.setData(dataList);
			response.setResult(resultPager);
		} catch (Exception e) {
			log.error("MallPromotionServiceImpl.findPromotionPeriodList.error Exception:{}",
					Throwables.getStackTraceAsString(e));
			response.setError("MallPromotionServiceImpl.findPromotionPeriodList.error");
		}
		return response;
	}

	/**
	 * 根据活动ID、场次ID、用户ID 记录拍卖次数
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @param user 用户ID
	 * @return true:有效 false:无效 wangqi 20160713
	 */
	public Response<Long> insertPromForHollandauc(String promId, String periodId, User user) {
		Response<Long> response = Response.newResponse();
		try {
			// 记录拍卖次数并返回更新后的拍卖次数
			Long result = promotionRedisDao.insertPromForHollandauc(promId, periodId, user);
			response.setResult(result);
		} catch (Exception e) {
			log.error("记录拍卖次数失败{}", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	/**
	 * 根据单品CODE、活动ID、场次ID 取得拍卖时点价格数据
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @param itemCode 单品CODE
	 * @return 拍卖价格 wangqi 20160713
	 */
	public Response<PromotionItemResultDto> findHollandaucByItemCode(String promId, String periodId, String itemCode) {
		Response<PromotionItemResultDto> response = Response.newResponse();
	    String nowTime = LocalDateTime.now().toString(dft);
		try {
			// 取得栏位1-3数据(正在拍卖中)
			List<Map<String, String>> mapList = promotionRedisDao.findAuctionsFieldsByKey(promId, periodId, 3);
			List<String> rangeIdList = Lists.newArrayList();
			for (Map<String, String> map : mapList) {
				//map结构为
				//rangeId   startTime
				String rangeId = map.get("rangeId");
				rangeIdList.add(rangeId);
			}
			//当前单品集合的活动单品信息
			List<PromotionRangeModel> list = promotionRangeDao.findByRangIds(rangeIdList);
			List<PromotionItemResultDto> itemList = BeanMapper.mapList(list, PromotionItemResultDto.class);
			// 取得活动基本
			PromotionRedisModel model = promotionRedisDao.findPromById(promId);
			// 插入起拍时间、当前时间
			for (int i = 0; i < itemList.size(); i++) {
				PromotionItemResultDto dto = itemList.get(i);
				// 可拍   寻找被拍卖的单品
				if (StringUtils.isNotEmpty(dto.getSelectCode()) && dto.getSelectCode().equals(itemCode)) {
					// 起拍时间
					String startTime = mapList.get(i).get("startTime");//redis中 批处理计算出来的
					// 计算时间差
					DateTime dateTime1 = dft.parseDateTime(startTime);
					DateTime dateTime2 = dft.parseDateTime(nowTime);
					Duration duration = new Duration(dateTime1, dateTime2);
					int second = duration.toStandardSeconds().getSeconds();
					//每0.5秒降价金额
					BigDecimal money = dto.getFeeRange().divide(new BigDecimal(model.getRuleFrequency()).multiply(
							new BigDecimal(2)), 2, BigDecimal.ROUND_HALF_EVEN);
					// 降至最低价所需的降价次数
					if (dto.getStartPrice() != null && dto.getFeeRange() != null) {
						//起始价格-0.5秒减价数*2*从批处理跑完得到的时间到现在经历了多少秒
						BigDecimal nowPrice = dto.getStartPrice().subtract(money.multiply(new BigDecimal(second * 2)));
						log.info("荷兰拍此次计算点开始时间为{}，当前时间为{}",startTime,nowTime);
						log.info("当前价格为{}",nowPrice);
						if (nowPrice.compareTo(dto.getMinPrice()) < 0) {
							response.setError("prom.AuctionExpired.error");
							batchProm();//手动调批
							return response;
						}
						dto.setNowPrice(nowPrice);
						response.setResult(dto);
						return response;
					}
				}
			}
			//购买的商品不在当前拍卖栏位中的前三个  说明下一个商品已经顶上来 但是此时用户购买的当前栏位的商品将失效 防止攻击 过期数据 清页面
			response.setError("prom.AuctionExpired.error");
			batchProm();//手动调批立即更新数据
		} catch (Exception e) {
			log.error("取得拍卖时点价格数据{}", Throwables.getStackTraceAsString(e));
			response.setError("findHollandaucByItemCode.error");
		}
		return response;

	}

	/**
	 * 判定 荷兰拍拍卖资格
	 *
	 * @param promId 活动ID
	 * @param periodId 场次ID
	 * @param itemCode 单品CODE
	 * @return wangqi 20160713
	 */
	public Response<Boolean> checkAuction(String promId, String periodId, String itemCode, User user) {
		Response<Boolean> response = Response.newResponse();
		// 活动有效性
		Response<Boolean> checkProm = this.findPromValidByPromId(promId, periodId);
		if (checkProm.isSuccess()) {
			if (!checkProm.getResult()) {
				response.setError("promotion.error");
				return response;
			}
		} else {
			response.setError("MallPromotionServiceImpl.prom.not.arrive");
			return response;
		}
		// 校验单品是否已经下架
		//Response<GoodsModel> goodsResponse = goodsService.findGoodsModelByItemCode(itemCode);
		ItemModel itemModel = itemService.findById(itemCode);
		GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
			// 非上架状态
		if (goodsModel == null || !Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall())) {
				response.setError("MallPromotionServiceImpl.prom.goods.not.valid");
				return response;
		}
		Response<MallPromotionSaleInfoDto> promSaleInfoByPromId = this.findPromSaleInfoByPromId(promId, periodId, itemCode);
		if(promSaleInfoByPromId.isSuccess()){
			MallPromotionSaleInfoDto result = promSaleInfoByPromId.getResult();
			log.info("荷兰拍立即拍卖库存检验数值getStockAmountTody={},getSaleAmountToday={}",result.getStockAmountTody(),result.getSaleAmountToday());
			//每次一件
			if(result.getStockAmountTody()<(MoreObjects.firstNonNull(result.getSaleAmountToday(),0)+1)){
				response.setError("promotion.stock.overflow.error");
				return response;
			}
		}else {
			response.setError("MallPromotionServiceImpl.prom.not.arrive");
			return response;
		}


		// 根据活动ID、购买数量 检验用户是否达到限购
		Response<Boolean> checkBuyCount = this.checkPromBuyCount(promId, periodId, "1", user,itemCode);
		if (checkBuyCount.isSuccess()) {
			if (!checkBuyCount.getResult()) {
				response.setError("promotion.user.limit.sale.error");
				return response;
			}
		} else {
			response.setError("MallPromotionServiceImpl.prom.not.arrive");
			return response;
		}
		// 取得活动基本
		PromotionRedisModel model = promotionRedisDao.findPromById(promId);
		String auctionCount = promotionRedisDao.getPromForHollandauc(promId, periodId, user);
		// 默认为3
		Integer ruleLimitTicket = 3;
		if (model != null && model.getRuleLimitTicket() != null) {
			ruleLimitTicket = model.getRuleLimitTicket();
		}
		// 已不可拍
		if (StringUtils.isNotEmpty(auctionCount) && Long.parseLong(auctionCount) >= ruleLimitTicket) {
			response.setError("promotion.auction.count.overflow");
		} else {
			// 增加拍卖次数
			response.setResult(Boolean.TRUE);
			this.insertPromForHollandauc(promId, periodId, user);
		}
		return response;
	}

	/**
	 * 批处理，荷兰拍数据实时运算
	 *
	 * @return true:有效 false:无效 wangqi 20160713
	 */
	private Response<Boolean> batchProm() {
		Response<Boolean> response = new Response<>();
		try {
			// 判断活动是否开始
			// 取得今日所有活动ID
			// 当前日期
			String todayDate = LocalDateTime.fromDateFields(LocalDate.now().toDate()).toString(df1);
			List<String> promIdList = promotionRedisDao.findPromIdListByDate(todayDate);
			for (String str : promIdList) {
				List<String> strList = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(str);
				if (strList.size() > 3) {
					String promId = strList.get(0);
					String promType = strList.get(1);
					String startDate = strList.get(2);
					String endDate = strList.get(3);

					String periodId = strList.get(4);
					// 荷兰拍
					if (org.apache.commons.lang3.StringUtils.isNotEmpty(promType)
							&& promType.equals(String.valueOf(Contants.PROMOTION_PROM_TYPE_5))) {
						// 取得活动基本
						PromotionRedisModel model = promotionRedisDao.findPromById(promId);
						String isOnline = this.isOnlinePromotion(startDate, endDate);
						// 进行中
						if ("0".equals(isOnline)) {
							Map<String, String> hashMap = promotionRedisDao.findAuctionsFieldsByKeyForbatch(1, promId,
									periodId);
							// 活动所属单品信息
							Map<String, Object> params = Maps.newHashMap();
							params.put("promotionId", model.getId());
							params.put("checkStatus", "1");
							List<PromotionRangeModel> list = promotionRangeDao.findByParams(params);

							if (hashMap != null && hashMap.size() > 0) {
								// 刷新redis栏位
								refurbishRedisPromRange(promId, periodId, model.getRuleFrequency());
							} else {
								this.insertRedisPromRange(promId, periodId, list);
							}
							break;
						}
					}
				}
			}
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			response.setError("batch.prom.sync.everyTime.error");
			log.error("荷兰拍同步批处理失败{}", Throwables.getStackTraceAsString(e));
		}
		return response;
	}

	/**
	 * 荷兰拍刷新
	 *
	 */
	private void refurbishRedisPromRange(String promId, String periodId, Integer ruleFrequency) {

		// 判断已拍完数据是否存在
		List<String> rangeIdList = new ArrayList<>();
		// 取得栏位1-6数据
		List<Map<String, String>> mapList = promotionRedisDao.findAuctionsFieldsByKey(promId, periodId, 6);
		List<String> waitList = promotionRedisDao.findAuctionsRangeListByKey(promId, periodId);
		for (Map<String, String> map : mapList) {
			String rangeId = map.get("rangeId");
			if (StringUtils.isNotEmpty(rangeId)) {
				rangeIdList.add(rangeId);
			}
		}
		rangeIdList.addAll(waitList);
		List<PromotionRangeModel> overlist = null;
		if (rangeIdList.size() > 0) {
			// 已售完 findSaleOverByRangIds
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("promotionId", promId);
			paramMap.put("rangeList", rangeIdList);
			overlist = promotionRangeDao.findSaleOverByRangIds(paramMap);
		} else {
			overlist = Lists.newArrayList();
		}
		// 栏位一
		this.refurbishAuctions(1, promId, periodId, ruleFrequency, overlist);
		// 栏位二
		this.refurbishAuctions(2, promId, periodId, ruleFrequency, overlist);
		// 栏位三
		this.refurbishAuctions(3, promId, periodId, ruleFrequency, overlist);
	}

	/**
	 * 判断第一轮3个拍卖位数据
	 *
	 */
	private void refurbishAuctions(Integer beforeNo, String promId, String periodId, Integer ruleFrequency,
			List<PromotionRangeModel> overlist) {

		Integer endNo = beforeNo + 3;
		Map<String, String> beforeHashMap = promotionRedisDao.findAuctionsFieldsByKeyForbatch(beforeNo, promId,
				periodId);
		if (beforeHashMap == null) {
			return;
		}
		List<String> itemCodeList = promotionRedisDao.findAuctionsRangeListByKey(promId, periodId);
		/* ××栏位 */
		// 开始时间
		String startTime = beforeHashMap.get("startTime");
		// 活动选品ID
		String rangeId = beforeHashMap.get("rangeId");
		if (StringUtils.isEmpty(rangeId)) {
			if (overlist.size() > 0) {
				for (int i = 0; i < overlist.size(); i++) {
					PromotionRangeModel model = overlist.get(i);
					MallPromotionSaleInfoDto sale = promotionRedisDao.findPromBuyCount(promId, periodId,
							model.getSelectCode());
					if (sale.getStockAmountTody() != null && sale.getSaleAmountToday() != null
							&& sale.getStockAmountTody() > sale.getSaleAmountToday()) {
						rangeId = String.valueOf(overlist.get(i).getId());
						beforeHashMap.put("rangeId", rangeId);
						overlist.remove(i);
						break;
					}
				}
			}
			if (StringUtils.isEmpty(rangeId)) {
				return;
			}
		}
		PromotionRangeModel rangeModel = promotionRangeDao.findById(Integer.valueOf(rangeId));
		if (rangeModel != null) {
			// redis中库存 定数
			Integer stock = promotionRedisDao.getStock(promId,periodId,rangeModel.getSelectCode());
			// 销量
			String buyCount = promotionRedisDao.findPromBuyCountForBatch(promId, periodId, rangeModel.getSelectCode());

			Map<String, String> afterHashMap = promotionRedisDao.findAuctionsFieldsByKeyForbatch(endNo, promId,
					periodId);
			/*
			 * List<String> itemCodeList = promotionRedisBatchDao .findAuctionsRangeListByKey(promId, periodId);
			 */
			// 已卖完
			if (StringUtils.isNotEmpty(buyCount) && Integer.valueOf(MoreObjects.firstNonNull(buyCount,"0"))>=stock) {
				// 单品数大于6个
				if (itemCodeList == null || itemCodeList.size() == 0) {
					beforeHashMap.remove("rangeId");
					beforeHashMap.remove("startTime");
					// 重新编辑栏位
					this.idetAuctionsForLack(beforeNo, endNo, beforeHashMap, afterHashMap, itemCodeList, promId,
							periodId);
				} else { // 单品数不大于6个
					// 重新编辑栏位
					this.idetAuctions(beforeNo, endNo, afterHashMap, itemCodeList, promId, periodId);
				}
			} else {
				// 是否流拍
				if (calculateSecond(startTime, rangeModel.getStartPrice(), rangeModel.getMinPrice(),
						rangeModel.getFeeRange(), ruleFrequency)) {
					// 单品数大于6个
					if (itemCodeList == null || itemCodeList.size() == 0) {
						// 重新编辑栏位
						this.idetAuctionsForLack(beforeNo, endNo, beforeHashMap, afterHashMap, itemCodeList, promId,
								periodId);
					} else { // 单品数不大于6个
						itemCodeList.add(rangeId);
						// 重新编辑栏位
						this.idetAuctions(beforeNo, endNo, afterHashMap, itemCodeList, promId, periodId);
					}
				}
			}
		}
	}

	/**
	 * 栏位次第补位(单品数不大于6个)
	 *
	 * true 流拍 false 未流拍
	 */
	private void idetAuctionsForLack(Integer beforeNo, Integer endNo, Map<String, String> beforeMap,
			Map<String, String> afterMap, List<String> itemCodeList, String promId, String periodId) {
		// 第二轮栏位 ——> 第一轮栏位
		afterMap.put("startTime", LocalDateTime.now().toString(dft));

		Boolean flg = true;

		if (afterMap == null) {
			flg = false;
		} else {
			String rangeId = afterMap.get("rangeId");
			if (StringUtils.isEmpty(rangeId)) {
				flg = false;
			}
		}
		if (flg) {
			promotionRedisDao.insertAuctionsFields(beforeNo, promId, periodId, afterMap);
			// 去掉起始时间
			beforeMap.remove("startTime");
			promotionRedisDao.insertAuctionsFields(endNo, promId, periodId, beforeMap);
		} else {
			beforeMap.put("startTime", LocalDateTime.now().toString(dft));
			promotionRedisDao.insertAuctionsFields(beforeNo, promId, periodId, beforeMap);
		}

	}

	/**
	 * 计算是否已经流拍
	 *
	 * @return true 流拍 false 未流拍
	 */
	private Boolean calculateSecond(String startTime, BigDecimal startPrice, BigDecimal minPrice, BigDecimal feeRange,
			Integer ruleFrequency) {

		if (startPrice == null || minPrice == null || feeRange == null || ruleFrequency == null) {
			return true;
		}
		// 降价频率大于差额
		if (feeRange.compareTo(startPrice.subtract(minPrice)) > 0) {
			return true;
		} else {
			// 计算时间差
			DateTime dateTime1 = dft.parseDateTime(startTime);
			DateTime dateTime2 = DateTime.now();
			Duration duration = new Duration(dateTime1, dateTime2);

			Integer second = duration.toStandardSeconds().getSeconds();
			// 每0.5秒减价数
		   /*	BigDecimal money = feeRange.divide(
					new BigDecimal(ruleFrequency).divide(new BigDecimal(2), 2, BigDecimal.ROUND_HALF_EVEN), 2,
					BigDecimal.ROUND_HALF_EVEN);*/
			//每0.5秒降价金额
			BigDecimal money = feeRange.divide(new BigDecimal(ruleFrequency).multiply(
					new BigDecimal(2)), 2, BigDecimal.ROUND_HALF_EVEN);

			// 降至最低价所需的降价次数
			BigDecimal count = startPrice.subtract(minPrice).divide(money, 0, RoundingMode.HALF_UP);

			// 已跳完价格
			/*
			 * if(count.intValue() <= second * 2) { return true; } else { return false; }
			 */
			return count.intValue() <= second * 2;
		}
	}

	/**
	 * 栏位次第补位
	 *
	 * true 流拍 false 未流拍
	 */
	private void idetAuctions(Integer beforeNo, Integer endNo, Map<String, String> afterMap, List<String> itemCodeList,
			String promId, String periodId) {
		// 第二轮栏位 ——> 第一轮栏位
		afterMap.put("startTime", LocalDateTime.now().toString(dft));

		promotionRedisDao.insertAuctionsFields(beforeNo, promId, periodId, afterMap);

		// 等候区 ——> 第二轮栏位
		Map<String, String> paramMap = new HashMap<>();
		if (itemCodeList != null && itemCodeList.size() > 0) {
			paramMap.put("rangeId", itemCodeList.get(0));
			itemCodeList.remove(0);
		}
		promotionRedisDao.insertAuctionsFields(endNo, promId, periodId, paramMap);
		promotionRedisDao.insertAuctionsRangeList(promId, periodId, itemCodeList);
	}

	/**
	 * 荷兰拍选品初始写入redis
	 */
	private void insertRedisPromRange(String promId, String periodId, List<PromotionRangeModel> list) {

		if (list != null) {
			// 存入栏位
			List<String> itemList = new ArrayList<>();
			for (int i = 0; i < list.size(); i++) {
				if (i <= 5) {
					// 写入Redis 1-6个栏位数据
					String rangeId = list.get(i).getId().toString();
					this.insertAuctions(i + 1, rangeId, promId, periodId);
				} else {
					itemList.add(list.get(i).getId().toString());
				}
			}
			promotionRedisDao.insertAuctionsRangeList(promId, periodId, itemList);
		}
	}

	/**
	 * 插入前六个栏位
	 */
	private void insertAuctions(int no, String rangeId, String promId, String periodId) {
		Map<String, String> paramMap = new HashMap<>();
		// 第一栏位
		paramMap.put("rangeId", rangeId);
		if (no > 0 && no < 4) {
			// 当前时间
			paramMap.put("startTime", LocalDateTime.fromDateFields(new Date()).toString(dft));
		}
		promotionRedisDao.insertAuctionsFields(no, promId, periodId, paramMap);
	}

	@Override
	public Response<Boolean> updatePromotionStock(List<Map<String, String>> promItemMap) {
		Response<Boolean> response = Response.newResponse();
		try {

			Integer count = promotionManager.updatePromotionStock(promItemMap);
			if (count > 0) {
				response.setResult(true);
				return response;
			} else {
				response.setError("库存已没有");
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("updateStock.item.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("updateStock.item.error");
		}
		return response;
	}
	@Override
	public Response<Boolean> updateRollbackPromotionStock(List<Map<String, Object>> promItemMap) {
		Response<Boolean> response = Response.newResponse();
		try {

			Integer count = promotionManager.updateRollbackPromotionStock(promItemMap);
			if (count > 0) {
				response.setResult(true);
				return response;
			} else {
				response.setError("活动库存回滚失败");
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("updateStock.item.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("updateStock.item.error");
		}
		return response;
	}

	@Override
	public Response<Pager<PromotionPeriodDetailDto>> findMiaoShaoPromotionPeroidList(String origin, String promtionId,
			PageInfo pageInfo) {
		Response<Pager<PromotionPeriodDetailDto>> response = new Response<>();
		List<PromotionPeriodDetailDto> resultList = new ArrayList<>();//进行中
		List<PromotionPeriodDetailDto> resultListNoStart = new ArrayList<>();//未开始
		List<PromotionPeriodDetailDto> resultListEnd = new ArrayList<>();//一结束
		// 当前日期
		String todayDate = LocalDateTime.now().toString(df1);
		try {
			// 取得今日所有活动ID
			List<String> promIdList = promotionRedisDao.findPromIdListByDate(todayDate);
			for (String str : promIdList) {
				List<String> strList = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(str);
				PromotionPeriodDetailDto resultDto = new PromotionPeriodDetailDto();
				if (strList.size() > 4) {
					String promId = strList.get(0); // 活动ID
					String promType = strList.get(1); // 活动类型
					String startDate = strList.get(2); // 开始时间
					String endDate = strList.get(3); // 结束时间

					if(!Strings.isNullOrEmpty(promtionId) && !promtionId.equals(promId)){
						continue;
					}

					Date bDate = dft.parseLocalDateTime(startDate).toDate();
					Date eDate = dft.parseLocalDateTime(endDate).toDate();
					// 指定类型
					if (StringUtils.isNotEmpty(promType) && promType.equals(String.valueOf(Contants.PROMOTION_PROM_TYPE_3))) {
						// 取得活动基本
						PromotionRedisModel model = promotionRedisDao.findPromById(promId);
						// 商城渠道
						if (model != null && StringUtils.isNotEmpty(model.getSourceId())
								&& model.getSourceId().contains(origin)) {
							// 返回活动基本信息
							resultDto.setPromotionId(Integer.valueOf(promId));
							resultDto.setPromotionName(model.getName());
							resultDto.setDescription(model.getDescription());
							// 单场开始时间
							resultDto.setBeginDate(bDate);
							// 单场结束时间
							resultDto.setEndDate(eDate);
							String isOnline = isOnlinePromotion(startDate, endDate);
							if ("0".equals(isOnline)) {//进行中
								resultList.add(resultDto);
							}else if ("1".equals(isOnline)) {//未开始
								resultListNoStart.add(resultDto);
							}else if ("2".equals(isOnline)) {//已结束
								resultListEnd.add(resultDto);
							}
						}
					}
				}
			}
			Map<Integer, PromotionPeriodDetailDto> isOnlineMap = new HashMap<>();
			for(PromotionPeriodDetailDto promotionPeriodDetailDto : resultList){
				PromotionPeriodDetailDto onlinePromotionPeriodDetailDto = isOnlineMap.get(promotionPeriodDetailDto.getPromotionId());
				if(onlinePromotionPeriodDetailDto == null){
					isOnlineMap.put(promotionPeriodDetailDto.getPromotionId(), promotionPeriodDetailDto);
				}
			}
			//添加未开始的场次，如果存在正在进行的场次就不添加
			for(PromotionPeriodDetailDto promotionPeriodDetailDto : resultListNoStart){
				PromotionPeriodDetailDto onlinePromotionPeriodDetailDto = isOnlineMap.get(promotionPeriodDetailDto.getPromotionId());
				if(onlinePromotionPeriodDetailDto == null){
					isOnlineMap.put(promotionPeriodDetailDto.getPromotionId(), promotionPeriodDetailDto);
					resultList.add(promotionPeriodDetailDto);
				}
			}

			resultList.addAll(resultListEnd);
			Long total = (long) resultList.size();
			if(pageInfo.getOffset() + pageInfo.getLimit() > total){
				resultList = resultList.subList(pageInfo.getOffset(), resultList.size());
			}else{
				resultList = resultList.subList(pageInfo.getOffset(), pageInfo.getOffset() + pageInfo.getLimit());
			}
			resultList=subList(resultList);
			Pager<PromotionPeriodDetailDto> pager = new Pager<>(total, resultList);
			response.setResult(pager);
		} catch (Exception e) {
			log.error("MallPromotionServiceImpl.findMiaoShaoPromotionPeroidList.error{}", Throwables.getStackTraceAsString(e));
			response.setError("MallPromotionServiceImpl.findMiaoShaoPromotionPeroidList.error");
		}
		return response;
	}
	private <T> List<T> subList(List<T> list){
		ArrayList<T> result=new ArrayList<>();
		for(T t:list){
			result.add(t);
		}
		return result;
	}

}
