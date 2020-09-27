package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.DataTransferFlowService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;


/**
 */
@Slf4j
public class DataTransferCheckControl extends BaseControl {

    /**
     * @param args
     */
    public static void main(String[] args) {
        DataTransferCheckControl order = new DataTransferCheckControl();
        order.setBatchName("迁移表检查任务");
        order.setArgs(args);
        order.exec();
    }

    @Override
    public Response execService() throws BatchException {
        DataTransferFlowService dataTransferFlowService = SpringUtil.getBean(DataTransferFlowService.class);
        return dataTransferFlowService.dealTableById();
    }
}
