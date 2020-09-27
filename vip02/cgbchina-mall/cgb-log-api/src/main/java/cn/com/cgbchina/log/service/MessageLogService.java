/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.log.service;

import cn.com.cgbchina.log.model.MessageLogModel;
import com.spirit.common.model.Response;

/**
 * @author
 * @version 1.0
 * @created at 2016/7/29.
 */
public interface MessageLogService {
    public Response<Integer> insertMessageLog(MessageLogModel messageLogModel);
}
