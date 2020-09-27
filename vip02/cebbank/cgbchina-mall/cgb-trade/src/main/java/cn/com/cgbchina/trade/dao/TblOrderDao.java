package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.OrderSubModel;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.Map;

/**
 * Created by 张成 on 16-6-27.
 */
@Repository
public class TblOrderDao extends SqlSessionDaoSupport {

    public OrderSubModel getTblOrder(Map<String, Object> paramMap) {
        return getSqlSession().selectOne("OrderSub.findById", paramMap);
    }

}
