package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.DealBestRateModel;
import com.google.common.collect.Maps;
import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by txy on 2016/7/18.
 */
@Repository
public class DealBestRateDao extends BaseDao{
    /**
     * 插入批处理任务表
     * @param runningBatchParam
     * @return
     */
    public Integer createBatchStatus(Map<String,Object> runningBatchParam){
        return getSqlSession().insert("DealBestRate.createBatchStatus", runningBatchParam);
    }

    /**
     * 获取当月积分池中的数据
     * @return
     */
    public List<DealBestRateModel> findPointsPool(String curMonth){
        return getSqlSession().selectList("DealBestRate.findPointsPool",curMonth);
    }

    /**
     * 获取不同类别的特殊倍率
     * @param
     * @return
     */
    public List<DealBestRateModel> findSpecialPointScale(){
        return getSqlSession().selectList("DealBestRate.findSpecialPointScale");
    }

    /**
     * 获取供应商的商品信息
     * @return
     */
    public List<DealBestRateModel> findGoodsInf(int offset, int limit){
        Map<String, Object> param = Maps.newHashMap();
        param.put("offset", offset);
        param.put("limit", limit);
        return getSqlSession().selectList("DealBestRate.findGoodsInf", param);
    }

    /**
     * 获取供应商的商品信息总件数
     * @return
     */
    public Long findGoodsInfCount(){
        return getSqlSession().selectOne("DealBestRate.findGoodsInfCount");
    }


    /**
     * 将最佳倍率和最大积分值存入相应的单品信息中
     * @param updateParams
     * @return
     */
    public Integer updateItemInf(Map<String,Object> updateParams){
        return getSqlSession().update("DealBestRate.updateItemInf", updateParams);
    }

    /**
     * 更新正在运行的批处理的状态
     * @param dealBestRateModel
     * @return
     */
    public Integer updateStatusByRunning(DealBestRateModel dealBestRateModel){
        return getSqlSession().update("DealBestRate.updateStatusByRunning",dealBestRateModel);
    }
}
