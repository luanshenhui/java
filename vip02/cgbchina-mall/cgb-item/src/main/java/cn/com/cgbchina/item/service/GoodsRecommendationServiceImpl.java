package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.TblGoodsRecommendationYgDao;
import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.manager.GoodsRecommendationManager;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsRecommendationYgModel;
import com.google.common.base.Function;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
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
	@Resource
	private ItemDao itemDao;

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
	 * 查询最大排序
	 *
	 * @return
	 */
	@Override
	public Response<Integer> findGoodsSeqMax() {
		Response<Integer> response = new Response<Integer>();
		try {
			// 调用接口
			Integer result = tblGoodsRecommendationYgDao.findGoodsSeqMax();
			response.setSuccess(true);
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("insert.error,bad code:{}", Throwables.getStackTraceAsString(e));
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
			ItemModel itemModel = itemDao.findItemDetailByMid(tblGoodsRecommendationYgModel.getGoodsMid());
			if (itemModel != null) {
				Integer result = goodsRecommendationManager.insertGoodsRecommendation(tblGoodsRecommendationYgModel);
				if (result <= 0) {
					response.setError("insert.error");
					return response;
				}
				response.setResult(result);
			} else {
				response.setError("find.goods.item.error");
			}
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
	 * @param mid
	 * @return
	 */
	@Override
	public Response<Integer> findCountById(String mid) {
		Response<Integer> response = new Response<Integer>();
		try {
			// 调用接口
			Integer result = tblGoodsRecommendationYgDao.findCountById(mid);
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError("fail.goodsRecommendation.findCountById");
			return response;
		} catch (Exception e) {
			log.error("GoodsRecommendationServiceImpl.findCountById.fail,error code{}",
					Throwables.getStackTraceAsString(e));
			response.setError("fail.goodsRecommendation.findCountById");
			return response;
		}
	}

	/**
	 * 该类目下的推荐商品
	 */
	@Override
	public Response<List<Map<String,Object>>> findGoodsRecommendation(String backgoryId) {
		Response<List<Map<String,Object>>> response = Response.newResponse();
		try {
			List<TblGoodsRecommendationYgModel> models = tblGoodsRecommendationYgDao
					.findGoodsRecommendationByType(backgoryId);
			if(null == models || models.isEmpty()){
				response.setResult(null);
				return response;
			}
			List<String> codes = Lists.transform(models,new Function<TblGoodsRecommendationYgModel, String>() {
				@Nullable
				@Override
				public String apply(@Nullable TblGoodsRecommendationYgModel input) {
					return input.getGoodsId();
				}
			});
			List<ItemModel> itemModels = itemDao.findByCodes(codes);
			Map<String, ItemModel> map = Maps.uniqueIndex(itemModels, new Function<ItemModel, String>() {
				@Nullable
				@Override
				public String apply(@Nullable ItemModel input) {
					return input.getCode();
				}
			});
			List<Map<String, Object>> results = Lists.newArrayListWithExpectedSize(models.size());
			for(TblGoodsRecommendationYgModel model : models){
				Map<String, Object> item = Maps.newHashMapWithExpectedSize(2);
				ItemModel itemModel = map.get(model.getGoodsId());
				item.put("model" , model);
				item.put("goodsCode" , itemModel.getGoodsCode());
				results.add(item);
			}
			response.setResult(results);
		} catch (Exception e) {
			response.setError("findGoodsRecommendation.error");
		}
		return response;
	}
}

