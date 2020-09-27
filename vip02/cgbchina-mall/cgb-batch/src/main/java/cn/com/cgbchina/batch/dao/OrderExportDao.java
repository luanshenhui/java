package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.OrderExportModel;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by zhangLin on 2016/12/1.
 */
@Repository
public class OrderExportDao extends SqlSessionDaoSupport {

    public List<OrderExportModel> getExportedExcelOrder(Map<String, Object> paraMap) {
        return getSqlSession().selectList("OrderExport.exportedExcelOrder", paraMap);
    }

    public List<OrderExportModel> getExportedExcelOrderOld(Map<String, Object> paraMap) {
        return getSqlSession().selectList("OrderExport.exportedExcelOrderOld", paraMap);
    }

    public Long getExportedExcelOrderCount(Map<String, Object> paraMap) {
        return getSqlSession().selectOne("OrderExport.exportedExcelOrderCount", paraMap);
    }

    public Long getExportedExcelOrderOldCount(Map<String, Object> paraMap) {
        return getSqlSession().selectOne("OrderExport.exportedExcelOrderOldCount", paraMap);
    }

    public List<Map<String, Object>> getOrderDodetail(List<String> orderIds){
        return getSqlSession().selectList("OrderExport.findDoDetail",orderIds);
    }

    public List<Map<String, Object>> getOrderDodetailOld(List<String> orderIds){
        return getSqlSession().selectList("OrderExport.findDoDetailOld",orderIds);
    }

}
