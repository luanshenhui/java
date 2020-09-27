/*
 * 
 * Copyright 2016 by www.cgbchina.com.cn All rights reserved.
 * 
 */
package cn.com.cgbchina.common.utils;

import java.io.*;
import java.util.Dictionary;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import org.apache.commons.lang3.StringUtils;

/**
 * 日期 : 2016年6月22日<br>
 * 作者 : liuyc<br>
 * 项目 : cgb-common<br>
 * 功能 : zip文件压缩/解压缩用工具类<br>
 */
public class ZipUtil {

	private static final int bufferSize = 2048;

	/**
	 * Description : 解压缩指定的Zip文件到指定目录下
	 * 
	 * @param destPath 解压缩目标目录
	 * @param zipFilePath 压缩文件路径
	 * @param dict 文件扩展名字典,为null则不检查文件扩展名；不为null时，如存在key以外的文件扩展名，抛出异常
	 * @throws Exception
	 */
	public static void unzip(String destPath, String zipFilePath, Dictionary<String, Boolean> dict) throws Exception {
		FileInputStream fis = null;
		try {
			fis = new FileInputStream(zipFilePath);

			unzip(destPath, fis, dict);

		} catch (Exception e) {
			throw e;
		} finally {
			if (fis != null) {
				fis.close();
			}
		}
	}

	/**
	 * Description :解压缩数据流中的数据到指定目录下
	 * 
	 * @param destPath 解压缩目标目录
	 * @param in 数据流
	 * @param dict 文件扩展名字典,为null则不检查文件扩展名；不为null时，如存在key以外的文件扩展名，抛出异常
	 * @throws Exception
	 */
	public static void unzip(String destPath, InputStream in, Dictionary<String, Boolean> dict) throws Exception {

		ZipInputStream zis = null;
		BufferedOutputStream dest = null;
		FileOutputStream fos = null;
		try {
			zis = new ZipInputStream(new BufferedInputStream(in));
			ZipEntry entry;

			String fileName;
			String extractPath;
			int count;
			while ((entry = zis.getNextEntry()) != null) {
				byte data[] = new byte[bufferSize];
				String newEntryName = entry.getName();

				fileName = destPath + File.separator + newEntryName;
				int pos = getSeparatorCharPos(fileName);
				if (pos >= 0) {
					extractPath = fileName.substring(0, pos);
					if (!destPath.equals(extractPath)) {
						mkDirs(extractPath);
					}
				}

				// write the files to the disk
				if (entry.isDirectory()) {
					// 包含子目录

				} else {
					String extension = getExtension(fileName);
					if (dict != null && dict.get(extension) == null) {
						throw new Exception("文件扩展名错误,extension=" + extension);
					}
					fos = new FileOutputStream(fileName);
					dest = new BufferedOutputStream(fos, bufferSize);
					while ((count = zis.read(data, 0, bufferSize)) != -1) {
						dest.write(data, 0, count);
					}
					dest.flush();
					fos.flush();
				}
			}

		} catch (Exception e) {
			throw e;
		} finally {
			if (dest != null) {
				dest.close();
			}

			if (fos != null) {
				fos.close();
			}

			if (zis != null) {
				zis.close();
			}
		}
	}

	/**
	 * Description : 获取文件扩展名
	 * 
	 * @param fileName 文件名称
	 * @return 文件扩展名
	 */
	private static String getExtension(String fileName) {

		return (fileName.lastIndexOf(".") >= 0) ? fileName.substring(fileName.lastIndexOf(".") + 1) : "";
	}

	/**
	 * Description : 压缩列表中文件
	 * 
	 * @param fileNameList 文件列表
	 * @param destPath 保存压缩文件用目录
	 * @param zipFileName 压缩文件名
	 * @throws Exception
	 */
	public static void zip(List<String> fileNameList, String destPath, String zipFileName) throws Exception {

		// 数据缓存
		byte[] buf = new byte[bufferSize];
		FileInputStream in = null;
		ZipOutputStream out = null;
		try {
			// 创建压缩文件
			out = new ZipOutputStream(new FileOutputStream(destPath + File.separatorChar + zipFileName));

			// 执行压缩处理
			String filePath = null;
			String fileName = null;
			for (int i = 0; i < fileNameList.size(); i++) {

				filePath = (String) fileNameList.get(i);
				fileName = (String) filePath.substring(getSeparatorCharPos(filePath) + 1);

				in = new FileInputStream(filePath);

				// 添加压缩对象
				out.putNextEntry(new ZipEntry(fileName));

				// 写入数据
				int len;
				while ((len = in.read(buf)) > 0) {
					out.write(buf, 0, len);
				}

				// 关闭压缩对象
				out.closeEntry();
			}

		} catch (Exception e) {
			throw e;
		} finally {
			if (in != null) {
				in.close();
			}

			if (out != null) {
				out.close();
			}
		}
	}

	/**
	 * 创建目录，包括子目录
	 * 
	 * @param dir
	 * @throws Exception
	 */
	private static void mkDirs(String dir) throws Exception {
		if (StringUtils.isEmpty(dir)) {
			return;
		}

		File f1 = new File(dir);
		if (!f1.exists()) {
			f1.mkdirs();
		}
	}

	/**
	 * Description : 取得路径分隔符（可能是 \ 或者 /）所在的位置
	 * 
	 * @param path 路径
	 * @return 分拣系统分隔符所在的位置（如果不存在路径分隔符，返回-1）
	 */
	private static int getSeparatorCharPos(String path) {
//		int pos = path.lastIndexOf("\\");
//		if (pos >= 0) {
//			return pos;
//		}

		int pos = path.lastIndexOf("/");
		if (pos >= 0) {
			return pos;
		}

		return pos;
	}

	/**
	 * 压缩多个文件
	 * @param destPath 导出结果的文件路径
	 * @param srcPaths 被压缩的文件,可以为多个
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
	 * @param destPath 导出结果的文件路径
	 * @param srcPaths 被压缩的文件,可以为多个
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
