package com.cebbank.ccis.cebmall.common.images;

import com.cebbank.ccis.cebmall.common.images.exception.ImageDeleteException;
import com.cebbank.ccis.cebmall.common.images.exception.ImageUploadException;
import com.google.common.io.Files;
import com.spirit.fastdfs.service.DefaultFastFileStorageClient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/16.
 */
@Service
@Slf4j
public class FastDfsImageServiceImpl implements ImageServer {

    @Autowired
    private DefaultFastFileStorageClient storageClient;

    @Override
    public boolean delete(String fileName) throws ImageDeleteException {
        storageClient.deleteFile(fileName);
        return true;
    }

    /**
     * @param originalName 文件名
     * @param file         文件
     * @return 文件上传后的相对路径
     */
    @Override
    public String upload(String originalName, MultipartFile file) throws ImageUploadException {
        try {
            return "/" + storageClient.uploadFile(null, file.getInputStream(),
                    file.getSize(), Files.getFileExtension(originalName)).getFullPath();
        } catch (Exception e) {
            log.error("upload to fastdfs file server failed, exception:", e);
            throw new ImageUploadException(e);
        }
    }
}
