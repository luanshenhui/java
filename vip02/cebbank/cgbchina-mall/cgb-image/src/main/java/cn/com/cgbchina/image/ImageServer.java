package cn.com.cgbchina.image;

import cn.com.cgbchina.image.exception.ImageDeleteException;
import cn.com.cgbchina.image.exception.ImageUploadException;
import org.springframework.web.multipart.MultipartFile;

/**
 * Created by 11140721050130 on 16-3-22.
 */
public interface ImageServer {

	/**
	 *
	 * @param fileName 文件名
	 * @param file 文件
	 * @return 文件上传后的相对路径
	 */
	String write(String fileName, MultipartFile file) throws ImageUploadException;

	/**
	 * 处理原始文件名, 并返回新的文件名
	 * 
	 * @param originalName 原始文件名
	 * @param imageData 原始文件的字节数组
	 * @return 新的文件名
	 */
	String handleFileName(String originalName, byte[] imageData);

	/**
	 * 刪除文件
	 *
	 * @param fileName 文件名
	 * @return 是否刪除成功
	 */
	boolean delete(String fileName) throws ImageDeleteException;

	/**
	 *
	 * @param originalName 原始文件名
	 * @param file 文件
	 * @return 文件上传后的相对路径
	 */
	String upload(String originalName, MultipartFile file) throws ImageUploadException;
}
