package cn.com.cgbchina.batch.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * 压缩工具
 * @author xiewl
 * @version 2016年6月17日 下午2:26:16
 */
public class ZipUtil {

	/**
	 * 压缩多个文件
	 * @param srcPath 被压缩的文件,可以为多个
	 * @param destPath 导出结果的文件路径
	 */
	public static String zipFiles(String destPath, List<String> srcPaths) {
		if (StringUtils.isEmpty(destPath)) {
			File srcFile0 = new File(srcPaths.get(0));
			destPath = srcFile0.getParentFile().getAbsolutePath() + File.separator + srcFile0.getName() + ".zip";
		}
		if (!destPath.contains(".zip")) {
			destPath = destPath + ".zip";
		}
		File zipFile = new File(destPath);
		FileOutputStream fos = null;
		try {
			zipFile.createNewFile();
			zipFile.mkdirs();
			fos = new FileOutputStream(zipFile);
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}
		// 获取输出流
		ZipOutputStream zipOs = new ZipOutputStream(fos);
		// 循环将多个文件转为压缩文件条目
		for ( String srcPath : srcPaths ) {
			if (StringUtils.isEmpty(srcPath)) {
				throw new RuntimeException("待压缩文件路径不可为空！");
			}
			File srcFile = new File(srcPath);
			try {
				ZipEntry zipEntry = new ZipEntry(srcFile.getName());
				zipOs.putNextEntry(zipEntry);
				// 获取输入流
				FileInputStream fis = new FileInputStream(srcFile);
				int len;
				byte[] buff = new byte[1024];
				// 输入/输出流对拷
				while ((len = fis.read(buff)) != -1) {
					zipOs.write(buff, 0, len);
				}
				fis.close();
			} catch (FileNotFoundException e) {
				e.printStackTrace();
				throw new RuntimeException();
			} catch (IOException e) {
				e.printStackTrace();
				throw new RuntimeException();
			}
		}
		try {
			zipOs.flush();
			zipOs.close();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}
		return destPath;
	}

	/**
	 * 压缩多个文件 并删除源文件
	 * @param srcPath 被压缩的文件,可以为多个
	 * @param destPath 导出结果的文件路径
	 */
	public static String zipFilesWithDelSrcFiles(String destPath, List<String> srcPaths) {
		zipFiles(destPath, srcPaths);
		for ( String srcPath : srcPaths ) {
			File srcFile = new File(srcPath);
			srcFile.delete();
		}
		return destPath;
	}
}
