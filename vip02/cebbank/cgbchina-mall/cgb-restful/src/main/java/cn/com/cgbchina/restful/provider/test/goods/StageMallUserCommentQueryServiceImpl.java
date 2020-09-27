package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.StageMallUserCommentQueryService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallUserCommentQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.StageMallUserCommentQuery;


@Service
public class StageMallUserCommentQueryServiceImpl implements StageMallUserCommentQueryService {
	@Override
	public StageMallUserCommentQueryReturn query(StageMallUserCommentQuery stageMallUserCommentQuery) {
		return BeanUtils.randomClass(StageMallUserCommentQueryReturn.class);
	}

}
