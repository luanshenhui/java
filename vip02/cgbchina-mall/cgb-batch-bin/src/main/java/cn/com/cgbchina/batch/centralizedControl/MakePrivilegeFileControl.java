package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.MakeCheckAccService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;


/**
 */
@Slf4j
public class MakePrivilegeFileControl extends BaseControl {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		MakePrivilegeFileControl order = new MakePrivilegeFileControl();
		order.setBatchName("【集中调度】优惠券对账文件批处理任务");
		order.setArgs(args);
		order.exec();
	}
	@Override
	public Response execService() throws BatchException {
		MakeCheckAccService makeCheckAccService = SpringUtil.getBean(MakeCheckAccService.class);
		return makeCheckAccService.makePrivilegeFileWithTxn();
	}
}
