package cn.rkylin.oms.ectrade.service;

import com.github.pagehelper.PageInfo;

import cn.rkylin.oms.ectrade.vo.EcOrderVO;
import cn.rkylin.oms.system.shop.vo.ShopVO;

public interface IEcOrderService {
	/**
     * 查询店铺
     *
     * @param ecTradeVO
     * @throws Exception
     */
    public PageInfo<EcOrderVO> findByWhere(int page, int rows, EcOrderVO ecTradeVO) throws Exception;
    
    /**
	 * 修改店铺
	 * 
	 * @param shopVO
	 */
	public int update(EcOrderVO ecOrderVO) throws Exception;
}
