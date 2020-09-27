package cn.com.cgbchina.restful.provider.test.goods;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.goods.IVRRankListService;
import cn.com.cgbchina.rest.provider.model.goods.IVRRankListReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.IVRRankListQuery;


@Service
public class IVRRankListServiceImpl implements IVRRankListService {
	@Override
	public IVRRankListReturn getRankList(IVRRankListQuery iVRRankListQuery) {
		IVRRankListReturn res= BeanUtils.randomClass(IVRRankListReturn.class);
		res.setChannelSN("CC");
		res.setSuccessCode("01");
		res.setReturnCode("000000");
		res.setReturnDes("正常");
		res.setLoopCount("2");
		res.setLoopTag("0000");
		return res;
	}

}
