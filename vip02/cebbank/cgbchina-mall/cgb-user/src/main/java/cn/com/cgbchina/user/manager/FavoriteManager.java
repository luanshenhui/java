package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.MemberGoodsFavoriteDao;
import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by 11140721050130 on 2016/5/8.
 */
@Component
@Transactional
public class FavoriteManager {

	@Resource
	private MemberGoodsFavoriteDao memberGoodsFavoriteDao;

	public Boolean update(MemberGoodsFavoriteModel memberGoodsFavorite) {
		return memberGoodsFavoriteDao.update(memberGoodsFavorite) == 1;
	}

}
