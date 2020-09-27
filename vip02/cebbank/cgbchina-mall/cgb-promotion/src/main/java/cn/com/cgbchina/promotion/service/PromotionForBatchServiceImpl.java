package cn.com.cgbchina.promotion.service;

import cn.com.cgbchina.promotion.dao.PromotionDao;
import cn.com.cgbchina.promotion.dao.PromotionPeriodDao;
import cn.com.cgbchina.promotion.dao.PromotionRedisDao;
import cn.com.cgbchina.promotion.model.PromotionModel;
import cn.com.cgbchina.promotion.model.PromotionPeriodModel;
import cn.com.cgbchina.promotion.model.PromotionRedisModel;
import com.google.common.base.Function;
import com.google.common.base.Throwables;
import com.google.common.collect.Collections2;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.IteratorUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/9.
 */
@Service
@Slf4j
public class PromotionForBatchServiceImpl implements PromotionForBatchService {

	@Resource
	private PromotionRedisDao promotionRedisDao;
	@Resource
	private PromotionDao promotionDao;
	@Resource
	private PromotionPeriodDao promotionPeriodDao;

	/**
	 * 从拿到要同步到redis中的活动基础数据 只有哈希
	 * 
	 * @return
	 */
	@Override
	public Response<List<PromotionModel>> getPromotionForBatch(Map<String, Object> para) {
		Response<List<PromotionModel>> response = new Response<>();
		try {
			List<PromotionPeriodModel> periodList = promotionPeriodDao.getForBatch(para);
			List<Integer> promotionIds = IteratorUtils
					.toList(Collections2.transform(periodList, new Function<PromotionPeriodModel, Integer>() {
						@Nullable
						@Override
						public Integer apply(@Nullable PromotionPeriodModel input) {
							return input.getPromotionId();
						}
					}).iterator());

			List<PromotionModel> promotionForBatch = promotionDao.getPromotionForBatch(para);
			if (periodList.size() > 0) {
				List<PromotionModel> promotionByIds = promotionDao.findPromotionByIds(promotionIds);
				promotionForBatch.addAll(promotionByIds);// 合并集合
			}
			response.setResult(promotionForBatch);
		} catch (Exception e) {
			log.error("fail to find promotion for batch ,cause by {}", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	/**
	 * 获取到三个日期相关的活动id集合
	 */
	public Response<Map<String, List<Integer>>> getPromotionIds() {
		Response<Map<String, List<Integer>>> response = new Response<>();
		try {

		} catch (Exception e) {
			log.error("fail to query promotion ids cause by{}", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	public Response<Boolean> insertProm(List<PromotionRedisModel> list) {
		Response<Boolean> response = new Response<>();
		try {
			promotionRedisDao.syncDBtoRedis(list);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("fail to insert promotion data into redis params ={},cause by{}", list,
					Throwables.getStackTraceAsString(e));
			response.setError("insert.redis.promotion.batch.error");
		}
		return response;
	}

	/**
	 * 已天数为界限对活动的id进行分组
	 * 
	 * @param list
	 * @return
	 */
	@Override
	public Response<Boolean> insertPromIds(List<Integer> list, String date) {
		Response<Boolean> response = new Response<>();
		try {
			promotionRedisDao.insertIdsByDate(list, date);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("fail to insert promotion data into redis params ={},cause by{}", list,
					Throwables.getStackTraceAsString(e));
			response.setError("insert.redis.promotion.batch.error");
		}
		return response;
	}

}
