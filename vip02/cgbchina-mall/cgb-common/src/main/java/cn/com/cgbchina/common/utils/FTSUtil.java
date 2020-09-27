package cn.com.cgbchina.common.utils;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import com.ml.bdbm.client.FTSRequest;
import com.ml.bdbm.client.FTSResponse;
import com.ml.bdbm.client.FTSTaskClient;
import com.ml.bdbm.client.TransferFile;

import lombok.extern.slf4j.Slf4j;

/**
 * 上传文服调用的工具类
 *
 * @author xiewl
 * @version 2016年5月25日 上午9:30:27
 */
@Slf4j
public class FTSUtil {
	private int timeout; // 默认超时
	/** fts IP */
	private String ftsIp = "";
	/** fts 端口 */
	private int ftsPort = -1;
	/** fts 超时时间，单位秒，默认60秒 */
	private int ftsTimeOut = 60;

	private String mode;

	private static FTSTaskClient client; // 传输客户端

	public FTSUtil(String ftsIp, int ftsPort, int ftsTimeOut, String mode) {
		this.ftsIp = ftsIp;
		this.ftsPort = ftsPort;
		this.ftsTimeOut = ftsTimeOut;
		this.mode = mode;
		client = new FTSTaskClient(this.ftsIp, this.ftsPort);
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
			String srcName = srcFile.substring(srcFile.lastIndexOf("/") + 1, srcFile.length());
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
		if (cn.com.cgbchina.common.utils.StringUtils.isEmpty(taskId)) {
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
		boolean ret = callTask(ftsRequest, files);

		if (!ret) {
			throw new RuntimeException("上传失败");
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

	/**
	 * fts传输文件
	 * 
	 * @param ftsTaskId fts任务编号（由文服分配）
	 * @param sourcePath 源路径
	 * @param targetPath 目标路径
	 * @param fileNameList 文件名称列表（单纯文件名称，不包含路径）
	 * @return true成功，false失败
	 * @throws Exception
	 */
	public boolean UploadFilesToFts(String ftsTaskId, String sourcePath, String targetPath, List fileNameList)
			throws Exception {
		log.info("ftsIp:" + ftsIp + ",ftsPort:" + ftsPort + ",ftsTimeOut:" + ftsTimeOut + ",sourcePath:" + sourcePath
				+ ",targetPath:" + targetPath + ",fileNameList:" + fileNameList);

		if (null == ftsIp || 0 == ftsIp.trim().length()) {
			log.info("请调用构造函数 ftsIp为空:" + ftsIp);
			return false;
		}
		if (-1 == ftsPort) {
			log.info("请调用构造函数 ftsPort为-1:" + ftsPort);
			return false;
		}
		if (null == sourcePath || 0 == sourcePath.trim().length()) {
			log.info("请调用构造函数 sourcePath:" + sourcePath);
			return false;
		}
		if (null == targetPath || 0 == targetPath.trim().length()) {
			log.info("请调用构造函数 targetPath:" + targetPath);
			return false;
		}
		if (null == fileNameList || fileNameList.isEmpty()) {
			log.info("请调用构造函数 fileNameList:" + fileNameList);
			return false;
		}
		// 创建ftsTaskClient
		FTSTaskClient client = null;
		try {
			client = new FTSTaskClient(ftsIp, ftsPort);
		} catch (Exception e) {
			log.error("创建FTSTaskClient失败:" + e.getMessage(), e);
			return false;
		}
		List ftsFileList = new ArrayList();
		for (int index = 0; index < fileNameList.size(); index++) {
			// 循环要传输的文件名
			String tempFileName = null == fileNameList.get(index) ? "" : String.valueOf(fileNameList.get(index)).trim();
			if (0 == tempFileName.length()) {
				continue;
			}
			log.info("index:" + index + ",tempFileName:" + tempFileName + ",sourcePath:" + sourcePath + ",targetPath:"
					+ targetPath);
			// 创建 传输文件对象
			TransferFile tempTransferFile = new TransferFile(tempFileName, sourcePath, tempFileName, targetPath);
			ftsFileList.add(tempTransferFile);
		}
		if (null == ftsFileList || 0 == ftsFileList.size()) {
			log.info("传输文件数量不能为0 ftsFileList:" + ftsFileList);
			return false;
		}
		TransferFile[] transferFiles = new TransferFile[ftsFileList.size()];
		for (int index = 0; index < ftsFileList.size(); index++) {
			transferFiles[index] = (TransferFile) ftsFileList.get(index);
		}
		if (null == transferFiles || 0 == transferFiles.length) {
			log.info("传输文件数量不能为0 transferFiles:" + transferFiles);
			return false;
		}
		// 创建fts requestd对象
		FTSRequest request = new FTSRequest(ftsTaskId, transferFiles);
		try {
			return callTask(request, transferFiles);
		} catch (Exception e) {
			log.error("调用ftp异常:" + e.getMessage(), e);
			return false;
		}
	}

	private boolean callTask(FTSRequest request, TransferFile[] files) throws Exception {

		if ("dev".equals(mode) || "test".equals(mode)) {
			try {
				FTSClient ftp = new FTSClient();
				ftp.setHost(this.ftsIp);
				ftp.setPort(this.ftsPort);
				ftp.setUsername("admin");
				ftp.setPassword("password");
				ftp.setBinaryTransfer(true);
				ftp.setPassiveMode(false);
				ftp.setEncoding("utf-8");

				for (TransferFile transferFile : files) {
					ftp.mkdir(transferFile.getDestPath(), transferFile.getDestPath(), false);
					ftp.put(transferFile.getDestPath() + transferFile.getDestName(),
							transferFile.getSrcPath() + transferFile.getSrcName(), false);
				}
				return true;
			} catch (Exception e) {
				log.error("调用ftp异常:" + e.getMessage(), e);
				return false;
			}
		} else {
			FTSResponse res = null;
			try {
				res = client.callTask(request, ftsTimeOut);
			} catch (Exception e) {
				log.error("调用ftp异常:" + e.getMessage(), e);
				return false;
			}
			log.info("fts返回res:" + res);
			if (null != res) {
				// fts 返回0000 代表成功
				if (FTSResponse.SUCCESS
						.equals(cn.com.cgbchina.common.utils.StringUtils.trimAllWhitespace(res.getErrorCode()))) {
					return true;
				} else {
					log.info("调用fts失败 errorCode:" + res.getErrorCode() + ",errorMsg:" + res.getErrorMessage());
					return false;
				}
			} else {
				log.info("调用fts返回空");
				return false;
			}
		}
	}
}
