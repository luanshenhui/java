package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.SmspInfModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
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
     * @param smspInf
     * @return
     */
    public Integer submitAll(SmspInfModel smspInf) {
        return getSqlSession().update("SmspInfModel.submitAll", smspInf);
    }

    /**
     * 短信模板管理批量删除 niufw
     *
     * @param smspInf
     * @return
     */
    public Integer deleteAll(SmspInfModel smspInf) {
        return getSqlSession().update("SmspInfModel.deleteAll", smspInf);
    }

    /**
     * 审核通过 niufw
     *
     * @param id
     * @return
     */
    public Integer smsTemplateCheck(Long id) {
        return getSqlSession().update("SmspInfModel.smsTemplateCheck", id);
    }

    /**
     * 拒绝 niufw
     *
     * @param id
     * @return
     */
    public Integer smsTemplateRefuse(Long id) {
        return getSqlSession().update("SmspInfModel.smsTemplateRefuse", id);
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
}