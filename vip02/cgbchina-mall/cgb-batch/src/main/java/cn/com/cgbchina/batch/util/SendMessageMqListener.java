package cn.com.cgbchina.batch.util;

import cn.com.cgbchina.batch.service.BatchSmspCustService;
import org.springframework.beans.factory.annotation.Autowired;

import com.google.common.base.Throwables;
import com.spirit.jms.mq.QueueMessageListener;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by DHC on 2016/12/5.
 */
@Slf4j
public class SendMessageMqListener extends QueueMessageListener<String[]> {

	@Autowired
	private BatchSmspCustService batchSmspCustService;

	private ExecutorService executorService = Executors.newCachedThreadPool();

	/**
	 * 发送 短信
	 *
	 * @param msg
	 */
	@Override
	public void onMsgListener(final String[] msg) {

		if (msg != null && msg.length > 0) {
			executorService.submit(new Runnable() {
				public void run() {
					try {
						batchSmspCustService.sendMessage(msg);
					} catch (Exception e) {
						log.error("onMsgListener,failed{}",Throwables.getStackTraceAsString(e));
					}
				}
			});

		}
	}
}
