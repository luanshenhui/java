package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.*;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Map;

;

/**
 * @author wenjia.hao
 * @version 1.0
 */
@Repository
public class PromDao extends BaseDao<PromotionBatchModel> {
    public List<String> getItemByPromoBatch(Map<String, Object> paraMap) {
        return getSqlSession().selectList("PromBatch.getItemByPromoBatch", paraMap);
    }

    public List<PromEntry> getPromByItem(Map<String, Object> paraMap) {
        return getSqlSession().selectList("PromBatch.getPromByItem", paraMap);
    }

    public List<PromotionBatchModel> getPromotionForBatch(Map<String, Object> map) {
        return getSqlSession().selectList("PromBatch.getPromotionForBatch", map);
    }

    public List<PromotionPeriodBatchModel> getForBatch(Map<String, Object> map) {
        return getSqlSession().selectList("PromBatch.getForBatch", map);
    }

    public List<PromotionBatchModel> findPromotionByIds(List<Integer> promotionIds) {
        return getSqlSession().selectList("PromBatch.findPromotionByIds", promotionIds);
    }

    public List<PromotionRangeBatchModel> findByPromId(Integer promotionId) {
        return getSqlSession().selectList("PromBatch.findPromRangeByPromId", promotionId);
    }

    public List<String> getYesterExpire(Map<String, Object> map) {
        return getSqlSession().selectList("PromBatch.getYesterExpire", map);
    }

    public Integer updatePromStatus(Map<String, Object> map) {
        return getSqlSession().update("PromBatch.updatePromStatus", map);
    }

    public PromotionRangeBatchModel findPromRangeById(Integer id) {
        return getSqlSession().selectOne("PromBatch.findPromRangeById", id);
    }

    public List<PromEntry> promOfDay(Map<String, Object> map) {
        return getSqlSession().selectList("PromBatch.promOfDay", map);
    }

    /**
     * 获取数据库当前时间
     * @return 当前时间
     *
     * geshuo 20160726
     */
    public Date findCurrentDate(){
        return getSqlSession().selectOne("PromBatch.findCurrentDate");
    }

    /**
     * 获取需要释放的记录总数
     * @return 总数
     *
     * geshuo 20160726
     */
    public Integer findOvertimeRecordCount(Date overTime){
        return getSqlSession().selectOne("PromBatch.findOvertimeRecordCount",overTime);
    }

    /**
     * 获取荷兰拍需要释放的记录(每次取指定数量,循环取)
     * @param paramMap 查询参数
     * @return 查询结果
     *
     * geshuo 20160726
     */
    public List<AuctionRecordBatchModel> findOvertimeRecord(Map<String,Object> paramMap){
        return getSqlSession().selectList("PromBatch.findOvertimeRecord",paramMap);
    }

    /**
     * 更新对应拍卖记录状态，标识已经释放库存，不能再生成订单
     * @param paramMap 更新参数
     * @return 更新结果
     *
     * geshuo 20160726
     */
    public Integer updateRecordReleased(Map<String,Object> paramMap){
        return getSqlSession().update("PromBatch.updateRecordReleased", paramMap);
    }
    public Integer updateRecordReleasedByOrderId(Map<String,Object> paramMap){
        return getSqlSession().update("PromBatch.updateRecordReleasedByOrderId",paramMap);
    }

    /**
     * 获取已经生成订单的,需要释放的记录总数
     * @param paramMap 查询参数
     * @return 总数
     *
     * geshuo 20160726
     */
    public Integer findOrderOvertimeRecordCount(Map<String,Object> paramMap){
        return getSqlSession().selectOne("PromBatch.findOrderOvertimeRecordCount",paramMap);
    }

    /**
     * 获取已经生成订单的,需要释放的记录
     * @param paramMap 查询参数
     * @return 记录列表
     *
     * geshuo 20160726
     */
    public List<AuctionRecordBatchModel> findOrderOvertimeRecord(Map<String,Object> paramMap){
        return getSqlSession().selectList("PromBatch.findOrderOvertimeRecord",paramMap);
    }

    /**
     * 根据订单id查询订单
     * @param orderId 订单Id
     * @return 订单信息
     *
     * geshuo 20160726
     */
    public BatchOrderModel findOrderById(String orderId){
        return getSqlSession().selectOne("PromBatch.findOrderById",orderId);
    }

    /**
     * 根据rangeid List 查询活动已售完单品数据
     *
     * @param param
     * @return
     */
    public List<PromotionRangeBatchModel> findSaleOverByRangIds(Map<String, Object> param) {
        return getSqlSession().selectList("PromBatch.findSaleOverByRangIds", param);
    }
    public List<PromotionPeriodBatchModel> findPeriodsByPromIds(List<String> promIds){
        return getSqlSession().selectList("PromBatch.findPeriodsByPromIds",promIds);
    }
}
