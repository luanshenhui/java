package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.model.UserImage;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import javax.annotation.Nullable;

public interface ImageService {

	Response<Boolean> addUserImage(UserImage userImage);

	/**
	 * 获取某个用户某分类的图片，如果不传入分类则获取所有未分类的图片
	 *
	 * @param userId 用户ID
	 * @param category 分类
	 * @param offset offset
	 * @param limit limit
	 * @return 分页查询的图片信息
	 */
	Response<Pager<UserImage>> findUserImages(String userId, @Nullable String category, Integer offset, Integer limit);

	/**
	 * 删除用户对应的上传记录
	 *
	 * @param userId 用户id
	 */
	Response<Boolean> deleteByUserId(String userId);

	/**
	 * 删除一个用户图片
	 *
	 * @param userImage 用户图片
	 */
	Response<Boolean> deleteUserImage(UserImage userImage);

	/**
	 * 通过id获取一个用户图片
	 *
	 * @param imageId 用户图片id
	 * @return 用户图片
	 */
	Response<UserImage> findUserImageById(Long imageId);
}
