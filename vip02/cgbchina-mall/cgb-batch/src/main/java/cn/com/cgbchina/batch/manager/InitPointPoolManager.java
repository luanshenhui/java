package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.InitPointPoolDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.model.InitPointPoolModel;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.Map;

/**
 * Created by txy on 2016/7/27.
 */
@Component
@Slf4j
@Transactional
public class InitPointPoolManager {
    @Resource
    private InitPointPoolDao initPointPoolDao;
    @Transactional
    public void createNextMonthRecord(Map<String, Object> params) {
        initPointPoolDao.createNextMonthRecord(params);
    }
}
