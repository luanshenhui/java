package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.DataTransferFlowDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.model.TblTransferRecordModel;
import cn.com.cgbchina.batch.model.TransferItemVo;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * Created by 11150121050003 on 2016/9/5.
 */
@Component
@Slf4j
public class DataTransferFlowManager {
    @Resource
    private DataTransferFlowDao dataTransferFlowDao;
    @Resource
    private DataTransferItemManager dataTransferItemManager;

    @Value("#{app.transferRows}")
    private Integer transferRowsInt;// 一次迁移数据行数
    @Value("#{app.transferHistoryDays}")
    private Integer transferHistoryDays;// 迁移到历史表的天数
    @Value("#{app.transferBackDays}")
    private Integer transferBackDays;// 迁移到备份表的天数
    @Value("#{app.transferAuctionDays}")
    private Integer transferAuctionDays;// 荷兰拍数据迁移天数
    @Value("#{app.transferMonthDays}")
    private Integer transferMonthDays;// 关键字数据迁移天数

    @Transactional
    public void dealTableById(String recordId,boolean isAllTableFlg) throws BatchException {
        log.info("into dealTableById");
        String tableName = null;
        String isBeginRunFlag=null;
        long recordIdLong=0;
        if(!isAllTableFlg){
	        TblTransferRecordModel model = null;
	        if (recordId == null || "".equals(recordId.trim())) {// 如果id为空，查询迁移进度表
	            model = dataTransferFlowDao.queryTblTransferRecordByIsException("1");// 查出迁移进度表最后一条异常进度
	        } else {
	            long idLong = Long.parseLong(recordId);
	            model = dataTransferFlowDao.queryTblTransferRecordById(idLong);// 根据id取得迁移进度表记录
	        }
	        if (model == null) {// 如果没查出迁移进度
	            return;
	        }
	        tableName = model.getOrgtablename();// 取得迁移进度表的原表名称
	        isBeginRunFlag = "0";// 开始迁移标志,0:不走,1:开始走
	        recordIdLong = model.getId();// 取得开始走流程的那个进度记录的id
	        log.info("recordIdLong:" + recordIdLong);
        }
        List<TransferItemVo> list = getDataTransferFlow();// 取得迁移的顺序流程
        for (int i = 0; i < list.size(); i++) {
            TransferItemVo transferItemVo = list.get(i);
            if (!isAllTableFlg) {
            	if (tableName.equals(transferItemVo.getOrgTableName())) {
                    isBeginRunFlag = "1";
                }
                if ("0".equals(isBeginRunFlag)) {
                    continue;
                }
            }
            // 计算出迁移的日期
            Date date = DateHelper.addDay(new Date(), transferItemVo.getTransferDays()); // 迁移的天数
            String transferDate = DateHelper.date2string(date, DateHelper.YYYY_MM_DD);
            log.info("transferDate:" + transferDate);
            Date beginDate = new Date();
            long id;
            if (!isAllTableFlg&&tableName.equals(transferItemVo.getOrgTableName())) {
                dataTransferFlowDao.updateTblTransferRecord2(recordIdLong, beginDate, "1"); // 更新进度记录
                id = recordIdLong;
            } else {
                id = dataTransferFlowDao.insertTblTransferRecord(transferItemVo.getOrgTableName(), transferItemVo
                        .getTargetTableName(), beginDate, "1"); // 插入一条迁移进度记录，isException是否异常，0:正常，1:异常
            }
            try {
                dataTransferItemManager.dealOneTable(transferItemVo.getIdName(), transferItemVo.getDateName(),
                        transferItemVo.getOrgTableName(), transferDate, transferRowsInt, transferItemVo.getTargetTableName(),id);// 迁移表
            } catch (Exception e) {
                log.error("迁移表异常{}", Throwables.getStackTraceAsString(e));
                dataTransferItemManager.updateTblTransferRecord(id,"1");
                throw new BatchException(e);
            }
        }
    }

    @Transactional
    @Deprecated
    public void dealOneTableByName(String tableName) throws BatchException {
        log.info("into dealOneTableByName");
        List<TransferItemVo> list = getDataTransferFlow();// 取得迁移的顺序流程
        for (int i = 0; i < list.size(); i++) {
            TransferItemVo transferItemVo = list.get(i);
            if (tableName.equals(transferItemVo.getOrgTableName())) {
                Date date = DateHelper.addDay(new Date(), transferItemVo.getTransferDays()); // 迁移的天数
                String transferDate = DateHelper.date2string(date, DateHelper.YYYY_MM_DD);
                log.info("transferDate:" + transferDate);
                Date beginDate = new Date();
                long id = dataTransferFlowDao.insertTblTransferRecord(transferItemVo.getOrgTableName(), transferItemVo
                        .getTargetTableName(), beginDate, "1");// 插入一条迁移进度记录，ISEXCEPTION是否异常，0:正常，1:异常
                try {
                    dataTransferItemManager.dealOneTable(transferItemVo.getIdName(), transferItemVo.getDateName(), transferItemVo.getOrgTableName(),
                            transferDate, transferRowsInt, transferItemVo.getTargetTableName(),id);// 迁移表
                } catch (Exception e) {
                    log.error("迁移表异常：", Throwables.getStackTraceAsString(e));
                    dataTransferItemManager.updateTblTransferRecord(id,  "1");
                    throw new BatchException(e);
                }
            }
        }
    }

    @Transactional
    @Deprecated
    public void dealAllTable() throws BatchException {
        log.info("into dealAllTable");
        //dealGroupRecord();//迁移上传的客户分群记录
        dealOrderRecord();

    }

    @Deprecated
    private void dealOrderRecord() throws BatchException {
        List<TransferItemVo> list = getDataTransferFlow();// 取得迁移的顺序流程
        for (int i = 0; i < list.size(); i++) {
            TransferItemVo transferItemVo = list.get(i);
            Date date = DateHelper.addDay(new Date(), transferItemVo.getTransferDays()); // 迁移的天数
            String transferDate = DateHelper.date2string(date, DateHelper.YYYY_MM_DD);
            log.info("transferDate:" + transferDate);
            Date beginDate = new Date();
            long id = dataTransferFlowDao.insertTblTransferRecord(transferItemVo.getOrgTableName(), transferItemVo
                    .getTargetTableName(), beginDate, "1"); // 插入一条迁移进度记录，isException是否异常，0:正常，1:异常
            try {
                dataTransferItemManager.dealOneTable(transferItemVo.getIdName(),
                        transferItemVo.getDateName(), transferItemVo
                                .getOrgTableName(), transferDate,
                        transferRowsInt, transferItemVo.getTargetTableName(),id);// 迁移表
            } catch (Exception e) {
                log.error("迁移表异常：", Throwables.getStackTraceAsString(e));
                dataTransferItemManager.updateTblTransferRecord(id,"1");
                throw new BatchException(e);
            }
        }
    }

    public List<TransferItemVo> getDataTransferFlow() {
        if (dataTransferFlow == null) {
            dataTransferFlow = Lists.newArrayList();
            dataTransferFlow.add(new TransferItemVo("tbl_order_main",
                    "tblordermain_history", "ordermain_id", "create_time",
                    transferHistoryDays));// 大订单表
            dataTransferFlow.add(new TransferItemVo("tblordermain_history",
                    "tblordermain_backup", "ordermain_id", "create_time",
                    transferBackDays));// 大订单表
            dataTransferFlow.add(new TransferItemVo("tbl_order",
                    "tblorder_history", "order_id", "create_time",
                    transferHistoryDays));// 小订单表
            dataTransferFlow.add(new TransferItemVo("tblorder_history",
                    "tblorder_backup", "order_id", "create_time",
                    transferBackDays));// 小订单表
            dataTransferFlow.add(new TransferItemVo("tbl_order_dodetail",
                    "tblorderdodetail_history", "id", "do_time",
                    transferHistoryDays));// 订单历史表
            dataTransferFlow.add(new TransferItemVo("tblorderdodetail_history",
                    "tblorderdodetail_backup", "id", "do_time",
                    transferBackDays));// 订单历史表
            dataTransferFlow.add(new TransferItemVo("tbl_esp_keyword_record",
                    "tbl_esp_keyword_record_mod", "id", "create_time",
                    transferMonthDays));// 关键字记录表迁移
        }
        return dataTransferFlow;
    }

    /**
     * 迁移的顺序流程
     */
    private List<TransferItemVo> dataTransferFlow = null;

}
