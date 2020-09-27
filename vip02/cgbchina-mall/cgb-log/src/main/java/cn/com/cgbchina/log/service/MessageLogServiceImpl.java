/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.log.service;

import cn.com.cgbchina.log.manage.MessagesManager;
import cn.com.cgbchina.log.model.MessageLogModel;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


/**
 * @version 1.0
 * @created at 2016/7/29.
 */
@Service
@Slf4j
public class MessageLogServiceImpl implements MessageLogService {
    @Autowired
    private MessagesManager messagesManager;
    /**
     * 新增报文日志
     *
     * @return
     */
    @Override
    public Response<Integer> insertMessageLog(MessageLogModel messageLogModel) {
        Response<Integer> response = new Response<Integer>();
        try {
            Integer count = messagesManager.insert(messageLogModel);
            if (count > 0) {
                response.setResult(count);
                return response;
            }
        } catch (NullPointerException e) {
        	log.error(e.getMessage(),e);
            response.setError(e.getMessage());
        } catch (Exception e) {
        	log.error("insert.messageLog.error"+e.getMessage(),e);
            response.setError("insert.messageLog.error");
        }
        return response;
    }

}
