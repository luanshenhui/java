package cn.com.cgbchina.related.dao;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.rest.provider.model.order.MsgQuery;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.related.model.InfoOutSystemModel;

@Repository
public class InfoOutSystemDao extends SqlSessionDaoSupport {

    public Integer update(InfoOutSystemModel infoOutsystem) {
        return getSqlSession().update("InfoOutSystemModel.update", infoOutsystem);
    }


    public Integer insert(InfoOutSystemModel infoOutsystem) {
        return getSqlSession().insert("InfoOutSystemModel.insert", infoOutsystem);
    }


    public List<InfoOutSystemModel> findAll() {
        return getSqlSession().selectList("InfoOutSystemModel.findAll");
    }


    public InfoOutSystemModel findById(Long id) {
        return getSqlSession().selectOne("InfoOutSystemModel.findById", id);
    }


    public Pager<InfoOutSystemModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("InfoOutSystemModel.count", params);
        if (total == 0) {
        return Pager.empty(InfoOutSystemModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<InfoOutSystemModel> data = getSqlSession().selectList("InfoOutSystemModel.pager", paramMap);
        return new Pager<InfoOutSystemModel>(total, data);
    }


    public Integer delete(InfoOutSystemModel infoOutsystem) {
        return getSqlSession().delete("InfoOutSystemModel.delete", infoOutsystem);
    }

    public InfoOutSystemModel validateOrderId(String orderId) {
        return getSqlSession().selectOne("InfoOutSystemModel.findByOrderId", orderId);
    }

    public Integer updateValidateCode(InfoOutSystemModel updateOutSystemModel) {
        return getSqlSession().update("InfoOutSystemModel.updateValidateCode", updateOutSystemModel);
    }

    public List<InfoOutSystemModel> findByOrderId(String orderId) {
        return getSqlSession().selectList("InfoOutSystemModel.findByOrderId", orderId);
    }

    public Integer updateMsgStatus(InfoOutSystemModel infoOutModel) {
        return getSqlSession().update("InfoOutSystemModel.updateMsgStatus", infoOutModel);
    }

    public Integer updateInfoByOrderId(InfoOutSystemModel infoOutSystemModel) {
        return getSqlSession().update("InfoOutSystemModel.updateInfoByOrderId", infoOutSystemModel);
    }

    /**
     * 倒序获取对象集合
     * @param orderId
     * @return
     * @add by yanjie.cao
     */
    public List<InfoOutSystemModel> findByOrderIdDesc(String orderId) {
        return getSqlSession().selectList("InfoOutSystemModel.findByOrderIdDesc", orderId);
    }

    public List<InfoOutSystemModel> findInfoByOrderId(String orderId) {
        return getSqlSession().selectList("InfoOutSystemModel.findInfoByOrderId", orderId);
    }

    public List<InfoOutSystemModel> findInfoByValidateStatus(Map<String, Object> params) {
        return getSqlSession().selectList("InfoOutSystemModel.findInfoByValidateStatus", params);
    }


}