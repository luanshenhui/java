package cn.com.cgbchina.restful.provider.test.activity;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.activity.AreaQueryReturn;
import cn.com.cgbchina.rest.provider.model.activity.NoticAdd;
import cn.com.cgbchina.rest.provider.model.activity.NoticAddReturn;
import cn.com.cgbchina.rest.provider.service.activity.NoticAddService;
@Service
public class NoticAddServiceImpl implements NoticAddService {
	@Override
	public NoticAddReturn add(NoticAdd nodticAdd) {
		return BeanUtils.randomClass(NoticAddReturn.class);
	}

}
