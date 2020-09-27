package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.SynBonusModel;
import org.springframework.stereotype.Repository;

import java.util.Map;

/**
 * Created by txy on 2016/7/21.
 */
@Repository
public class SynBonusDao extends BaseDao{

    public SynBonusModel findById(String integraltypeId) {
        return getSqlSession().selectOne("SynBonus.findById", integraltypeId);
    }
    public Integer update(Map<String,Object> params){
        return getSqlSession().update("SynBonus.update",params);
    }
    public Integer create(Map<String,Object> createParams){
        return getSqlSession().insert("SynBonus.create",createParams);
    }
}
