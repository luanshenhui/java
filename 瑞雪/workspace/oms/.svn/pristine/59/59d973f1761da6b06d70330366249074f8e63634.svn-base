package cn.rkylin.oms.ectrade.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.ectrade.domain.EcOrder;
import cn.rkylin.oms.ectrade.vo.EcOrderVO;

@Repository(value = "ecOrderDAO")
public class EcOrderDAOImpl implements IEcOrderDAO {
	private static final String STMT_UPDATE = "updateByOrderKeySelective";
	
    @Autowired
    protected IDataBaseFactory dao;
    
    /**
     * 构造函数
     */
    public EcOrderDAOImpl(){

    }

	@Override
	public List<EcOrderVO> findByWhere(EcOrderVO ecorderVO) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	
	/**
	 * 订单
	 * 
	 * @param shop
	 */
	public int update(EcOrder ecOrder) throws Exception {
		return dao.update(STMT_UPDATE, ecOrder);
	}
}
