package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.CCCheckAccOrderModel;
import cn.com.cgbchina.batch.model.OrderMainModel;
import cn.com.cgbchina.batch.model.OrderSubModel;
import cn.com.cgbchina.batch.model.TblMakecheckjobHistoryModel;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.collect.Maps;
import org.apache.ibatis.session.RowBounds;
import org.joda.time.DateTime;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by dhc on 2016/7/26.
 */
@Repository
public class MakeCheckAccRenewDao extends BaseDao{

    /**
     * 获取是否手动处理对账文件异常标示 0:手动 1:自动
     * @return
     */
    public String getisShouDong() {
        return getSqlSession().selectOne("MakeCheckAccRenew.getisShouDong");
    }

    /**
     * 获取支付成功但没有送对账文件的天的集合(+退货成功但是木有送对账文件)
     * @return
     */
    public List<String> getMakeAccErrDays(){
        Map<String, String> map = Maps.newHashMap();
        map.put("nowday", DateTime.now().toString(DateHelper.YYYY_MM_DD).concat(" 00:00:00"));
        map.put("prevDate", DateHelper.getYestoday().replaceAll("-", ""));
        return getSqlSession().selectList("MakeCheckAccRenew.getMakeAccErrDays", map);
    }

    /**
     * 获取数据库的当前时间
     *
     * @return
     */
    public String getdbtime() {
        return getSqlSession().selectOne("MakeCheckAccRenew.getDbTime");
    }

    /**
     * 处理大订单订单(积分商城)总数
     * @param date
     * @param payResultTime
     * @return
     */
    public Integer getSumCheckAccOrderMain(String date, String payResultTime) {
        Map<String,Object> params = Maps.newHashMap();
        params.put("createTime",date);
        params.put("payResultTime",payResultTime);
        return getSqlSession().selectOne("MakeCheckAccRenew.getSumCheckAccOrderMain",params);
    }

    /**
     * 处理大订单订单(积分商城)
     * @param date
     * @param payResultTime
     * @return
     */
    public List<OrderMainModel> getCheckAccOrderMain(int offset, int limit, String date, String payResultTime) {
        Map<String,Object> params = Maps.newHashMap();
        params.put("createTime",date);
        params.put("payResultTime",payResultTime);
        params.put("offset", offset);
        params.put("limit", limit);
        return getSqlSession().selectList("MakeCheckAccRenew.getCheckAccOrderMain",params);
    }

    /**
     * 获取某天的状态曾经是支付成功的并且是CC渠道的积分大订单总数
     * @param date
     * @param payResultTime
     * @return
     */
    public Integer getSumCCCheckAccOrder(String date, String payResultTime){
        Map<String,Object> params = Maps.newHashMap();
        params.put("createTime",date);
        params.put("payResultTime",payResultTime);
        Long count = getSqlSession().selectOne("MakeCheckAccRenew.getSumCCCheckAccOrder",params);
        return count.intValue();
    }

    /**
     * 获取某天的状态曾经是支付成功的并且是CC渠道的积分大订单
     * @param offset
     * @param limit
     * @param date
     * @param payResultTime
     * @return
     */
    public List<CCCheckAccOrderModel> getCCCheckAccOrder(int offset, int limit, String date, String payResultTime){
        Map<String,Object> params = Maps.newHashMap();
        params.put("createTime",date);
        params.put("payResultTime",payResultTime);
        params.put("offset", offset);
        params.put("limit", limit);
        return getSqlSession().selectList("MakeCheckAccRenew.getCCCheckAccOrder",params);
    }

    public List<String> getSumTblOrderCancel(String date){
        return getSqlSession().selectList("MakeCheckAccRenew.getSumTblOrderCancel", date);
    }

    public List<OrderMainModel> getTblOrderCancelList(String orderId){
        return getSqlSession().selectList("MakeCheckAccRenew.getTblOrderCancelList", orderId);
    }

    /**
     * 广发商城积分支付正交易
     * @param date
     * @return
     */
    public List<OrderSubModel> getTblOrderPointList2(String date){
        return getSqlSession().selectList("MakeCheckAccRenew.getTblOrderPointList2", date);
    }

    /**
     * 处理广发/积分商城积分支付（负交易）
     * @param date
     * @return
     */
    public List<OrderSubModel> getTblOrderPointList3(String date){
        return getSqlSession().selectList("MakeCheckAccRenew.getTblOrderPointList3", date);
    }

    /**
     * 更新对账文件状态
     * @param date
     * @param payResultTime
     */
    public void updateCheckStatus(String date, String payResultTime){
        Map<String,Object> params = Maps.newHashMap();
        params.put("createTime",date);
        params.put("payResultTime",payResultTime);
        getSqlSession().update("MakeCheckAccRenew.updateCheckStatus",params);
    }

    /**
     * 更新退货对账文件状态
     * @param date
     */
    public void updateTblOrderCancel(String date){
        Map<String,Object> params = Maps.newHashMap();
        params.put("cancelTime",date);
        params.put("updateTime",DateHelper.getCurrentTime());
        getSqlSession().update("MakeCheckAccRenew.upDateTblOrderCancel",params);
    }

    public void updateTblOrderPoint1(Long id,String date){
        Map<String,Object> params = Maps.newHashMap();
        params.put("id",id);
        params.put("doDate",date);
        params.put("modifyTime",DateHelper.getCurrentTime());
        getSqlSession().update("MakeCheckAccRenew.updateTblOrderPoint1",params);
    }

    public void updateTblOrderPoint2(Long id,String date){
        Map<String,Object> params = Maps.newHashMap();
        params.put("id",id);
        params.put("doDate",date);
        params.put("modifyTime",DateHelper.getCurrentTime());
        getSqlSession().update("MakeCheckAccRenew.updateTblOrderPoint2",params);
    }

    public Integer insertTblMakecheckjobHistory(TblMakecheckjobHistoryModel tblMakecheckjobHistory){
        return getSqlSession().insert("MakeCheckAccRenew.insertTblMakecheckjobHistory", tblMakecheckjobHistory);
    }

    public Long getRefundIntegralByBonus(String orderId) {
        return getSqlSession().selectOne("MakeCheckAccRenew.findByRefundIntegralByBonus", orderId);
    }

}
