package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.SynBonusService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by txy on 2016/7/26.
 */
@Slf4j
public class SynBonusControl extends BaseControl {
    /**
     * 积分类型同步
     * @param args
     */
    public static void main(String[] args) {
        SynBonusControl synControl = new SynBonusControl();
        synControl.setBatchName("【集中调度】积分类型同步处理任务");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        SynBonusService synBonusService = SpringUtil.getBean(SynBonusService.class);
        return synBonusService.synBonusTypeByBPMSWithTxn();
    }
}
