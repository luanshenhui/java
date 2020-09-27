package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.TblGoodsRecommendationYgDao;
import cn.com.cgbchina.item.model.TblGoodsRecommendationYgModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 *
 */

@Component
@Transactional
public class GoodsRecommendationManager {
	@Resource
	private TblGoodsRecommendationYgDao tblGoodsRecommendationYgDao;

	/**
	 * 添加网银商品推荐
	 *
	 * @param tblGoodsRecommendationYgModel
	 * @return
	 */
	public Integer insertGoodsRecommendation(TblGoodsRecommendationYgModel tblGoodsRecommendationYgModel) {
		return tblGoodsRecommendationYgDao.insert(tblGoodsRecommendationYgModel);
	}

	/**
	 * 删除网银商品推荐
	 *
	 * @param goodsId
	 * @return
	 */
	public Integer deleteGoodsRe(String goodsId) {
		return tblGoodsRecommendationYgDao.deleteGoodsRe(goodsId);
	}

	/**
	 * 交换顺序
	 *
	 * @param currentMap
	 * @return
	 */
	public Integer changeCurrent(Map<String, Object> currentMap) {
		return tblGoodsRecommendationYgDao.changeCurrent(currentMap);
	}

	/**
	 * 交换顺序
	 *
	 * @param changeMap
	 * @return
	 */
	public Integer changeChange(Map<String, Object> changeMap) {
		return tblGoodsRecommendationYgDao.changeChange(changeMap);
	}

}
