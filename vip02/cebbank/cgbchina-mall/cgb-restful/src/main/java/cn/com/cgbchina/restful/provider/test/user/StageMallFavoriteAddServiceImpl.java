package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.StageMallFavoriteAddService;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteAddReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteAdd;


@Service
public class StageMallFavoriteAddServiceImpl implements StageMallFavoriteAddService {
	@Override
	public StageMallFavoriteAddReturn add(StageMallFavoriteAdd stageMallFavoriteAdd) {
		return BeanUtils.randomClass(StageMallFavoriteAddReturn.class);
	}

}
