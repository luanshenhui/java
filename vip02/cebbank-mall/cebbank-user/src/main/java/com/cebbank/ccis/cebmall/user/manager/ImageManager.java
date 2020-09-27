package com.cebbank.ccis.cebmall.user.manager;

import com.cebbank.ccis.cebmall.user.dao.UserImageDao;
import com.cebbank.ccis.cebmall.user.model.UserImage;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-14.
 */
@Component
@Transactional
public class ImageManager {
	@Resource
	private UserImageDao userImageDao;

	public void create(UserImage userImage) {
		userImageDao.create(userImage);
	}

	public void delete(Long id) {
		userImageDao.delete(id);
	}

}
