package cn.rkylin.apollo.utils;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.multipart.MultipartFile;

import cn.rkylin.apollo.common.util.PropertiesUtils;

/**
 *
 * @ClassName: FileUtil
 * @Description: TODO(文件处理工具类)
 * @author shixiaoFeng @rkylin.com.cn
 * @date 2016年6月29日 下午3:43:19
 *
 */
public class FileUtil {
	private static final Log log = LogFactory.getLog(FileUtil.class);
	private static final String remotePath = PropertiesUtils.getVal("uploadDir");

	/**
	 *
	 * @Title: saveFile @Description: TODO(保存文件) @param @param
	 *         uploadPath @param @param file @param @return 设定文件 @return boolean
	 *         返回类型 @author shixiaoFeng @rkylin.com.cn @throws
	 */
	public static boolean saveFile(String uploadPath, MultipartFile file) {
		if (file != null && (!file.isEmpty())) {
			// 转存文件
			try {
				File tempDir = new File(uploadPath);
				if (!tempDir.exists()) {
					tempDir.mkdirs();
				}
				if (!tempDir.isDirectory()) {
					return false;
				}

				String newPath = uploadPath + File.separator + file.getOriginalFilename();
				file.transferTo(new File(newPath));
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			return true;
		}
		return false;
	}

	/**
	 * 从服务上压缩文件 并上传到指定的服务器路径中
	 *
	 * @param srcfile  File[] 需要压缩的文件列表
	 * @param zipfile  String 路径+文件名+后缀
	 */
	public static void zipFiles(List<File> srcfile, String zipfile) {
		byte[] buf = new byte[1024];
		try {
			// 创建zip文件流
			ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipfile));
			for (int i = 0; i < srcfile.size(); i++) {
				File file = srcfile.get(i);
				FileInputStream in = new FileInputStream(file);
				out.putNextEntry(new ZipEntry(file.getName()));
				int len;
				while ((len = in.read(buf)) > 0) {
					out.write(buf, 0, len);
				}
				out.closeEntry();
				in.close();
			}
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 检查文件是否已存在
	 * 
	 * @param localFile
	 * @param realPath
	 * @param fileName
	 * @return
	 * @throws Exception
	 */
	public static boolean checkFileExistByName(String realPath, String fileName) throws Exception {
		File directory = new File(remotePath);
		FileUtils.forceMkdir(directory);
		File file = new File(remotePath +"/"+ fileName);
		if (file.exists()) {
			return true;
		}
		return false;
	}

	/**
	 * 文件上传
	 * 
	 * @param localFile
	 * @param realPath
	 * @param FileName
	 * @return
	 * @throws Exception
	 */
	public static String upload(File localFile, String realPath, String FileName) throws Exception {
		File directory = new File(remotePath);
		FileUtils.forceMkdir(directory);
		File file = new File(remotePath + FileName);
		FileOutputStream fo = null;
		InputStream is = null;
		try {
			if (file.exists()) {
				file.delete();
			}
			fo = FileUtils.openOutputStream(file);
			is = new FileInputStream(localFile);
			IOUtils.copy(is, fo);
			Thread.sleep(3000);
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		} finally {
			IOUtils.closeQuietly(fo);
			IOUtils.closeQuietly(is);
		}
		return realPath + FileName;
	}

	/**
	 * 上传文件流
	 * 
	 * @param stream
	 * @param realPath
	 * @param FileName
	 * @return
	 * @throws Exception
	 */
	public static String upload(InputStream stream, String realPath, String FileName) throws Exception {
		File directory = new File(remotePath + realPath);
		FileUtils.forceMkdir(directory);
		File file = new File(remotePath + realPath + FileName);
		FileOutputStream fo = null;
		try {
			if (file.exists()) {
				file.delete();
			}
			fo = FileUtils.openOutputStream(file);
			IOUtils.copy(stream, fo);
			Thread.sleep(3000);
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		} finally {
			IOUtils.closeQuietly(fo);
			IOUtils.closeQuietly(stream);
		}
		return realPath + FileName;
	}

	/**
	 * 更新文件目录转换成浏览器目录
	 * 
	 * @param path
	 * @return
	 */
	public static String replaceSeparator(String path) {
		if (StringUtils.isNotBlank(path)) {
			return path.replace("\\", "/");
		}
		return "";
	}

	/**
	 * 更新文件目录转换成浏览器目录
	 * 
	 * @param path
	 * @return
	 */
	public static String replaceToLinuxPath(String path) {
		if (StringUtils.isNotBlank(path)) {
			return path.replace("/", "\\");
		}
		return "";
	}

	/**
	 * 下载文件
	 * 
	 * @author zhangXinyuan
	 * @date 2016-7-26 下午13:25:39
	 * @param request
	 * @param response
	 * @param storeName
	 * @param contentType
	 * @param realName
	 * @throws Exception
	 */
	public static void download(HttpServletRequest request, HttpServletResponse response, String remotePathFile,
			String contentType, String realName) throws Exception {
		request.setCharacterEncoding("UTF-8");
		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
		String downLoadPath = remotePathFile;

		long fileLength = new File(downLoadPath).length();
		
		response.reset();
		response.setContentType(contentType);
		response.setHeader("Content-disposition",
				"attachment; filename=" + new String(realName.getBytes("utf-8"), "ISO8859-1"));
		response.setHeader("Content-Length", String.valueOf(fileLength));

		bis = new BufferedInputStream(new FileInputStream(downLoadPath));
		bos = new BufferedOutputStream(response.getOutputStream());
		byte[] buff = new byte[2048];
		int bytesRead;
		while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
			bos.write(buff, 0, bytesRead);
		}
		bos.flush();
		bis.close();
		bos.close();
	}
}