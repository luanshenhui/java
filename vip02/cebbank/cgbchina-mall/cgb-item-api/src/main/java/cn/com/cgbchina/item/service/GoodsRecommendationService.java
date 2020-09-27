package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.model.TblGoodsRecommendationYgModel;
import com.spirit.common.model.Response;

import java.util.List;

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
	 * @param code
	 * @return
	 */
	Response<Integer> findCountById(String code);
}
