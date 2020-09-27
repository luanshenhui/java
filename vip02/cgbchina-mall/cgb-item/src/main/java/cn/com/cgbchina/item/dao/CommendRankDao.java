package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.CommendRankModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class CommendRankDao extends SqlSessionDaoSupport {

    public Integer update(CommendRankModel commendRank) {
        return getSqlSession().update("CommendRankModel.update", commendRank);
    }


    public Integer insert(CommendRankModel commendRank) {
        return getSqlSession().insert("CommendRankModel.insert", commendRank);
    }


    public List<CommendRankModel> findAll() {
        return getSqlSession().selectList("CommendRankModel.findAll");
    }


    public CommendRankModel findById(Long id) {
        return getSqlSession().selectOne("CommendRankModel.findById", id);
    }


    public Pager<CommendRankModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("CommendRankModel.count", params);
        if (total == 0) {
        return Pager.empty(CommendRankModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<CommendRankModel> data = getSqlSession().selectList("CommendRankModel.pager", paramMap);
        return new Pager<CommendRankModel>(total, data);
    }


    public Integer delete(CommendRankModel commendRank) {
        return getSqlSession().delete("CommendRankModel.delete", commendRank);
    }

    //热门收藏，热门销售获得
    public List<CommendRankModel> findCommendRank(CommendRankModel commendRank){
        return getSqlSession().selectList("CommendRankModel.findCommendRank", commendRank);
    }
}