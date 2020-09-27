package cn.rkylin.oms.ectrade.service;

import java.util.List;

import com.github.pagehelper.PageInfo;

import cn.rkylin.oms.ectrade.vo.EcTradeVO;
import cn.rkylin.oms.system.shop.vo.ShopVO;

/**
 * 订单服务层接口
 * @author zhangheng
 * @version 1.0
 * @created 13-2月-2017 09:11:13
 */
public interface IEcTradeService {
    /**
     * 订单
     *
     * @param ecTradeVO
     * @throws Exception
     */
    public PageInfo<EcTradeVO> findByWhere(int page, int rows, EcTradeVO ecTradeVO) throws Exception;
    
    /**
     * 订单的各种count
     *
     * @param ecTradeVO
     * @throws Exception
     */
    public List<EcTradeVO> findCounts(EcTradeVO ecTradeVO) throws Exception;
    
    /**
     * 根据tid取得EcTrade
     *
     * @param ecTradeVO
     * @throws Exception
     */
    public List<EcTradeVO> findByTid(EcTradeVO ecTradeVO) throws Exception;
    
    /**
     * 根据ID找EcTrade
     * @param id
     * @return
     * @throws Exception
     */
    public EcTradeVO getEcTradeById (String id) throws Exception ;

}
