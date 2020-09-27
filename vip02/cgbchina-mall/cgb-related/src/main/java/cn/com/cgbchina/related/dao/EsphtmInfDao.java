package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.EsphtmInfModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class EsphtmInfDao extends SqlSessionDaoSupport {

    public Integer update(EsphtmInfModel esphtmInf) {
        return getSqlSession().update("EsphtmInfModel.update", esphtmInf);
    }


    /**
     * 新增静态页
     * @param esphtmInf 新增值
     * @return
     */
    public Integer insert(EsphtmInfModel esphtmInf) {
        return getSqlSession().insert("EsphtmInfModel.insert", esphtmInf);
    }

    public List<EsphtmInfModel> findEndHtml(EsphtmInfModel esphtmInf) {
        return getSqlSession().selectList("EsphtmInfModel.findEndHtml", esphtmInf);
    }


    public List<EsphtmInfModel> findAll() {
        return getSqlSession().selectList("EsphtmInfModel.findAll");
    }


    public EsphtmInfModel findById(String actId) {
        return getSqlSession().selectOne("EsphtmInfModel.findById", actId);
    }


    public Pager<EsphtmInfModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("EsphtmInfModel.count", params);
        if (total == 0) {
        return Pager.empty(EsphtmInfModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<EsphtmInfModel> data = getSqlSession().selectList("EsphtmInfModel.pager", paramMap);
        return new Pager<EsphtmInfModel>(total, data);
    }


    public Integer delete(String actId) {
        return getSqlSession().delete("EsphtmInfModel.delete", actId);
    }

    /**
     * 更新状态
     * @param esphtmInfModel 更新值
     * @return
     */
    public Integer updateVendorId(EsphtmInfModel esphtmInfModel) {
        return getSqlSession().update("EsphtmInfModel.updateVendorId", esphtmInfModel);
    }

    /**
     * 更新指定人
     * @param esphtmInfModel 更新值
     * @return
     */
//    public Integer updateVendorId(EsphtmInfModel esphtmInfModel) {
//        return getSqlSession().update("EsphtmInfModel.updateVendorId", esphtmInfModel);
//    }

}