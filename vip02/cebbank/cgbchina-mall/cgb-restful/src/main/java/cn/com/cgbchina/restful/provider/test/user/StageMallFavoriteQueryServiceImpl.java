package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.StageMallFavoriteQueryService;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoritesReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteQuery;


@Service
public class StageMallFavoriteQueryServiceImpl implements StageMallFavoriteQueryService {
	@Override
	public StageMallFavoritesReturn query(StageMallFavoriteQuery stageMallFavoriteQuery) {
		return BeanUtils.randomClass(StageMallFavoritesReturn.class);
	}

}
