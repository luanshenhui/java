package cn.com.cgbchina.promotion.service;

import cn.com.cgbchina.promotion.model.PromotionModel;
import cn.com.cgbchina.promotion.model.PromotionRedisModel;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/9.
 */
public interface PromotionForBatchService {
	/**
	 * 为批处理准备的数据检索服务 非批处理不允许调用
	 *
	 * @return
	 */
	public Response<List<PromotionModel>> getPromotionForBatch(Map<String, Object> para);

	public Response<Boolean> insertProm(List<PromotionRedisModel> list);

	public Response<Boolean> insertPromIds(List<Integer> list, String date);
}
