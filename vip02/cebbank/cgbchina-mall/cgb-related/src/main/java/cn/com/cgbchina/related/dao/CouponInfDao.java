package cn.com.cgbchina.related.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.related.model.CouponInfModel;

@Repository
public class CouponInfDao extends SqlSessionDaoSupport {

    public Integer update(CouponInfModel couponInf) {
        return getSqlSession().update("CouponInfModel.update", couponInf);
    }


    public Integer insert(CouponInfModel couponInf) {
        return getSqlSession().insert("CouponInfModel.insert", couponInf);
    }


    public List<CouponInfModel> findAll() {
        return getSqlSession().selectList("CouponInfModel.findAll");
    }


    public CouponInfModel findById(Integer id) {
        return getSqlSession().selectOne("CouponInfModel.findById", id);
    }
    public CouponInfModel findByCouponId(String couponId) {
        return getSqlSession().selectOne("CouponInfModel.findByCouponId", couponId);
    }

    public CouponInfModel findByFirstLogin() {
        return getSqlSession().selectOne("CouponInfModel.findByFirstLogin");
    }


    public Pager<CouponInfModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("CouponInfModel.count", params);
        if (total == 0) {
            return Pager.empty(CouponInfModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<CouponInfModel> data = getSqlSession().selectList("CouponInfModel.pager", paramMap);
        return new Pager<CouponInfModel>(total, data);
    }


    public Integer delete(CouponInfModel couponInf) {
        return getSqlSession().delete("CouponInfModel.delete", couponInf);
    }

    /**
     * 我的优惠券，详细
     * @param projectNO
     * @return
     */
    public CouponInfModel detailedCoupon(Integer projectNO) {
        return getSqlSession().selectOne("CouponInfModel.detailedCoupon", projectNO);
    }
}