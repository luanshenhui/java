package cn.rkylin.oms.ectrade.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.ectrade.vo.EcTradeVO;

/**
 * 订单数据访问层
 * @author zhangheng
 * @version 1.0
 * @created 13-2月-2017 09:11:13
 */
@Repository(value = "ecTradeDAO")
public class EcTradeDAOImpl implements IEcTradeDAO {

    @Autowired
    protected IDataBaseFactory dao;

    /**
     * 构造函数
     */
    public EcTradeDAOImpl(){

    }

    /**
     * 查询店铺
     *
     * @param ecTradeVO
     */
    public List<EcTradeVO> findByWhere(EcTradeVO ecTradeVO){
        return null;
    }
    
    /**
	 * 获取分单明细
	 * 
	 * @param shopVO
	 */
	public EcTradeVO findById(String ecTradeId) throws Exception {
		List<EcTradeVO> resultList = dao.findList("selectByPrimaryKeyEcTrade", ecTradeId);
		if (resultList != null && resultList.size() > 0) {
			return resultList.get(0);
		}
		return null;
	}

}
