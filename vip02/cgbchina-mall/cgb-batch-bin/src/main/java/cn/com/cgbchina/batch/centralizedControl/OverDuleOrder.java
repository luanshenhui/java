package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.BatchOrderService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;


/**
 */
@Slf4j
public class OverDuleOrder extends BaseControl {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		OverDuleOrder order = new OverDuleOrder();
		order.setBatchName("【集中调度】废单批处理");
		order.setArgs(args);
		order.exec();
	}
	@Override
	public Response execService() throws BatchException {
		BatchOrderService batchOrderService = SpringUtil.getBean(BatchOrderService.class);
		return batchOrderService.overdueOrderProc();
	}
}
