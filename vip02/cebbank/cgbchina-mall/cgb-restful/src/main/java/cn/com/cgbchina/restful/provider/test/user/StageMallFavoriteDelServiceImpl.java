package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.StageMallFavoriteDelService;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteDelReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteDel;


@Service
public class StageMallFavoriteDelServiceImpl implements StageMallFavoriteDelService {
	@Override
	public StageMallFavoriteDelReturn del(StageMallFavoriteDel stageMallFavoriteDel) {
		return BeanUtils.randomClass(StageMallFavoriteDelReturn.class);
	}

}
