package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.BatchOrderModel;
import cn.com.cgbchina.batch.model.OpsOrderModel;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by dhc on 2016/7/19.
 */
@Repository
public class OpsOrderProgressSearchDao extends BaseDao<BatchOrderModel> {


    public Integer getSumOPSOrderCount(){
        return getSqlSession().selectOne("OPSOrderProgressSearch.getSumOPSOrderCount");
    }

    public List<OpsOrderModel> getAllOPSOrderByStatus(String preTime, int offset, int limit){
    	Map<String,Object> param=new HashMap<>();
    	param.put("preTime",preTime);
    	param.put("offset",offset);
    	param.put("limit",limit);
        return getSqlSession().selectList("OPSOrderProgressSearch.getAllOPSOrderByStatus",
        		param);
    }

    public String findCurStatusIdById(String orderId) {
        return getSqlSession().selectOne("OPSOrderProgressSearch.findCurStatusIdById", orderId);
    }

    /**
     * 更新is_cancel_ops字段值为1
     * @param orderId
     */
    public void updateIsCancelOps(String orderId) {
        getSqlSession().update("OPSOrderProgressSearch.updateIsCancelOps",orderId);
    }

}
