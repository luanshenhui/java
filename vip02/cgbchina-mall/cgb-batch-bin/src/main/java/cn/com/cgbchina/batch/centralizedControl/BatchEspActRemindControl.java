package cn.com.cgbchina.batch.centralizedControl;


import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.BatchEspActRemindService;
import cn.com.cgbchina.batch.util.SpringUtil;

import com.spirit.common.model.Response;

public class BatchEspActRemindControl extends BaseControl {
	
	@Override
	protected Response execService() throws BatchException {
		BatchEspActRemindService service=SpringUtil.getBean(BatchEspActRemindService.class);
		return service.sendRemindMsg();
	}
	public static void main(String[] args) {
		BatchEspActRemindControl synControl = new BatchEspActRemindControl();
        synControl.setBatchName("【集中调度】发送App提醒短信");
        synControl.setArgs(args);
        synControl.exec();
    }
}
