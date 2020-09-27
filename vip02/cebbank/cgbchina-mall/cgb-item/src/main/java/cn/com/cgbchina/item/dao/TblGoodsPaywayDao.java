package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblGoodsPaywayDao extends SqlSessionDaoSupport {

    public Integer update(TblGoodsPaywayModel tblGoodsPayway) {
        return getSqlSession().update("TblGoodsPaywayModel.update", tblGoodsPayway);
    }


    public Integer insert(TblGoodsPaywayModel tblGoodsPayway) {
        return getSqlSession().insert("TblGoodsPaywayModel.insert", tblGoodsPayway);
    }


    public List<TblGoodsPaywayModel> findAll() {
        return getSqlSession().selectList("TblGoodsPaywayModel.findAll");
    }


    public TblGoodsPaywayModel findById(String goodsPaywayId) {
        return getSqlSession().selectOne("TblGoodsPaywayModel.findById", goodsPaywayId);
    }


    public Pager<TblGoodsPaywayModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblGoodsPaywayModel.count", params);
        if (total == 0) {
        return Pager.empty(TblGoodsPaywayModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblGoodsPaywayModel> data = getSqlSession().selectList("TblGoodsPaywayModel.pager", paramMap);
        return new Pager<TblGoodsPaywayModel>(total, data);
    }


    public Integer delete(TblGoodsPaywayModel tblGoodsPayway) {
        return getSqlSession().delete("TblGoodsPaywayModel.delete", tblGoodsPayway);
    }

    public Integer insertBatch(List<TblGoodsPaywayModel> list){
        return getSqlSession().insert("TblGoodsPaywayModel.insertBatch",list);
    }

    /**
     * 通过单品ID和分期数检索对象
     *
     * @param params
     * @return
     */

    public TblGoodsPaywayModel findByItemCodeAndStagesCode(Map<String, Object> params) {
        return getSqlSession().selectOne("TblGoodsPaywayModel.findByItemCodeAndStagesCode", params);
    }


    public List<TblGoodsPaywayModel> getPayWayforItemId(TblGoodsPaywayModel tblGoodsPaywayModel){
        return getSqlSession().selectList("TblGoodsPaywayModel.findAll", tblGoodsPaywayModel);
    }

    /**
     *通过单品code获取对象list
     * @param itemCode
     * @return
     */
    public List<TblGoodsPaywayModel> findByItemCode(String itemCode){
        return getSqlSession().selectList("TblGoodsPaywayModel.findByItemCode", itemCode);
    }


}