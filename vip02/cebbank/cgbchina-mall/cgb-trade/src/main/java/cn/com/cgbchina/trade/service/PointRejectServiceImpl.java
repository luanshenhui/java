package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.model.PointReject;
import com.google.common.collect.Lists;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by yuxinxin on 16-4-15.
 */
@Service
public class PointRejectServiceImpl implements PointRejectService {

	static List<PointReject> pointRejects = Lists.newArrayList();

	static {
		PointReject pointReject = null;
		for (int i = 0; i < 2; i++) {
			pointReject = new PointReject();
			pointReject.setId("10000" + i);
			pointReject.setRejectStatus("正在退货中，请等待100年");
			pointRejects.add(pointReject);
		}
	}

	// 查询退货详情，之后会添加退货商品ID进行查询。
	@Override
	public Response<Pager<PointReject>> findRejectDetail() {
		List<PointReject> pointRejectList = pointRejects;
		Response<Pager<PointReject>> response = new Response<Pager<PointReject>>();
		Pager<PointReject> pager = new Pager<PointReject>(new Long(pointRejects.size()), pointRejectList);
		response.setResult(pager);
		return response;
	}

}
