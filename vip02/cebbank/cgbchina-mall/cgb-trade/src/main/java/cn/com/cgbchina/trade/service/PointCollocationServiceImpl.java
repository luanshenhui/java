package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.model.PointCollocation;
import com.google.common.collect.Lists;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by yuxinxin on 16-4-14.
 */
@Service
public class PointCollocationServiceImpl implements PointCollocationService {

	static List<PointCollocation> pointCollocations = Lists.newArrayList();

	static {
		PointCollocation pointCollocation = null;
		for (int i = 0; i < 100; i++) {
			pointCollocation = new PointCollocation();
			pointCollocation.setId("10000" + i);
			pointCollocation.setGoodsName("咖啡因" + i);
			pointCollocation.setGoodsPrice("100" + i);
			pointCollocation.setGoodsNum("1" + i);
			pointCollocation.setGoodsCustomer("售后" + i);
			pointCollocation.setGoodsPay("100" + i);
			pointCollocation.setStatus("退货中" + i);
			pointCollocations.add(pointCollocation);
		}

	}

	@Override
	public Response<Pager<PointCollocation>> findAll(@Param("pageNo") Integer pageNo) {
		Response<Pager<PointCollocation>> response = new Response<Pager<PointCollocation>>();
		List<PointCollocation> pointCollo = pointCollocations;
		Pager<PointCollocation> pager = new Pager<PointCollocation>(new Long(pointCollocations.size()), pointCollo);
		response.setResult(pager);
		return response;
	}

	@Override
	public Response<Boolean> deleteAll(PointCollocation pc) {
		Response<Boolean> response = new Response<Boolean>();
		for (int i = 0; i < pointCollocations.size(); i++) {
			if (pointCollocations.get(i).getId().equals(pc.getId())) {
				break;
			}
		}
		pointCollocations.remove(pc);
		response.setResult(Boolean.TRUE);
		response.setSuccess(Boolean.TRUE);
		return response;
	}
}
