package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.MakeCheckAccRenewManager;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by dhc on 2016/7/26.
 */
@Service
@Slf4j
public class MakeCheckAccRenewServiceImpl implements MakeCheckAccRenewService {
    @Autowired
    private MakeCheckAccRenewManager makeCheckAccRenewManager;

    @Override
    public Response<Boolean> makeCheckAccRenewWithTxn() {
        Response<Boolean> response = new Response<>();
        try {
            log.info("自动补跑对账文件批处理开始......");
            makeCheckAccRenewManager.makeCheckAccRenewWithTxn();
            log.info("自动补跑对账文件批处理结束......");
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            log.error("自动补跑对账文件批处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }
}
