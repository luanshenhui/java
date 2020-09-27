package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.SendOutSystemManager;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;

@Slf4j
@Service
public class SendOutSystemServiceImpl implements SendOutSystemService {
    @Resource
    private SendOutSystemManager sendOutSystemManager;

    public Response<Boolean> sendOrders2Outsystem() {
        Response<Boolean> response = new Response<>();
        try {
            sendOutSystemManager.sendOrders2Outsystem();
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }
}
