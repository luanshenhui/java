package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.PromDao;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/28.
 */
@Slf4j
@Component
@Transactional
public class PromBatchSubManager {

    @Resource
    private PromDao promDao;
    @Transactional
    public void updatePromStatus(Map<String, Object> updateStatus) {
        promDao.updatePromStatus(updateStatus);
    }
    @Transactional
    public Integer updateRecordReleased(Map<String, Object> updateParamMap) {
        return promDao.updateRecordReleased(updateParamMap);
    }
    @Transactional
    public Integer updateRecordReleasedByOrderId(Map<String, Object> updateParamMap) {
        return promDao.updateRecordReleasedByOrderId(updateParamMap);
    }

}
