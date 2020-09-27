package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.GoodsPointRegionDao;
import cn.com.cgbchina.item.dao.GoodsRecommendationJfDao;
import cn.com.cgbchina.item.model.GoodsPointRegionModel;
import cn.com.cgbchina.item.model.GoodsRecommendationJfModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by txy on 2016/8/1.
 */
@Transactional
@Component
public class PointsGiftRecommendationManager {
    @Resource
    private GoodsPointRegionDao goodsPointRegionDao;
    @Resource
    private GoodsRecommendationJfDao goodsRecommendationJfDao;

    /**
     * 新增积分区间
     * @param goodsPointRegionModel
     * @return
     */
    public Boolean createPointsRegion(GoodsPointRegionModel goodsPointRegionModel) {
        return goodsPointRegionDao.insert(goodsPointRegionModel) == 1;
    }

    /**
     * 新增礼品
     *
     * @param goodsRecommendationJfModel
     * @return
     */
    public Boolean createPointsGift(GoodsRecommendationJfModel goodsRecommendationJfModel) {
        return goodsRecommendationJfDao.insert(goodsRecommendationJfModel) == 1;
    }

    /**
     * 删除礼品
     *
     * @param goodsRecommendationJfModel
     * @return
     */
    public Boolean deleteGift(GoodsRecommendationJfModel goodsRecommendationJfModel) {
        return goodsRecommendationJfDao.delete(goodsRecommendationJfModel) == 1;
    }

    /**
     * 礼品顺序交换
     *
     * @param param
     * @return
     */
    public Boolean currentGift(Map<String, Object> param) {
        return goodsRecommendationJfDao.currentGift(param) == 1;
    }

    /**
     * 礼品顺序交换
     *
     * @param changeParam
     * @return
     */
    public Boolean changeGift(Map<String, Object> changeParam) {
        return goodsRecommendationJfDao.changeGift(changeParam) == 1;
    }

    /**
     * 删除积分区间
     *
     * @param param
     * @return
     */
    public Boolean deletePointsRegion(Map<String,Object> param) {
        return goodsPointRegionDao.deletePointsRegion(param) >=1;
    }
}
