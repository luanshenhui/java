package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.model.TblGoodsRecommendationYgModel;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

/**
 *
 */
public interface GoodsRecommendationService {

	/**
	 * 查询数据总和
	 *
	 * @return
	 */
	public Response<Integer> findGoodsCommendationCount();
	public Response<Integer> findGoodsSeqMax();

	/**
	 * 添加网银商品推荐
	 *
	 * @param tblGoodsRecommendationYgModel
	 * @return
	 */
	public Response<Integer> insertGoodsRecommendation(TblGoodsRecommendationYgModel tblGoodsRecommendationYgModel);

	/**
	 * 根据商品ID查询网银商品推荐商品
	 *
	 * @param stringList
	 * @return
	 */
	public Response<List<TblGoodsRecommendationYgModel>> findGoodsRecommendation(List<String> stringList);

	/**
	 * 删除网银商品推荐
	 *
	 * @param goodsId
	 * @return
	 */
	public Response<Integer> deleteGoodsRe(String goodsId);

	/**
	 * 交换顺序
	 * 
	 * @param currentId
	 * @param changeId
	 * @return
	 */
	Response<Boolean> changeSord(String currentId, String currentDelFlag, String changeId, String changeDelFlag);

	/**
	 * 校验商品Id是否重复
	 * 
	 * @param mid
	 * @return
	 */
	Response<Integer> findCountById(String mid);

	/**
	 * 该类目下的推荐商品
	 */
	public Response<List<Map<String,Object>>> findGoodsRecommendation(String backgoryId);
}
