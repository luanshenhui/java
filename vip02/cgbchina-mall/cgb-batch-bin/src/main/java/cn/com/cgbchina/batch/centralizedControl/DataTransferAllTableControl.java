package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.DataTransferFlowService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;


/**
 */
@Slf4j
public class DataTransferAllTableControl extends BaseControl {

    /**
     * @param args
     */
    public static void main(String[] args) {
        DataTransferAllTableControl order = new DataTransferAllTableControl();
        order.setBatchName("【集中调度】处理表的迁移任务");
        order.setArgs(args);
        order.exec();
    }

    @Override
    public Response execService() throws BatchException {
        // String[] args = super.getArgs();
        DataTransferFlowService dataTransferFlowService = SpringUtil.getBean(DataTransferFlowService.class);
        return dataTransferFlowService.dealAllTable();
    }
}
