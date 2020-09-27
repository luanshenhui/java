package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.InitPointPoolModel;
import org.springframework.stereotype.Repository;

import java.util.Map;

/**
 * Created by tongxueying on 2016/7/20.
 */
@Repository
public class InitPointPoolDao extends BaseDao {
    /**
     * 取得当月积分池中的数据
     * @return
     */
    public InitPointPoolModel findCurMonthRecord(String curMonth){
        return getSqlSession().selectOne("InitPointPool.findCurMonthRecord",curMonth);
    }

    /**
     * 取得下个月积分池中的数据
     * @return
     */
    public Integer findNextMonthRecord(String nextMonth){
        return getSqlSession().selectOne("InitPointPool.findNextMonthRecord",nextMonth);
    }

    /**
     * 将下个月数据插入积分池中
     * @param params
     * @return
     */
    public Integer createNextMonthRecord(Map<String,Object> params){
        return getSqlSession().insert("InitPointPool.createNextMonthRecord",params);
    }
}
