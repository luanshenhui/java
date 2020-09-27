package cn.com.cgbchina.common.utils;

import java.util.Random;

import org.springframework.util.StringUtils;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

import com.ml.bdbm.client.FTSRequest;
import com.ml.bdbm.client.FTSResponse;
import com.ml.bdbm.client.FTSTaskClient;
import com.ml.bdbm.client.TransferFile;

/**
 * 上传文服调用的工具类
 * 
 * @author xiewl
 * @version 2016年5月25日 上午9:30:27
 */
@Slf4j

public class FTSUtil {
	@Getter
	@Setter
	private String host; // 文服地址
	@Getter
	@Setter
	private int port; // 文服端口
	@Getter
	@Setter
	private int timeout; // 默认超时

	private static FTSTaskClient client; // 传输客户端

	public FTSUtil(String host, int port, int timeout) {
		this.host = host;
		this.port = port;
		this.timeout = timeout;
		client = new FTSTaskClient(this.host, this.port);
	}

	private volatile static FTSUtil instance = null;

	public static FTSUtil getInstance(String host, int port, int timeout) {
		// 先检查实例是否存在，如果不存在才进入下面的同步块
		if (instance == null) {
			// 同步块，线程安全的创建实例
			synchronized (FTSUtil.class) {
				// 再次检查实例是否存在，如果不存在才真正的创建实例
				if (instance == null) {
					instance = new FTSUtil(host, port, timeout);
				}
			}
		}
		return instance;
	}

	/**
	 * 上传文件到文件服务器
	 * 
	 * @param srcFile
	 * @param destName
	 * @param destPath
	 * @param taskId
	 * @throws Exception
	 */
	public void send(String srcFile, String destName, String destPath, String taskId) throws Exception {
		if (srcFile.lastIndexOf("/") != -1) {
			String srcName = srcFile.substring(srcFile.lastIndexOf("/"), srcFile.length() - 1);
			String srcPath = srcFile.substring(0, srcFile.lastIndexOf("/"));
			send(srcName, srcPath, destName, destPath, taskId);
		} else {
			log.error("文件路径不正确");
			throw new Exception("文件路径不正确");
		}

	}

	/**
	 * 上传文件到文件服务器
	 * 
	 * @param srcName
	 * @param srcPath
	 * @param destName
	 * @param destPath
	 * @param taskId
	 * @throws Exception
	 */
	public void send(String srcName, String srcPath, String destName, String destPath, String taskId) throws Exception {
		TransferFile[] transferFile = { new TransferFile(srcName, srcPath, destName, destPath) };
		if (StringUtils.isEmpty(taskId)) {
			taskId = produceTaskId();
		}
		send(transferFile, taskId);
	}

	/**
	 * 上传文件到文件服务器
	 * 
	 * @param files
	 * @param taskId
	 * @throws Exception
	 */
	public void send(TransferFile[] files, String taskId) throws Exception {
		FTSRequest ftsRequest = new FTSRequest(taskId, files);
		FTSResponse ftsResponse = client.callTask(ftsRequest, timeout);

		if (!ftsResponse.getErrorCode().equals(FTSResponse.SUCCESS)) {
			String error = "【文件上传失败】 " + ftsResponse.getMessageId() + " " + ftsResponse.getErrorCode() + "\n"
					+ ftsResponse.getErrorMessage();
			log.error(error);
			throw new RuntimeException("上传失败\n" + error);
		}
	}

	/**
	 * 随机生成八位随机数
	 * 
	 * @return 字符串
	 */
	private static String produceTaskId() {
		Random rm = new Random();
		// 获得随机数
		double pross = (1 + rm.nextDouble()) * Math.pow(10, 8);
		// 将获得的获得随机数转化为字符串
		String fixLenthString = String.valueOf(pross);
		// 返回固定的长度的随机数
		return fixLenthString.substring(1, 9);
	}

}
