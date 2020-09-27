package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.MakeCheckAccModel;
import cn.com.cgbchina.batch.model.OrderMainModel;
import cn.com.cgbchina.batch.model.TblMakecheckjobHistoryModel;
import com.google.common.collect.Maps;
import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by w2001316 on 2016/7/28.
 */
@Repository
public class MakeCheckAccDao extends BaseDao {
    /**
     * 获取数据库的当前时间
     *
     * @return
     */
    public String getdbtime() {
        return getSqlSession().selectOne("MakeCheckAcc.getDbTime");
    }

    public Integer getSumCheckAccOrderMain(String yesDay, String payResultTime) {
        Map<String,Object> params = Maps.newHashMap();
        params.put("yesDay",yesDay);
        params.put("payResultTime",payResultTime);
        return getSqlSession().selectOne("MakeCheckAcc.findBySumCheckAccOrderMain", params);
    }

    public List<OrderMainModel> getCheckAccOrderMain(int offset, int limit, String yesDay, String payResultTime) {
        Map<String,Object> params = Maps.newHashMap();
        params.put("yesDay",yesDay);
        params.put("payResultTime",payResultTime);
        params.put("offset", offset);
        params.put("limit", limit);
        return getSqlSession().selectList("MakeCheckAcc.findByCheckAccOrderMain", params);
    }

    public Integer getSumCCCheckAccOrder(String yesDay, String payResultTime) {
        Map<String,Object> params = Maps.newHashMap();
        params.put("yesDay",yesDay);
        params.put("payResultTime",payResultTime);
        return getSqlSession().selectOne("MakeCheckAcc.findBySumCCCheckAccOrder", params);
    }

    public List<MakeCheckAccModel> getCCCheckAccOrder(int offset, int limit,String yesDay, String payResultTime) {
        Map<String,Object> params = Maps.newHashMap();
        params.put("yesDay",yesDay);
        params.put("payResultTime",payResultTime);
        params.put("offset", offset);
        params.put("limit", limit);
        return getSqlSession().selectList("MakeCheckAcc.findByCCCheckAccOrder", params);
    }

    public List<String> getTblOrderCancel(String yesDay) {
        return getSqlSession().selectList("MakeCheckAcc.findByTblOrderCancel", yesDay);
    }

    public List<MakeCheckAccModel> getTblOrderCancelList(String orderId) {
        return getSqlSession().selectList("MakeCheckAcc.findByTblOrderCancelList", orderId);
    }

    public String getRefundIntegralByBonus(String orderId) {
        return getSqlSession().selectOne("MakeCheckAcc.findByRefundIntegralByBonus", orderId);
    }

    public List<MakeCheckAccModel> getTblOrderPointList(String date) {
        return getSqlSession().selectList("MakeCheckAcc.findByTblOrderPointList", date);
    }

    public List<MakeCheckAccModel> getTblOrderPointList1(String date) {
        return getSqlSession().selectList("MakeCheckAcc.findByTblOrderPointList1", date);
    }

    public void updateCheckStatus(String date, String payResultTime) {
        Map<String,Object> params = Maps.newHashMap();
        params.put("date",date);
        params.put("payResultTime",payResultTime);
        getSqlSession().update("MakeCheckAcc.updateByCheckStatus", params);
    }

    public void updateTblOrderCancel(String date) {
        getSqlSession().update("MakeCheckAcc.updateTblOrderCancel", date);
    }

    public void updatePoint1(Long id, String date) {
        Map<String, Object> params = com.google.common.collect.Maps.newHashMap();
        params.put("id", id);
        params.put("date", date);
        getSqlSession().update("MakeCheckAcc.updateByTblOrderPoint1", params);
    }

    public void updatePoint2(Long id, String date) {
        Map<String, Object> params = com.google.common.collect.Maps.newHashMap();
        params.put("id", id);
        params.put("date", date);
        getSqlSession().update("MakeCheckAcc.updateByTblOrderPoint2", params);
    }

    public Integer insertTblMakecheckjobHistory(TblMakecheckjobHistoryModel tblMakecheckjobHistory) {
        return getSqlSession().insert("MakeCheckAcc.insertByTblMakecheckjobHistory", tblMakecheckjobHistory);
    }

}
