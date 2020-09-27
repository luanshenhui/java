package centling.util;

import java.io.File;
import java.util.List;

import chinsoft.core.LogPrinter;

public class BlFileUtil {
	/**
	 * 删除文件
	 * 
	 * @param filePaths
	 *            文件路径
	 * @return 操作成功：true 操作失败：false
	 */
	public static void deleteFile(List<String> filePaths) {
		for (String filePath : filePaths) {
			File file = new File(filePath);
			if (!file.exists()) {
				LogPrinter.info("待删除的文件不存在，文件路径为：" + filePath);
			} else {
				if (file.isFile()) {
					deleteFile(filePath);
				} else {
					deleteDirectory(filePath);
				}
			}
		}
	}

	/**
	 * 删除单个文件
	 * 
	 * @param filePath
	 *            待删除的文件路径
	 */
	private static void deleteFile(String filePath) {
		File file = new File(filePath);
		if (file.exists() && file.isFile()) {
			file.delete();
		}
	}

	/**
	 * 删除单个文件夹下的文件,保留该文件夹
	 * 
	 * @param filePath
	 *            待删除的文件夹
	 */
	private static void deleteDirectory(String filePath) {
		// 如果文件路径不以文件分隔符结尾，自动添加文件分隔符
		if (!filePath.endsWith(File.separator)) {
			filePath += File.separator;
		}
		
		File dirFile = new File(filePath);
		
		if (!dirFile.exists() || !dirFile.isDirectory()) {
			LogPrinter.error("删除目录失败"+filePath+"目录不存在!");
		}
		
		// 删除文件夹下的所有文件（包括子目录）
		File[] files = dirFile.listFiles();
		for (File file: files) {
			if (file.isFile()) {
				deleteFile(file.getAbsolutePath());
			} else {
				deleteDirectory(file.getAbsolutePath());
			}
		}
		
		// 删除该文件夹
//		dirFile.delete();
	}
}