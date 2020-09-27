package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.ClearQueryService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;


/**
 */
@Slf4j
public class ClearQueryControl extends BaseControl {

    /**
     * @param args
     */
    public static void main(String[] args) {
        ClearQueryControl order = new ClearQueryControl();
        order.setBatchName("【集中调度】分期业务请款批处理任务");
        order.setArgs(args);
        order.exec();
    }

    @Override
    public Response execService() throws BatchException {
        // String[] args = super.getArgs();
        ClearQueryService clearQueryService = SpringUtil.getBean(ClearQueryService.class);
        return clearQueryService.clearQuery();
    }
}
