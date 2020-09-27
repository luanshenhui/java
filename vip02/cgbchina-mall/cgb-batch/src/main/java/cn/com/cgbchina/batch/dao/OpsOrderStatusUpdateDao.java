package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.BatchOrderModel;
import cn.com.cgbchina.batch.model.OrderCheckModel;
import cn.com.cgbchina.batch.model.OrderDoDetailModel;
import cn.com.cgbchina.batch.model.OrderSubModel;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Repository;

import java.util.Map;

/**
 * Created by dhc on 2016/7/28.
 */
@Repository
public class OpsOrderStatusUpdateDao extends BaseDao<BatchOrderModel> {

    public int updateOPSOrderStatus(Map<String,Object> params){
        return getSqlSession().update("OPSOrderStatusUpdate.updateOPSOrderStatus",params);
    }

    public int updateTblOrderExtend1(Map<String,Object> params){
        return getSqlSession().update("OPSOrderStatusUpdate.updateTblOrderExtend1",params);
    }

    public OrderSubModel findOrderById(String orderId){
        return getSqlSession().selectOne("OPSOrderStatusUpdate.findOrderById",orderId);
    }

    public int updateGoodsStock(String goodsId){
        return getSqlSession().update("OPSOrderStatusUpdate.updateGoodsStock",goodsId);
    }

    public int dealPointPool(Map<String,Object> params) {
        return getSqlSession().update("OPSOrderStatusUpdate.dealPointPool",params);
    }

    public int insertOrderDoDetail(OrderDoDetailModel orderDoDetailModel) {
        return getSqlSession().insert("OPSOrderStatusUpdate.insertOrderDoDetail", orderDoDetailModel);
    }

    public int saveTblOrderCheck(OrderCheckModel orderCheckModel) {
        return getSqlSession().insert("OPSOrderStatusUpdate.insertOrderCheckModel", orderCheckModel);
    }

//    //更新购物车
//    public void updateTblEspCustCartByOrderId(String orderId,String payFlag){
//        Map<String,Object> params = Maps.newHashMap();
//        params.put("payFlag",payFlag);
//        params.put("orderId",orderId);
//        getSqlSession().update("OPSOrderStatusUpdate.updateTblEspCustCartByOrderId",params);
//    }

    /**
     * 更新拍卖记录表（荷兰拍）
     * @param auctionId
     */
    public void updateRecordSucc(String auctionId) {
        getSqlSession().update("OPSOrderStatusUpdate.updateRecordSucc",auctionId);
    }

    /**
     * 更新对应拍卖记录状态，标识已经释放库存，不能再生成订单，对应已经生成订单的活动记录（荷兰拍）
     * @param id
     * @return
     */
    public int updateRecordOrderReleased(String id) {
        return getSqlSession().update("OPSOrderStatusUpdate.updateRecordOrderReleased",id);
    }
}
