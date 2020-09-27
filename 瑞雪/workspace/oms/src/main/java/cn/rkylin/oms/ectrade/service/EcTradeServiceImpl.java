package cn.rkylin.oms.ectrade.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageInfo;

import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.ectrade.dao.IEcTradeDAO;
import cn.rkylin.oms.ectrade.vo.EcTradeVO;
import cn.rkylin.oms.system.shop.vo.ShopVO;

/**
 * 订单管理服务实现
 * @author zhangheng
 * @version 1.0
 * @created 13-2月-2017 09:11:15
 */
@Service("ecTradeService")
public class EcTradeServiceImpl extends ApolloService implements IEcTradeService {

    /**
     * 订单数据访问
     */
    @Autowired
    private IEcTradeDAO ecTradeDAO;
    public IEcTradeDAO getEcTradeDAO() {
        return ecTradeDAO;
    }

    public void setEcTradeDAO(IEcTradeDAO ecTradeDAO) {
        this.ecTradeDAO = ecTradeDAO;
    }

    /**
     * 构造函数
     */
    public EcTradeServiceImpl() {
    }

    public PageInfo<EcTradeVO> findByWhere(int page, int rows, EcTradeVO ecorVO) throws Exception {
        PageInfo<EcTradeVO> ecoVOList = findPage(page, rows, "pageSelectEcTrade", ecorVO);
        return ecoVOList;
    }
    
    public List<EcTradeVO> findCounts(EcTradeVO ecTradeVO) throws Exception{
    	List<EcTradeVO> list =  findPage("selectEcTradeCounts",ecTradeVO);
    	return list;
    }
    
    /**
     * 根据tid取得EcTrade
     *
     * @param ecTradeVO
     * @throws Exception
     */
    public List<EcTradeVO> findByTid(EcTradeVO ecTradeVO) throws Exception{
    	List<EcTradeVO> list =  findPage("selectEcTradeByTid",ecTradeVO);
    	return list;
    }
    
    public EcTradeVO getEcTradeById (String id) throws Exception {
    	EcTradeVO vo = ecTradeDAO.findById(id);
    	return vo;
    }
}
