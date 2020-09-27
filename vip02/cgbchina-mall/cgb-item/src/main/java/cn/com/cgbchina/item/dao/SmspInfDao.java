package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.SmspInfModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class SmspInfDao extends SqlSessionDaoSupport {

    public Integer update(SmspInfModel smspInf) {
        return getSqlSession().update("SmspInfModel.update", smspInf);
    }

    /**
     * 逻辑删除 niufw
     *
     * @param id
     * @return
     */
    public Integer updateForDelete(Long id) {
        return getSqlSession().update("SmspInfModel.updateForDelete", id);
    }

    /**
     * 提交 niufw
     *
     * @param id
     * @return
     */
    public Integer updateForSubmit(Long id) {
        return getSqlSession().update("SmspInfModel.updateForSubmit", id);
    }

    /**
     * 短信模板管理批量提交 niufw
     *
     * @param paramMap
     * @return
     */
    public Integer submitAll(Map<String, Object> paramMap) {
        return getSqlSession().update("SmspInfModel.submitAll", paramMap);
    }

    /**
     * 短信模板管理批量删除 niufw
     *
     * @param paramMap
     * @return
     */
    public Integer deleteAll(Map<String, Object> paramMap) {
        return getSqlSession().update("SmspInfModel.deleteAll", paramMap);
    }

    public Integer insert(SmspInfModel smspInf) {
        return getSqlSession().insert("SmspInfModel.insert", smspInf);
    }

    public List<SmspInfModel> findAll() {
        return getSqlSession().selectList("SmspInfModel.findAll");
    }

    public SmspInfModel findById(Long id) {
        return getSqlSession().selectOne("SmspInfModel.findById", id);
    }

    public Pager<SmspInfModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("SmspInfModel.count", params);
        if (total == 0) {
            return Pager.empty(SmspInfModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<SmspInfModel> data = getSqlSession().selectList("SmspInfModel.pager", paramMap);
        return new Pager<SmspInfModel>(total, data);
    }

    public Integer delete(SmspInfModel smspInf) {
        return getSqlSession().delete("SmspInfModel.delete", smspInf);
    }

    /**
     * 用于审核、拒绝、白名单发送的更新当前状态
     *
     * @param smspInfModel
     * @return
     */
    public Integer updateStatus(SmspInfModel smspInfModel) {
        return getSqlSession().update("SmspInfModel.updateStatus", smspInfModel);
    }

    public SmspInfModel findAllByIds(List<String> ids) {
        return getSqlSession().selectOne("SmspInfModel.findByIds", ids);
    }
}