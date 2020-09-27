package cn.com.cgbchina.item.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import cn.com.cgbchina.item.model.PromotionPeriodModel;

@Repository
public class PromotionPeriodDao extends SqlSessionDaoSupport {

    public Integer update(PromotionPeriodModel promotionPeriod) {
        return getSqlSession().update("PromotionPeriodModel.update", promotionPeriod);
    }

    public Integer insert(PromotionPeriodModel promotionPeriod) {
        return getSqlSession().insert("PromotionPeriodModel.insert", promotionPeriod);
    }

    public List<PromotionPeriodModel> findAll() {
        return getSqlSession().selectList("PromotionPeriodModel.findAll");
    }

    public PromotionPeriodModel findById(Integer id) {
        return getSqlSession().selectOne("PromotionPeriodModel.findById", id);
    }

    public Pager<PromotionPeriodModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("PromotionPeriodModel.count", params);
        if(total == 0) {
            return Pager.empty(PromotionPeriodModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if(!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<PromotionPeriodModel> data = getSqlSession().selectList("PromotionPeriodModel.pager", paramMap);
        return new Pager<PromotionPeriodModel>(total, data);
    }

    public Integer delete(PromotionPeriodModel promotionPeriod) {
        return getSqlSession().delete("PromotionPeriodModel.delete", promotionPeriod);
    }

    public Integer insertAll(List<PromotionPeriodModel> list) {
        return getSqlSession().insert("PromotionPeriodModel.insertAll", list);
    }

    /**
     * 查询正在进行的活动
     *
     * @return 活动id列表
     * <p>
     * geshuo 201607
     */
    public List<PromotionPeriodModel> findNowPromotion(List<Integer> promotionIdList) {
        return getSqlSession().selectList("PromotionPeriodModel.findNowPromotion",promotionIdList);
    }

    /**
     * 根据参数查询活动时间
     *
     * @param paramMap 查询参数
     * @return 查询结果
     * <p>
     * geshuo 20160725
     */
    public List<PromotionPeriodModel> findPeriodByParams(Map<String, Object> paramMap) {
        return getSqlSession().selectList("PromotionPeriodModel.findPeriodByParams", paramMap);
    }

    public Integer findDuliCheck(Map<String, Object> paraMap) {
        return getSqlSession().selectOne("PromotionPeriodModel.findDuliCheck", paraMap);
    }

    public List<PromotionPeriodModel> findPeriodByPromIds(List<Integer> list) {
        return getSqlSession().selectList("PromotionPeriodModel.findPeriodByPromIds", list);
    }

    public Integer deletePeriodByPromId(Integer promotionId) {
        return getSqlSession().delete("PromotionPeriodModel.deletePeriodByPromId", promotionId);
    }

    /**
     * 查询未来的活动
     * @return 查询结果
     *
     * geshuo 20160906
     */
    public List<PromotionPeriodModel> findFuturePeriod(){
        return getSqlSession().selectList("PromotionPeriodModel.findFuturePeriod");
    }
}