package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.SendOutSystemService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by txy on 2016/7/26.
 */
@Slf4j
public class SendOrders2OutsystemControl extends BaseControl {
    /**
     * 计算最佳倍率
     * @param args
     */
    public static void main(String[] args) {
        SendOrders2OutsystemControl synControl = new SendOrders2OutsystemControl();
        synControl.setBatchName("O2O定时推送任务");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        SendOutSystemService sendOutSystemService = SpringUtil.getBean(SendOutSystemService.class);
        return sendOutSystemService.sendOrders2Outsystem();
    }
}
