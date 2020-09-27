package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.vo.GateWayEnvolopeVo;
import cn.com.cgbchina.trade.vo.NoAs400EnvolopeVo;

/**
 * Created by sf on 16-8-1.
 */
public interface ResendCodeForO2OService {


    public NoAs400EnvolopeVo service(GateWayEnvolopeVo gateWayEnvolopeVo);

}
