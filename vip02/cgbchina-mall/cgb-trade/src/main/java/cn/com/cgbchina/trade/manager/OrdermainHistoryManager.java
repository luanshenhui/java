package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.trade.dao.TblOrdermainHistoryDao;
import cn.com.cgbchina.trade.model.TblOrdermainHistoryModel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 *
 * Created by zhoupeng on 2016/9/23.
 */
@Component
@Transactional
@Slf4j
public class OrdermainHistoryManager {

    @Resource
    private TblOrdermainHistoryDao tblOrdermainHistoryDao;

    /**
     * 更新
     *
     * @param tblOrdermainHistory 更新对象
     * @return Integer
     */
    public Integer update(TblOrdermainHistoryModel tblOrdermainHistory) {
        return tblOrdermainHistoryDao.update(tblOrdermainHistory);
    }
}
