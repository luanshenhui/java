package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.MakeCheckAccCheckErrService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;


/**
 */
@Slf4j
public class MakeCheckAccCheckErrControl extends BaseControl {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		MakeCheckAccCheckErrControl order = new MakeCheckAccCheckErrControl();
		order.setBatchName("【集中调度】对账文件异常检查任务");
		order.setArgs(args);
		order.exec();
	}
	@Override
	public Response execService() throws BatchException {
		MakeCheckAccCheckErrService makeCheckAccCheckErrService = SpringUtil.getBean(MakeCheckAccCheckErrService.class);
		return makeCheckAccCheckErrService.allFunctions();
	}
}
