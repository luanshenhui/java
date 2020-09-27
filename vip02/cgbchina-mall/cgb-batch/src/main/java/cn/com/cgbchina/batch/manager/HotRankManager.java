package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.HotRankDao;
import cn.com.cgbchina.batch.model.CommendRankBatchModel;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;

/**
 * Created by tongxueying on 2016/8/23.
 */
@Component
@Slf4j
@Transactional
public class HotRankManager {
    @Resource
    private HotRankDao hotRankDao;
    @Transactional
    public void createRank(Map<String, Object> createYgParam) {
        hotRankDao.createRank(createYgParam);
    }
    @Transactional
    public void updateRank(Map<String, Object> paramYg) {
        hotRankDao.updateRank(paramYg);
    }
    @Transactional
    public void insertBatchRank(List<CommendRankBatchModel> rankInsertList) {
        hotRankDao.insertBatchRank(rankInsertList);
    }
    @Transactional
    public void createCountHotVendor(List<CommendRankBatchModel> rankInsertList) {
        //删除
        Map<String, Object> deleteParams = Maps.newHashMap();
        deleteParams.put("statType", "0004");//删除所有热销品类统计数据
        hotRankDao.updateRank(deleteParams);
        //批量插入排行表
        hotRankDao.insertBatchRank(rankInsertList);
    }
    @Transactional
    public void createCountVendorWeekSale(String statType, List<CommendRankBatchModel> rankInsertList) {
        Map<String,Object> deleteParams = Maps.newHashMap();
        deleteParams.put("statType",statType);//删除所有热销品类统计数据
        hotRankDao.updateRank(deleteParams);

        //批量插入排行表
        hotRankDao.insertBatchRank(rankInsertList);
    }
}

