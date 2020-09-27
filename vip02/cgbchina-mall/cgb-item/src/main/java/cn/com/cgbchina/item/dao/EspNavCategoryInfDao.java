package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.EspNavCategoryInfModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class EspNavCategoryInfDao extends SqlSessionDaoSupport {

    public Integer update(EspNavCategoryInfModel espNavCategoryInf) {
        return getSqlSession().update("EspNavCategoryInfModel.update", espNavCategoryInf);
    }


    public Integer insert(EspNavCategoryInfModel espNavCategoryInf) {
        return getSqlSession().insert("EspNavCategoryInfModel.insert", espNavCategoryInf);
    }


    public List<EspNavCategoryInfModel> findAll() {
        return getSqlSession().selectList("EspNavCategoryInfModel.findAll");
    }


    public EspNavCategoryInfModel findById(Long id) {
        return getSqlSession().selectOne("EspNavCategoryInfModel.findById", id);
    }

    public EspNavCategoryInfModel findByCategoryId(String categoryId){
        return getSqlSession().selectOne("EspNavCategoryInfModel.findByCategoryId", categoryId);
    }

    public Pager<EspNavCategoryInfModel> findByPage(Map<String, Object> params) {
        Long total = getSqlSession().selectOne("EspNavCategoryInfModel.count", params);
        if (total == 0) {
            return Pager.empty(EspNavCategoryInfModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        List<EspNavCategoryInfModel> data = getSqlSession().selectList("EspNavCategoryInfModel.pager", paramMap);
        return new Pager<EspNavCategoryInfModel>(total, data);
    }


    public Integer delete(EspNavCategoryInfModel espNavCategoryInf) {
        return getSqlSession().delete("EspNavCategoryInfModel.delete", espNavCategoryInf);
    }

    public List<EspNavCategoryInfModel> findBrandTypes() {
        return getSqlSession().selectList("EspNavCategoryInfModel.findBrandTypes");
    }

    public Integer findMaxId() {
        return getSqlSession().selectOne("EspNavCategoryInfModel.findMaxId");
    }
}