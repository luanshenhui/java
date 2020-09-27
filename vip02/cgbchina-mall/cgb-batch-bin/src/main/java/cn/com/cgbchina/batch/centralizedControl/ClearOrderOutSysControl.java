package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.ClearOrderOutSysService;
import cn.com.cgbchina.batch.service.ClearQueryService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;


/**
 */
@Slf4j
public class ClearOrderOutSysControl extends BaseControl {

    /**
     * @param args
     */
    public static void main(String[] args) {
        ClearOrderOutSysControl order = new ClearOrderOutSysControl();
        order.setBatchName("定时清理推送表批处理任务");
        order.setArgs(args);
        order.exec();
    }

    @Override
    public Response execService() throws BatchException {
        // String[] args = super.getArgs();
        ClearOrderOutSysService clearOrderOutSysService = SpringUtil.getBean(ClearOrderOutSysService.class);
        return clearOrderOutSysService.clearWithTxn();
    }
}
