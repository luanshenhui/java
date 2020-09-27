package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.AuctionRecordModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class AuctionRecordDao extends SqlSessionDaoSupport {

    public Integer update(AuctionRecordModel auctionRecord) {
        return getSqlSession().update("AuctionRecordModel.update", auctionRecord);
    }


    public Integer insert(AuctionRecordModel auctionRecord) {
        return getSqlSession().insert("AuctionRecordModel.insert", auctionRecord);
    }


    public List<AuctionRecordModel> findAll() {
        return getSqlSession().selectList("AuctionRecordModel.findAll");
    }


    public AuctionRecordModel findById(Long id) {
        return getSqlSession().selectOne("AuctionRecordModel.findById", id);
    }

    public List<AuctionRecordModel> findByIds(List<String> ids) {
        return getSqlSession().selectList("AuctionRecordModel.findByIds", ids);
    }

    public Pager<AuctionRecordModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("AuctionRecordModel.count", params);
        if(total == 0) {
            return Pager.empty(AuctionRecordModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if(!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<AuctionRecordModel> data = getSqlSession().selectList("AuctionRecordModel.pager", paramMap);
        return new Pager<AuctionRecordModel>(total, data);
    }


    public Integer delete(AuctionRecordModel auctionRecord) {
        return getSqlSession().delete("AuctionRecordModel.delete", auctionRecord);
    }

    public List<AuctionRecordModel> findByParam(Map<String, Object> paramMap) {
        return getSqlSession().selectList("AuctionRecordModel.findByParam", paramMap);
    }

    public Integer updateByIdAndBackLock(AuctionRecordModel auctionRecord) {
        return getSqlSession().update("AuctionRecordModel.updateByIdAndBackLock", auctionRecord);
    }

    /**
     * 更新对应拍卖记录状态，标识已经释放库存
     * @param paramMap 更新参数->  orderId:订单id
     * @return 更新结果
     *
     * geshuo 20160726
     */
    public Integer updateRecordReleased(Map<String,Object> paramMap){
        return getSqlSession().update("AuctionRecordModel.updateRecordReleased", paramMap);
    }

    public Integer updateHollandOrder(AuctionRecordModel auctionRecord) {
        return getSqlSession().update("AuctionRecordModel.updateHollandOrder", auctionRecord);
    }

}