package cn.rkylin.oms.ectrade.service;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageInfo;

import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.ectrade.dao.IEcOrderDAO;
import cn.rkylin.oms.ectrade.domain.EcOrder;
import cn.rkylin.oms.ectrade.vo.EcOrderVO;

@Service("ecOrderService")
public class EcOrderServiceImpl extends ApolloService implements IEcOrderService {
	/**
     * 订单数据访问
     */
    @Autowired
    private IEcOrderDAO ecOrderDAO;

    public IEcOrderDAO getEcOrderDAO() {
		return ecOrderDAO;
	}

	public void setEcOrderDAO(IEcOrderDAO ecOrderDAO) {
		this.ecOrderDAO = ecOrderDAO;
	}

	/**
     * 构造函数
     */
    public EcOrderServiceImpl() {
    }

    public PageInfo<EcOrderVO> findByWhere(int page, int rows, EcOrderVO ecorVO) throws Exception {
        PageInfo<EcOrderVO> ecoVOList = findPage(page, rows, "pageSelectEcOrder", ecorVO);
        return ecoVOList;
    }
    
    /**
	 * 修改店铺
	 * 
	 * @param shopVO
	 */
	public int update(EcOrderVO ecOrderVO) throws Exception{
		EcOrder ecOrder = new EcOrder();
		BeanUtils.copyProperties(ecOrderVO, ecOrder);
		return ecOrderDAO.update(ecOrder);
	}
	
}
