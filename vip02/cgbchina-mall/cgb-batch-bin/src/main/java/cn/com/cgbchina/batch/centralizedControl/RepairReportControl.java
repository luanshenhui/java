package cn.com.cgbchina.batch.centralizedControl;

import lombok.extern.slf4j.Slf4j;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.MakeCheckAccRenewService;
import cn.com.cgbchina.batch.service.MakeCheckAccService;
import cn.com.cgbchina.batch.service.RepairReportService;
import cn.com.cgbchina.batch.util.SpringUtil;

import com.spirit.common.model.Response;

@Slf4j
public class RepairReportControl extends BaseControl {
    /**
     * 报表补跑批量任务
     * @param args
     */
    public static void main(String[] args) {
    	RepairReportControl synControl = new RepairReportControl();
        synControl.setBatchName("[集中调度]报表补跑批量任务");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response<?> execService() throws BatchException {
    	RepairReportService repairReportService = SpringUtil.getBean(RepairReportService.class);
		return repairReportService.repairRunBatchReport();
    }
}
