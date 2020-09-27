package cn.com.cgbchina.batch.service.impl;

import cn.com.cgbchina.batch.service.PromotionSyncService;
import cn.com.cgbchina.promotion.model.PromotionModel;
import cn.com.cgbchina.promotion.model.PromotionRedisModel;
import cn.com.cgbchina.promotion.service.PromotionForBatchService;
import com.google.common.base.Function;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.IteratorUtils;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/8.
 */
@Slf4j
@Service
public class PromotionSyncServiceImpl implements PromotionSyncService {
	private final DateTimeFormatter dateTimeFormat = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
	@Resource
	private PromotionForBatchService promotionForBatchService;

	public void syncDBtoRedis() {
		log.info("--------------------------活动正式数据同步开始--------------------------");
		// 构建明天日期的查询map
		Map<String, Object> tomorrowMap = Maps.newHashMap();
		tomorrowMap.put("startTime", LocalDateTime.fromDateFields(LocalDate.now().plusDays(1).toDate()).toString(dateTimeFormat));// 明天
		tomorrowMap.put("endTime",
				LocalDateTime.fromDateFields(LocalDate.now().plusDays(2).toDate()).minusSeconds(1).toString(dateTimeFormat));// 明天最后一刻
		Response<List<PromotionModel>> tomorrow = promotionForBatchService.getPromotionForBatch(tomorrowMap);
		if (!tomorrow.isSuccess()) {
			log.error("从db中抓取活动数据失败  error={}", tomorrow.getError());
			return;
		}
		// 明天活动的id集合
		List<Integer> tomorrowIds = IteratorUtils
				.toList(Collections2.transform(tomorrow.getResult(), new Function<PromotionModel, Integer>() {
					@Nullable
					@Override
					public Integer apply(@Nullable PromotionModel input) {
						return input.getId();
					}
				}).iterator());
		// 构建后天日期的查询map
		Map<String, Object> afterTomorrowMap = Maps.newHashMap();
		afterTomorrowMap.put("startTime", LocalDateTime.fromDateFields(LocalDate.now().plusDays(2).toDate()).toString(dateTimeFormat));// 后天
		afterTomorrowMap.put("endTime",
				LocalDateTime.fromDateFields(LocalDate.now().plusDays(3).toDate()).minusSeconds(1).toString(dateTimeFormat));// 后天最后一刻

		Response<List<PromotionModel>> afterTomorrow = promotionForBatchService.getPromotionForBatch(afterTomorrowMap);
		if (!afterTomorrow.isSuccess()) {
			log.error("从db中抓取活动数据失败  error={}", tomorrow.getError());
			return;
		}
		// 后天活动的id集合
		List<Integer> afterTomorrowIds = IteratorUtils
				.toList(Collections2.transform(afterTomorrow.getResult(), new Function<PromotionModel, Integer>() {
					@Nullable
					@Override
					public Integer apply(@Nullable PromotionModel input) {
						return input.getId();
					}
				}).iterator());

		// 构建大后天日期的查询map
		Map<String, Object> afterAfterTommorrowMap = Maps.newHashMap();
		afterAfterTommorrowMap.put("startTime", LocalDateTime.fromDateFields(LocalDate.now().plusDays(3).toDate()).toString(dateTimeFormat));
		afterAfterTommorrowMap.put("endTime",
				LocalDateTime.fromDateFields(LocalDate.now().plusDays(4).toDate()).minusSeconds(1).toString(dateTimeFormat));
		Response<List<PromotionModel>> afterAfterTommorrow = promotionForBatchService
				.getPromotionForBatch(afterAfterTommorrowMap);
		if (!afterAfterTommorrow.isSuccess()) {
			log.error("从db中抓取活动数据失败  error={}", tomorrow.getError());
			return;
		}
		// 大后天的活动ids
		List<Integer> afterAfterTomorrow = IteratorUtils.toList(
				Collections2.transform(afterAfterTommorrow.getResult(), new Function<PromotionModel, Integer>() {
					@Nullable
					@Override
					public Integer apply(@Nullable PromotionModel input) {
						return input.getId();
					}
				}).iterator());

		List<PromotionModel> allPromotion = Lists.newArrayList();
		allPromotion.addAll(tomorrow.getResult());
		allPromotion.addAll(afterTomorrow.getResult());
		allPromotion.addAll(afterAfterTommorrow.getResult());

		log.info("----------------------------活动数据已经从数据库中抓取完毕------------------------");
		log.info("-----------------------处理db中的数据到redis中-----------------------");
		List<PromotionRedisModel> redisModels = Lists.newArrayList();
		PromotionRedisModel promotionRedisModel = null;
		for (PromotionModel promotion : allPromotion) {
			promotionRedisModel = new PromotionRedisModel();
			BeanMapper.copy(promotion, promotionRedisModel);
			/// 此处留着处理db数据与redis数据的差异
			redisModels.add(promotionRedisModel);

		}
		log.info("---------------------------往redis中写入活动基础数据----------------------------");
		Response<Boolean> response = promotionForBatchService.insertProm(redisModels);
		if (response.isSuccess()) {
			log.info("-------------------------往redis中写入活动数据成功------------------");
		} else {
			log.error("-------------------------redis中写入活动数据失败--------------------");
		}
		// 写入三个id集合
		promotionForBatchService.insertPromIds(tomorrowIds,
				LocalDate.now().plusDays(1).toString(DateTimeFormat.forPattern("yyyyMMdd")));
		promotionForBatchService.insertPromIds(afterTomorrowIds,
				LocalDate.now().plusDays(2).toString(DateTimeFormat.forPattern("yyyyMMdd")));
		promotionForBatchService.insertPromIds(afterAfterTomorrow,
				LocalDate.now().plusDays(3).toString(DateTimeFormat.forPattern("yyyyMMdd")));
		log.info("活动id集合插入成功");




	}

}
