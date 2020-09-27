package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.GoodsRecommendationJfModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GoodsRecommendationJfDao extends SqlSessionDaoSupport {

    public Integer update(GoodsRecommendationJfModel goodsRecommendationJf) {
        return getSqlSession().update("GoodsRecommendationJfModel.update", goodsRecommendationJf);
    }


    public Integer insert(GoodsRecommendationJfModel goodsRecommendationJf) {
        return getSqlSession().insert("GoodsRecommendationJfModel.insert", goodsRecommendationJf);
    }


    public List<GoodsRecommendationJfModel> findAll() {
        return getSqlSession().selectList("GoodsRecommendationJfModel.findAll");
    }


    public GoodsRecommendationJfModel findById(Integer id) {
        return getSqlSession().selectOne("GoodsRecommendationJfModel.findById", id);
    }


    public Pager<GoodsRecommendationJfModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("GoodsRecommendationJfModel.count", params);
        if (total == 0) {
            return Pager.empty(GoodsRecommendationJfModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<GoodsRecommendationJfModel> data = getSqlSession().selectList("GoodsRecommendationJfModel.pager", paramMap);
        return new Pager<GoodsRecommendationJfModel>(total, data);
    }

    /**
     * 删除礼品
     * @param goodsRecommendationJf
     * @return
     */
    public Integer delete(GoodsRecommendationJfModel goodsRecommendationJf) {
        return getSqlSession().update("GoodsRecommendationJfModel.delete", goodsRecommendationJf);
    }

    /**
     * 查询所有的积分区间
     *
     * @param goodsRecommendationJfModel
     * @return
     */
    public List<GoodsRecommendationJfModel> findRecommendGift(GoodsRecommendationJfModel goodsRecommendationJfModel) {
        return getSqlSession().selectList("GoodsRecommendationJfModel.findRecommendGift", goodsRecommendationJfModel);
    }

    /**
     * 判断此积分区间是否可以推荐单品
     *
     * @param regionId
     * @return
     */
    public Long findPointsGiftCount(Integer regionId) {
        return getSqlSession().selectOne("GoodsRecommendationJfModel.findPointsGiftCount", regionId);
    }

    /**
     * 判断这个单品在这个此积分区间是否被推荐过
     *
     * @param params
     * @return
     */
    public Long findUsedGiftCheck(Map<String, Object> params) {
        return getSqlSession().selectOne("GoodsRecommendationJfModel.findUsedGiftCheck", params);
    }

    /**
     * 查询最大顺序
     * @return
     */
    public Integer findMaxGiftSeq(){
        return getSqlSession().selectOne("GoodsRecommendationJfModel.findMaxGiftSeq");
    }

    /**
     * 交换顺序
     * @param param
     * @return
     */
    public Integer currentGift(Map<String,Object> param){
        return getSqlSession().update("GoodsRecommendationJfModel.currentGift",param);
    }

    /**
     * 交换顺序
     * @param changeParam
     * @return
     */
    public Integer changeGift(Map<String,Object> changeParam){
        return getSqlSession().update("GoodsRecommendationJfModel.changeGift",changeParam);
    }
}