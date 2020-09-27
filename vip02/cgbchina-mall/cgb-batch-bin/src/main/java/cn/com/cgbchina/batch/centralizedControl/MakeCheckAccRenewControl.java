package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.MakeCheckAccRenewService;
import cn.com.cgbchina.batch.service.PromotionSyncService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by txy on 2016/7/26.
 */
@Slf4j
public class MakeCheckAccRenewControl extends BaseControl {
    /**
     * 计算最佳倍率
     * @param args
     */
    public static void main(String[] args) {
        MakeCheckAccRenewControl synControl = new MakeCheckAccRenewControl();
        synControl.setBatchName("自动补跑对账文件批处理");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        MakeCheckAccRenewService makeCheckAccRenewService = SpringUtil.getBean(MakeCheckAccRenewService.class);
        return makeCheckAccRenewService.makeCheckAccRenewWithTxn();
    }
}
