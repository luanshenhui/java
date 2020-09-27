package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.DataTransferFlowService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;


/**
 */
@Slf4j
public class TransferTableExceptionDealControl extends BaseControl {

    /**
     * @param args
     */
    public static void main(String[] args) {
        TransferTableExceptionDealControl order = new TransferTableExceptionDealControl();
        order.setBatchName("【集中调度】迁移表异常处理任务");
        order.setArgs(args);
        order.exec();
    }

    @Override
    public Response execService() throws BatchException {
        String[] args = super.getArgs();
        String id = null;
        if (args != null && args.length > 0) {
            id = args[0];
        }
        DataTransferFlowService dataTransferFlowService = SpringUtil.getBean(DataTransferFlowService.class);
        return dataTransferFlowService.dealTableById(id);
    }
}
