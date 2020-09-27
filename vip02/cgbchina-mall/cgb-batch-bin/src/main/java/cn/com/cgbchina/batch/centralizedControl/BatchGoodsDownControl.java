package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.BatchGoodsDownService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;


/**
 */
@Slf4j
public class BatchGoodsDownControl extends BaseControl {

	/**
	 * 积分礼品自动下架
	 * @param args
	 */
	public static void main(String[] args) {
		BatchGoodsDownControl order = new BatchGoodsDownControl();
		order.setBatchName("【集中调度】积分礼品自动下架批处理");
		order.setArgs(args);
		order.exec();
	}
	@Override
	public Response execService() throws BatchException {
		BatchGoodsDownService batchGoodsDownService = SpringUtil.getBean(BatchGoodsDownService.class);
		return batchGoodsDownService.goodsDown();
	}
}
