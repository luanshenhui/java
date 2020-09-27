package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.UserImageDao;
import cn.com.cgbchina.user.model.UserImage;
import com.google.common.base.MoreObjects;
import com.google.common.base.Throwables;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by 11140721050130 on 2016/4/21.
 */
@Service
@Slf4j
public class ImageServiceImpl implements ImageService {

    @Autowired
    private UserImageDao userImageDao;

    @Override
    public Response<Boolean> addUserImage(UserImage userImage) {
        Response<Boolean> result = new Response<Boolean>();
        if (userImage.getUserId() == null) {
            log.error("userId can not be null");
            result.setError("userId.not.found");
            return result;
        }
        if (userImage.getFileName() == null) {
            log.error("image file name can not be null");
            result.setError("fileName.not.found");
            return result;
        }
        if (userImage.getFileSize() == null) {
            log.error("image file size can noe be null");
            result.setError("fileSize.not.found");
            return result;
        }
        try {
            userImageDao.create(userImage);
            result.setResult(Boolean.TRUE);
            return result;
        } catch (Exception e) {
            log.error("failed to create {},cause:{}", userImage, Throwables.getStackTraceAsString(e));
            result.setError("add.UserImage.fail");
            return result;
        }
    }

    @Override
    public Response<UserImage> findUserImageById(Long imageId) {
        Response<UserImage> result = new Response<UserImage>();
        if (imageId == null) {
            log.error("imageId can not be null");
            result.setError("imageId.not.found");
            return result;
        }
        UserImage userImage = userImageDao.findById(imageId);
        result.setResult(userImage);
        return result;
    }

    @Override
    public Response<Boolean> deleteUserImage(UserImage userImage) {
        Response<Boolean> result = new Response<Boolean>();
        if (userImage == null) {
            log.error("imageId can not be null");
            result.setError("userImage.not.found");
            return result;
        }
        try {
            userImageDao.delete(userImage.getId());
            result.setResult(Boolean.TRUE);
            return result;
        } catch (Exception e) {
            log.error("failed to delete {},cause:{}", userImage, Throwables.getStackTraceAsString(e));
            result.setError("userImage.delete.fail");
            return result;
        }
    }

    @Override
    public Response<Pager<UserImage>> findUserImages(String userId, String category, Integer offset, Integer limit) {
        Response<Pager<UserImage>> result = new Response<Pager<UserImage>>();
        if (userId == null) {
            log.error("userId can not be null");
            result.setError("userId.not.found");
            return result;
        }
        offset = MoreObjects.firstNonNull(offset, 0);
        limit = MoreObjects.firstNonNull(limit, 20);
        try {
            Pager<UserImage> userImageP = userImageDao.findByUserIdAndCategory(userId, category, offset, limit);
            result.setResult(userImageP);
            return result;
        } catch (Exception e) {
            log.error("failed to find UserImages by user_id={} limit {},{},cause:{}",
                    userId, offset, limit, Throwables.getStackTraceAsString(e));
            result.setError("userImage.not.found");
            return result;
        }
    }


    /**
     * 删除用户对应的上传记录
     *
     * @param userId 用户id
     */
    @Override
    public Response<Boolean> deleteByUserId(String userId) {
        Response<Boolean> result = new Response<Boolean>();
        if (userId == null) {
            log.error("userId can not be null");
            result.setError("userId.not.found");
            return result;
        }
        try {
            result.setResult(Boolean.TRUE);
            return result;
        } catch (Exception e) {
            log.error("failed to delete userImage of user(id={}),cause:{}", userId, Throwables.getStackTraceAsString(e));
            result.setError("image.delete.fail");
            return result;
        }
    }

}
