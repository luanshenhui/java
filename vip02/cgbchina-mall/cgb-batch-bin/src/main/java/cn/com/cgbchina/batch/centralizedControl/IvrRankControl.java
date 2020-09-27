package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.IvrRankService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by txy on 2016/7/26.
 */
@Slf4j
public class IvrRankControl extends BaseControl {
    /**
     * 计算最佳倍率
     * @param args
     */
    public static void main(String[] args) {
        IvrRankControl synControl = new IvrRankControl();
        synControl.setBatchName("IVR排行定时任务");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        IvrRankService ivrRankService = SpringUtil.getBean(IvrRankService.class);
        return ivrRankService.rankListWithTxn();
    }
}
