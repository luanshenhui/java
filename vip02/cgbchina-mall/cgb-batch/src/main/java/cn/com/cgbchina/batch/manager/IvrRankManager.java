package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.IvrRankDao;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;

/**
 * Created by txy on 2016/7/27.
 */
@Component
@Slf4j
@Transactional
public class IvrRankManager {
    @Resource
    private IvrRankDao ivrRankDao;
    @Transactional
    public void updateDelFlag(Map<String, Object> params) {
        ivrRankDao.updateDelFlag(params);
    }
    @Transactional
    public void createRank(Map<String, Object> createParams) {
        ivrRankDao.createRank(createParams);
    }
}
