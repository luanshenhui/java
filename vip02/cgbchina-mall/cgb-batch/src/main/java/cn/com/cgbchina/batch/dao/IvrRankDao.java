package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.IvrRankModel;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by txy on 2016/7/22.
 */
@Repository
public class IvrRankDao extends BaseDao {
    /**
     * 获取可用的积分类型
     *
     * @return
     */
    public List<String> findIntegraltypeList() {
        return getSqlSession().selectList("IvrRank.findIntegraltypeList");
    }

    /**
     * 根据条件取得单品Id、单品数量和
     *
     * @param params
     * @return
     */
    public List<IvrRankModel> findItemSum(Map<String, Object> params) {
        return getSqlSession().selectList("IvrRank.findItemSum", params);
    }

    /**
     * 更新排行存储表 已有的积分类型的删除标识
     * @param params
     * @return
     */
    public Integer updateDelFlag(Map<String, Object> params){
        return getSqlSession().update("IvrRank.updateDelFlag",params);
    }

    /**
     * 将新的排行信息插入表中
     * @param createParams
     * @return
     */
    public Integer createRank(Map<String,Object> createParams){
        return getSqlSession().insert("IvrRank.createRank",createParams);
    }
}
