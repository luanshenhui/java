package com.cebbank.ccis.cebmall.user.service;

import com.cebbank.ccis.cebmall.user.dao.UserImageDao;
import com.cebbank.ccis.cebmall.user.manager.ImageManager;
import com.cebbank.ccis.cebmall.user.model.UserImage;
import com.google.common.base.MoreObjects;
import com.google.common.base.Throwables;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created by 11140721050130 on 2016/4/21.
 */
@Service
@Slf4j
public class ImageServiceImpl implements ImageService {

    @Autowired
    private UserImageDao userImageDao;
    @Resource
    private ImageManager imageManager;

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
            imageManager.create(userImage);
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
            imageManager.delete(userImage.getId());
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

    @Override
    public Response<Pager<UserImage>> pager(@Param("user") User user, @Param("category") String category, @Param("pageNo") Integer pageNo, @Param("size") Integer size) {
        PageInfo pageInfo = new PageInfo(pageNo, 56);
        return findUserImages(user.getId(), category, pageInfo.getOffset(), pageInfo.getLimit());
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
