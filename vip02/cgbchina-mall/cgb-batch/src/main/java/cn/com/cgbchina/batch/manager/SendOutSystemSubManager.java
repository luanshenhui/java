package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.SendOutSystemDao;
import cn.com.cgbchina.batch.model.OrderOutSystemModel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by xiehongri on 2016/7/28.
 */
@Component
@Slf4j
@Transactional
public class SendOutSystemSubManager {
    @Resource
    private SendOutSystemDao sendOutSystemDao;
    @Transactional
    public void updateOrderOutSystem(OrderOutSystemModel orderOutSystemModel) {
        sendOutSystemDao.updateOrderOutSystem(orderOutSystemModel);
    }
}
