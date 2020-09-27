package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dao.OrderPartBackDao;
import cn.com.cgbchina.trade.dao.OrderReturnTrackDao;
import cn.com.cgbchina.trade.dto.OrderReturnTrackDto;
import cn.com.cgbchina.trade.model.OrderPartBackModel;
import cn.com.cgbchina.trade.model.OrderReturnTrackModel;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yuxinxin on 16-4-30.
 */
@Service
@Slf4j
public class OrderReturnTrackServiceImpl implements OrderReturnTrackService {
	@Resource
	private OrderReturnTrackDao orderReturnTrackDao;
	@Resource
	private OrderPartBackDao orderPartBackDao;

	/**
	 * 根据退货单ID查询退货详情
	 *
	 * @param partbackId
	 * @return
	 */

	@Override
	public Response<OrderReturnTrackDto> findById(Long partbackId) {
		OrderReturnTrackDto orderReturnTrackDto = new OrderReturnTrackDto();
		Response<OrderReturnTrackDto> response = new Response<OrderReturnTrackDto>();
		try {
			// 通过退货单ID 查询出履历表中的对应状态和时间
			List<OrderReturnTrackModel> orderReturnTrackModelList = orderReturnTrackDao.findByPartbackId(partbackId);

			// 查询主表 根据主表中的退货状态显示
			OrderPartBackModel orderPartBackModel = orderPartBackDao.findById(partbackId);

			orderReturnTrackDto.setOrderReturnTrackModelList(orderReturnTrackModelList);
			BeanMapper.copy(orderPartBackModel, orderReturnTrackDto);
			response.setResult(orderReturnTrackDto);
			return response;

		} catch (Exception e) {
			log.error("return track query error", Throwables.getStackTraceAsString(e));
			response.setError("return.track.query.error");
			return response;
		}

	}

}
