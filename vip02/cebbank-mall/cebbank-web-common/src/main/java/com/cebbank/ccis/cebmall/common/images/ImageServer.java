package com.cebbank.ccis.cebmall.common.images;

import com.cebbank.ccis.cebmall.common.images.exception.ImageDeleteException;
import com.cebbank.ccis.cebmall.common.images.exception.ImageUploadException;
import org.springframework.web.multipart.MultipartFile;

/**
 * Created by 11140721050130 on 16-3-22.
 */
public interface ImageServer {
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
