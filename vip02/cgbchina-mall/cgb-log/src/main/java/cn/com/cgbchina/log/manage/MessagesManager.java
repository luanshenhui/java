package cn.com.cgbchina.log.manage;

import cn.com.cgbchina.log.dao.MessageLogDao;
import cn.com.cgbchina.log.model.MessageLogModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by lvzd on 2016/12/6.
 */
@Component
public class MessagesManager {

    @Resource
    MessageLogDao messageLogDao;
    @Transactional
    public int insert(MessageLogModel messageLogModel) {
        return messageLogDao.insert(messageLogModel);
    }
}
