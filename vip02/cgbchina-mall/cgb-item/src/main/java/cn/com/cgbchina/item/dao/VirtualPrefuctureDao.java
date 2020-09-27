package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.VirtualPrefuctureModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 增值服务专区 DAO
 *
 * add by zhoupeng
 */
@Repository
public class VirtualPrefuctureDao extends SqlSessionDaoSupport {

    public Integer update(VirtualPrefuctureModel virtualPrefucture) {
        return getSqlSession().update("VirtualPrefuctureModel.update", virtualPrefucture);
    }


    public Integer insert(VirtualPrefuctureModel virtualPrefucture) {
        return getSqlSession().insert("VirtualPrefuctureModel.insert", virtualPrefucture);
    }


    public List<VirtualPrefuctureModel> findAll() {
        return getSqlSession().selectList("VirtualPrefuctureModel.findAll");
    }


    public VirtualPrefuctureModel findById(Integer id) {
        return getSqlSession().selectOne("VirtualPrefuctureModel.findById", id);
    }

    /**
     * 根据 prefuctureId 查询
     * @param prefuctureId
     * @return
     */
    public VirtualPrefuctureModel findById(String prefuctureId) {
        return getSqlSession().selectOne("VirtualPrefuctureModel.findByPrefuctureId", prefuctureId);
    }


    public Pager<VirtualPrefuctureModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("VirtualPrefuctureModel.count", params);
        if (total == 0) {
        return Pager.empty(VirtualPrefuctureModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<VirtualPrefuctureModel> data = getSqlSession().selectList("VirtualPrefuctureModel.pager", paramMap);
        return new Pager<VirtualPrefuctureModel>(total, data);
    }

    public Integer delete(VirtualPrefuctureModel virtualPrefucture) {
        return getSqlSession().delete("VirtualPrefuctureModel.delete", virtualPrefucture);
    }
}