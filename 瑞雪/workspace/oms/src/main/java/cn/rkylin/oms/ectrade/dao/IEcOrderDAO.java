package cn.rkylin.oms.ectrade.dao;

import java.util.List;

import cn.rkylin.oms.ectrade.domain.EcOrder;
import cn.rkylin.oms.ectrade.vo.EcOrderVO;

public interface IEcOrderDAO {
	/**
     * 查询订单
     *
     * @param ectradeVO
     */
    public List<EcOrderVO> findByWhere(EcOrderVO ecOrderVO) throws Exception;
    
    /**
	 * 订单
	 * 
	 * @param shop
	 */
	public int update(EcOrder ecOrder) throws Exception;
}
