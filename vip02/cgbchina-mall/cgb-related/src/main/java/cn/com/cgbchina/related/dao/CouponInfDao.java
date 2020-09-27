package cn.com.cgbchina.related.dao;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.model.GoodsModel;
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

    public Integer updateAll(CouponInfModel couponInf) {
        return getSqlSession().update("CouponInfModel.updateAll", couponInf);
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

    /**
     * 检索商品可以领取的优惠卷信息
     * @param params 商品信息（DataTable Mapped Entity）
     * @return CouponInfModel 优惠券信息（DataTable Mapped Entity）
     */
    public List<CouponInfModel> findByGoodsInfo(Map<String, Object> params) {
        return getSqlSession().selectList("CouponInfModel.findByGoodsInfo", params);
    }

    /**
     * 检索商品可以使用的优惠卷信息
     * @param params 商品信息（DataTable Mapped Entity）
     * @return CouponInfModel 优惠券信息（DataTable Mapped Entity）
     */
    public List<CouponInfModel> findByGoodsSpendableInfo(Map<String, Object> params) {
        return getSqlSession().selectList("CouponInfModel.findByGoodsSpendableInfo", params);
    }

    /**
     * 更新其他首次登录设置
     * @return 更新结果
     *
     * geshuo 20160806
     */
    public Integer updateOtherFirstLogin() {
        return getSqlSession().update("CouponInfModel.updateOtherFirstLogin");
    }

    //根据id查询优惠券系统是否存在
    public List<String> findCouponsByCoupons(List<String> ids){
        return getSqlSession().selectList("CouponInfModel.findCouponsByCoupons",ids);
    }

    public Integer updateById(CouponInfModel couponInf) {
        return getSqlSession().update("CouponInfModel.updateById",couponInf);
    }

    /**
     * 失效所有优惠券
     *
     * @return
     */
    public Integer deleteAll(){
        return getSqlSession().update("CouponInfModel.deleteAll");
    }

    /**
     * 新增优惠券（list）
     *
     * @param couponInfModelList
     * @return
     */
    public Integer createForList(List<CouponInfModel> couponInfModelList){
        return getSqlSession().insert("CouponInfModel.insertForList", couponInfModelList);
    }

    /**
     * 根据id集合查询优惠券
     *
     * @param ids
     * @return
     */
    public List<String> findByCouponIds(List<String> ids){
        return getSqlSession().selectList("CouponInfModel.findByCouponIds",ids);
    }

    /**
     * 更新优惠券（list）部分字段
     *
     * @param couponInfModels
     * @return
     */
    public Integer updateForList(List<CouponInfModel> couponInfModels){
        return getSqlSession().update("CouponInfModel.updateForList", couponInfModels);
    }

    /**
     * 删除要插入的优惠券
     */
    public Integer deleteCreat(List<CouponInfModel> couponInfModels){
        return getSqlSession().delete("CouponInfModel.deleteCreat",couponInfModels);
    }
}