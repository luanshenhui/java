package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.InitPointPoolService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by txy on 2016/7/26.
 */
@Slf4j
public class InitPointPoolControl extends BaseControl {
    /**
     * 计算最佳倍率
     * @param args
     */
    public static void main(String[] args) {
        InitPointPoolControl synControl = new InitPointPoolControl();
        synControl.setBatchName("初始化下一个月的积分池");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        InitPointPoolService initPointPoolService = SpringUtil.getBean(InitPointPoolService.class);
        return initPointPoolService.executeInitPointPool();
    }
}
