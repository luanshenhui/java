package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;

import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblCfgIntegraltypeDao extends SqlSessionDaoSupport {

    public Integer update(TblCfgIntegraltypeModel tblCfgIntegraltype) {
        return getSqlSession().update("TblCfgIntegraltypeModel.update", tblCfgIntegraltype);
    }


    public Integer insert(TblCfgIntegraltypeModel tblCfgIntegraltype) {
        return getSqlSession().insert("TblCfgIntegraltypeModel.insert", tblCfgIntegraltype);
    }


    public List<TblCfgIntegraltypeModel> findAll() {
        return getSqlSession().selectList("TblCfgIntegraltypeModel.findAll");
    }


    public TblCfgIntegraltypeModel findById(String integraltypeId) {
        return getSqlSession().selectOne("TblCfgIntegraltypeModel.findById", integraltypeId);
    }


    public Pager<TblCfgIntegraltypeModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblCfgIntegraltypeModel.count", params);
        if (total == 0) {
            return Pager.empty(TblCfgIntegraltypeModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblCfgIntegraltypeModel> data = getSqlSession().selectList("TblCfgIntegraltypeModel.pager", paramMap);
        return new Pager<TblCfgIntegraltypeModel>(total, data);
    }


    public Integer delete(TblCfgIntegraltypeModel tblCfgIntegraltype) {
        return getSqlSession().delete("TblCfgIntegraltypeModel.delete", tblCfgIntegraltype);
    }

    /**
     * 查询积分类型列表
     * @param paramMap 查询参数
     * @return 查询结果
     *
     * geshuo 20160823
     */
    public List<TblCfgIntegraltypeModel> findByParams(Map<String,Object> paramMap){
        return getSqlSession().selectList("TblCfgIntegraltypeModel.findByParams", paramMap);
    }

    /**
     * 查询积分类型 list
     * @param list 对象类型中 取出 integraltype id 集合
     * @return 查询结果
     *
     * add by zhoupeng
     */
    public List<TblCfgIntegraltypeModel> findByIds(List list){
        return getSqlSession().selectList("TblCfgIntegraltypeModel.findByIds", list);
    }

}