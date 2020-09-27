package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.DealBestRateDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.model.DealBestRateModel;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Splitter;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Created by txy on 2016/7/27.
 */
@Component
@Slf4j
@Transactional
public class DealBestRateManager {
    @Resource
    private DealBestRateDao dealBestRateDao;
    @Transactional
    public void updateStatusByRunning(DealBestRateModel dealBestRateModel) {
        dealBestRateDao.updateStatusByRunning(dealBestRateModel);
    }
    @Transactional
    public void updateItemInf(Map<String, Object> updateParams) {
        dealBestRateDao.updateItemInf(updateParams);
    }
    @Transactional
    public void createBatchStatus(Map<String, Object> runningBatchParam) {
        dealBestRateDao.createBatchStatus(runningBatchParam);
    }
}
