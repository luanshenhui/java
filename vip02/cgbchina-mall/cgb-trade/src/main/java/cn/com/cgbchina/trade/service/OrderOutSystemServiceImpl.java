package cn.com.cgbchina.trade.service;

import javax.annotation.Resource;

import cn.com.cgbchina.trade.manager.OrderCheckManager;
import cn.com.cgbchina.trade.manager.OrderMainManager;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;

import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;

import cn.com.cgbchina.trade.dao.OrderOutSystemDao;
import cn.com.cgbchina.trade.model.OrderOutSystemModel;
import lombok.extern.slf4j.Slf4j;

/**
 *
 */
@Service
@Slf4j
public class OrderOutSystemServiceImpl implements OrderOutSystemService {

	@Resource
	private OrderOutSystemDao orderOutSystemDao;
	@Resource
	private OrderCheckManager orderCheckManager;
	@Resource
	private OrderMainManager orderMainManager;

	@Override
	public Response<OrderOutSystemModel> findHanleTuiSongMsg(String subOrderNo) {
		Response<OrderOutSystemModel> response = new Response<OrderOutSystemModel>();
		try {
			OrderOutSystemModel orderOutSystemModel = orderOutSystemDao.findHanleTuiSongMsg(subOrderNo);
			response.setResult(orderOutSystemModel);
			return response;
		} catch (Exception e) {
			log.error("OrderOutSystemServiceImpl findHanleTuiSongMsg query error", Throwables.getStackTraceAsString(e));
			response.setError("OrderOutSystemServiceImpl.findHanleTuiSongMsg.query.error");
			return response;
		}
	}

    @Override
    public Response<Integer> updateTuiSongMsg(OrderOutSystemModel orderOutSystemModel) {
        Response<Integer> response = new Response<Integer>();
        try {
            Integer result = orderCheckManager.updateTuiSongMsg(orderOutSystemModel);
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("OrderOutSystemServiceImpl updateTuiSongMsg query error", Throwables.getStackTraceAsString(e));
            response.setError("OrderOutSystemServiceImpl.updateTuiSongMsg.query.error");
            return response;
        }
    }

	@Override
	public Response<Integer> insertOrderOutSystem(OrderOutSystemModel orderOutSystemModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer result = orderCheckManager.insert(orderOutSystemModel);
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("OrderOutSystemServiceImpl insertIrderOutSystem query error", Throwables.getStackTraceAsString(e));
			response.setError("OrderOutSystemServiceImpl.insertIrderOutSystem.query.error");
			return response;
		}
	}
	@Override
	public Response<Integer> saveWXVirtualOrders(OrderMainModel orderMain, OrderSubModel orderSubModel, OrderDoDetailModel orderDodetail,
										  boolean subFlag, Integer stock, OrderVirtualModel orderVirtualModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer result = orderMainManager.saveWXVirtualOrders(orderMain, orderSubModel, orderDodetail, subFlag, stock, orderVirtualModel);
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("OrderOutSystemServiceImpl insertIrderOutSystem query error", Throwables.getStackTraceAsString(e));
			response.setError("OrderOutSystemServiceImpl.insertIrderOutSystem.query.error");
			return response;
		}
	}
}