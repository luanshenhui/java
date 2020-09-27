package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.TblTransferRecordModel;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

/**
 * Created by 11150121050003 on 2016/9/5.
 */
@Repository
public class DataTransferFlowDao extends BaseDao<TblTransferRecordModel>{

    /**
     * 查出迁移进度表最后一条异常进度
     * @param isException
     * @return
     */
    public TblTransferRecordModel queryTblTransferRecordByIsException(String isException) {
        List<TblTransferRecordModel> list = getSqlSession().selectList("DataTransferFlow.queryTblTransferRecordByIsException", isException);
        if (list.isEmpty()) return null;
        return list.get(0);
    }

    /**
     * 根据id取得迁移进度表记录
     * @param id
     * @return
     */
    public TblTransferRecordModel queryTblTransferRecordById(long id) {
        return getSqlSession().selectOne("DataTransferFlow.queryTblTransferRecordById",id);
    }

    /**
     * 更新开始时间和异常状态
     * @param id
     * @param beginDate
     * @param isException
     * @return
     */
    public Integer updateTblTransferRecord2(long id,Date beginDate,String isException) {
        TblTransferRecordModel transferModel = new TblTransferRecordModel();
        transferModel.setId(id);
        transferModel.setBegin_time(beginDate);
        transferModel.setIsexception(isException);
        return getSqlSession().update("DataTransferFlow.updateTblTransferRecord2",transferModel);
    }

    /**
     * 更新结束时间和异常状态
     * @param id
     * @param endDate
     * @param isException
     * @return
     */
    public Integer updateTblTransferRecord(long id, Date endDate, String isException) {
        TblTransferRecordModel transferModel = new TblTransferRecordModel();
        transferModel.setId(id);
        transferModel.setEnd_time(endDate);
        transferModel.setIsexception(isException);
        return getSqlSession().update("DataTransferFlow.updateTblTransferRecord",transferModel);
    }

    /**
     * 插入一条迁移进度记录,并返回Id
     * @param orgTableName
     * @param targetTableName
     * @param beginDate
     * @param isException
     * @return
     */
    public long insertTblTransferRecord(String orgTableName,String targetTableName,Date beginDate,String isException){
        TblTransferRecordModel transferModel = new TblTransferRecordModel();
        transferModel.setOrgtablename(orgTableName);
        transferModel.setTargertablename(targetTableName);
        transferModel.setBegin_time(beginDate);
        transferModel.setIsexception(isException);
        getSqlSession().insert("DataTransferFlow.insertTblTransferRecord",transferModel);
        return transferModel.getId();
    }

}
