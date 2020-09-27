package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.TblGoodsRecommendationYgDao;
import cn.com.cgbchina.item.manager.GoodsRecommendationManager;
import cn.com.cgbchina.item.model.TblGoodsRecommendationYgModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by 11150221040129 on 16-4-8.
 */
@Service
@Slf4j
public class GoodsRecommendationServiceImpl implements GoodsRecommendationService {

	@Resource
	private GoodsRecommendationManager goodsRecommendationManager;

	@Resource
	private TblGoodsRecommendationYgDao tblGoodsRecommendationYgDao;

	/**
	 * 查询数据总和
	 *
	 * @return
	 */
	@Override
	public Response<Integer> findGoodsCommendationCount() {
		Response<Integer> response = new Response<Integer>();
		try {
			// 调用接口
			Integer result = tblGoodsRecommendationYgDao.findGoodsCommendationCount();
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert.error", Throwables.getStackTraceAsString(e));
			response.setError("insert.error");
			return response;
		}
	}

	/**
	 * 添加网银商品推荐
	 *
	 * @param tblGoodsRecommendationYgModel
	 * @return
	 */
	public Response<Integer> insertGoodsRecommendation(TblGoodsRecommendationYgModel tblGoodsRecommendationYgModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			// 调用接口
			Integer result = goodsRecommendationManager.insertGoodsRecommendation(tblGoodsRecommendationYgModel);
			if (result <= 0) {
				response.setError("insert.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert.error", Throwables.getStackTraceAsString(e));
			response.setError("insert.error");
			return response;
		}
	}

	/**
	 * 根据商品ID查询网银商品推荐商品
	 *
	 * @param stringList
	 * @return
	 */
	@Override
	public Response<List<TblGoodsRecommendationYgModel>> findGoodsRecommendation(List<String> stringList) {
		Response<List<TblGoodsRecommendationYgModel>> response = new Response<List<TblGoodsRecommendationYgModel>>();
		try {
			// 调用接口
			List<TblGoodsRecommendationYgModel> result = tblGoodsRecommendationYgDao
					.findGoodsRecommendation(stringList);

			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert.error", Throwables.getStackTraceAsString(e));
			response.setError("insert.error");
			return response;
		}
	}

	/**
	 * 删除网银商品推荐
	 *
	 * @param goodsId
	 * @return
	 */
	@Override
	public Response<Integer> deleteGoodsRe(String goodsId) {
		Response<Integer> response = new Response<Integer>();
		try {
			// 调用接口
			Integer result = goodsRecommendationManager.deleteGoodsRe(goodsId);

			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert.error", Throwables.getStackTraceAsString(e));
			response.setError("insert.error");
			return response;
		}
	}

	/**
	 * 交换顺序
	 *
	 * @param currentId
	 * @param currentDelFlag
	 * @param changeId
	 * @param changeDelFlag
	 * @return
	 */
	@Override
	public Response<Boolean> changeSord(String currentId, String currentDelFlag, String changeId,
			String changeDelFlag) {
		Response<Boolean> response = new Response<>();
		Map<String, Object> currentMap = Maps.newHashMap();
		currentMap.put("currentId", currentId);
		currentMap.put("changeDelFlag", changeDelFlag);

		Map<String, Object> changeMap = Maps.newHashMap();
		changeMap.put("changeId", changeId);
		changeMap.put("currentDelFlag", currentDelFlag);
		try {
			Integer current = goodsRecommendationManager.changeCurrent(currentMap);
			Integer change = goodsRecommendationManager.changeChange(changeMap);
			if (current <= 0 || change <= 0) {
				response.setError("changeSord.error");
				return response;
			}
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("failed to change front category sort", currentId, changeId);
			response.setError("category.exchange.sort.error");
			return response;
		}
		return response;
	}

	/**
	 * 校验商品Id是否重复
	 *
	 * @param code
	 * @return
	 */
	@Override
	public Response<Integer> findCountById(String code) {
		Response<Integer> response = new Response<Integer>();
		try {
			// 调用接口
			Integer result = tblGoodsRecommendationYgDao.findCountById(code);
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert.error", Throwables.getStackTraceAsString(e));
			response.setError("insert.error");
			return response;
		}
	}

}
