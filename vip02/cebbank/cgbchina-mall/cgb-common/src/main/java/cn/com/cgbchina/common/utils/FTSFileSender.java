package cn.com.cgbchina.common.utils;

import com.ml.bdbm.client.FTSRequest;
import com.ml.bdbm.client.FTSResponse;
import com.ml.bdbm.client.FTSTaskClient;
import com.ml.bdbm.client.TransferFile;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/**
 * 文服上传文件工具
 * 
 * @author huangcy on 2016年5月20日
 */
@Slf4j
public class FTSFileSender {
	private String host;
	private int port;
	private String taskId;
	@Setter
	private int timeout;// 秒

	public FTSFileSender(String host, int port, String taskId) {
		this.host = host;
		this.port = port;
		this.taskId = taskId;
	}

	public FTSFileSender(String host, int port, int timeout, String taskId) {
		this.host = host;
		this.port = port;
		this.timeout = timeout;
		this.taskId = taskId;
	}

	public void send(TransferFile[] files) throws Exception {
		FTSTaskClient client = new FTSTaskClient(host, port);
		FTSRequest request = new FTSRequest(taskId, files);
		FTSResponse response = client.callTask(request, timeout);
		log.info("文服返回结果：CODE=[" + response.getErrorCode() + "],MSG=[" + response.getErrorMessage() + "]");
		if (!FTSResponse.SUCCESS.equals(response.getErrorCode())) {
			throw new Exception("上送文件时文服返回失败");
		}
	}
}
