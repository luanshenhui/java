package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.TblOrderBkupOutSystemModel;
import cn.com.cgbchina.batch.model.TblOrderOutSystemModel;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by 11150121050003 on 2016/9/3.
 */
@Repository
public class ClearOrderOutSysDao extends BaseDao<TblOrderOutSystemModel> {

    /**
     * 查询推送状态为1的所有记录
     * @return
     */
    public List<TblOrderOutSystemModel> findOrderOutSysList() {
        return getSqlSession().selectList("ClearOrderOutSystem.findOrderOutSysList");
    }


    public Integer insertOrderBkupOutSystem(TblOrderBkupOutSystemModel model) {
        return getSqlSession().insert("ClearOrderOutSystem.insertOrderBkupOutSystem",model);
    }

    public Integer deleteOrderOutSystem(TblOrderOutSystemModel model) {
        return getSqlSession().delete("ClearOrderOutSystem.deleteOrderOutSystem",model);
    }
}
