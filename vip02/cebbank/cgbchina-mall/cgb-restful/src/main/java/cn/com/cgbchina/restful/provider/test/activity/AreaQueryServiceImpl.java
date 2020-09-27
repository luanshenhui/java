package cn.com.cgbchina.restful.provider.test.activity;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.activity.AreaQueryService;
import cn.com.cgbchina.rest.provider.model.activity.AreaQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.activity.Area;


@Service
public class AreaQueryServiceImpl implements AreaQueryService {
	@Override
	public AreaQueryReturn query(Area area) {
		AreaQueryReturn areaQueryReturn = BeanUtils.randomClass(AreaQueryReturn.class);
		return areaQueryReturn;
	}

}
