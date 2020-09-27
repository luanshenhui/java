package cn.com.cgbchina.restful.provider.test.activity;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.activity.NoticCancelService;
import cn.com.cgbchina.rest.provider.model.activity.NoticCancelReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.activity.NoticCancel;


@Service
public class NoticCancelServiceImpl implements NoticCancelService {
	@Override
	public NoticCancelReturn cancel(NoticCancel noticCancel) {
		NoticCancelReturn noticCancelReturn = BeanUtils.randomClass(NoticCancelReturn.class);
		return noticCancelReturn;
	}

}
