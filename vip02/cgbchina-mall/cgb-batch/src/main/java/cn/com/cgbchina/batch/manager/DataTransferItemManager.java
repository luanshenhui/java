package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.CommonDao;
import cn.com.cgbchina.batch.dao.DataTransferFlowDao;
import cn.com.cgbchina.rest.common.utils.SpringContextUtils;

import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by 11150121050003 on 2016/9/5.
 */
@Component
@Slf4j
public class DataTransferItemManager {
    @Resource
    private CommonDao commonDao;
    @Resource
    private DataTransferFlowDao dataTransferFlowDao;

    // 处理一个表的迁移
    @Transactional
    public void dealOneTable(String idName, String dateName, String orgTableName, String transferDate, Integer transferRowsInt, String targetTableName,Long id) {
        int transferSum = commonDao.getTableRowsSum(dateName, transferDate, orgTableName);// 得到需要迁移的当前表记录的行数
        log.info("transferSum:" + transferSum);
        for (int i = 0; i < transferSum; i = i + transferRowsInt) {
        	DataTransferItemManager manager=SpringContextUtils.getBean(DataTransferItemManager.class);
            List<Map<String, Object>> daoList = manager.getFirstRowsTable(idName, dateName, orgTableName, transferDate,
					transferRowsInt);// 得到需要迁移的id
            List<String> idList = Lists.newArrayList();
            if (daoList != null) {
                log.info(orgTableName + "迁移到" + targetTableName + " 第" + (i + 1) + "次迁移数量：" + daoList.size());
                idList = getIdList(daoList, idName);// 得到id的list
            }
            //迁移一个表的数据
            dealOneTableWithTxn(idName, orgTableName, targetTableName, idList);
        }
        updateTblTransferRecord(id,"0");
    }

    @Transactional(propagation=Propagation.REQUIRES_NEW,readOnly=true,isolation=Isolation.READ_UNCOMMITTED)
	public List<Map<String, Object>> getFirstRowsTable(String idName,
			String dateName, String orgTableName, String transferDate,
			Integer transferRowsInt) {
		return commonDao.getFirstRowsTable(idName, dateName, transferDate, orgTableName, transferRowsInt);
	}

    @Transactional
   	public void updateTblTransferRecord(long id, String status) {
   		Date endDate = new Date();
   		dataTransferFlowDao.updateTblTransferRecord(id, endDate, status);
   	}
    /**
     * 迁移一个表的数据
     *
     * @param idName
     * @param orgTableName
     * @param targetTableName
     * @param idList
     */
    @Transactional
    private void dealOneTableWithTxn(String idName, String orgTableName, String targetTableName, List<String> idList) {
        if ("order_id".equals(idName)){ // 小订单相关表
            commonDao.insertOrderTable(orgTableName, targetTableName, idName, idList);
        }else if ("ordermain_id".equals(idName)){ // 大订单相关表
            commonDao.insertOrderMainTable(orgTableName, targetTableName, idName, idList);
        }else if ("tbl_order_dodetail".equals(orgTableName) || "tblorderdodetail_history".equals(orgTableName)){
            commonDao.insertOrderDoDetailTable(orgTableName, targetTableName, idName, idList);
        }else if ("tbl_esp_keyword_record".equals(orgTableName)){ // 关键字表
            commonDao.insertKeyWordTable(orgTableName, targetTableName, idName, idList);
        }else{
            return;
        }
        commonDao.deleteTable(orgTableName, idName, idList);
    }

    /**
     * 得到id的List
     *
     * @param daoList
     * @param idName
     * @return
     */
    private List<String> getIdList(List<Map<String, Object>> daoList, String idName) {
        List<String> list = Lists.newArrayList();
        for (Map<String, Object> map : daoList) {
            if (map != null) {
                list.add(String.valueOf(map.get(idName)));
            }
        }
        return list;
    }
}
