package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.ClearQueryModel;
import cn.com.cgbchina.batch.model.GoodsModel;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by dhc on 2016/8/16.
 */
@Repository
public class BatchGoodsDownDao extends BaseDao<ClearQueryModel> {

    public List<GoodsModel> findJFGoodsDownList(){
        return getSqlSession().selectList("BatchGoodsDown.findJFGoodsDownList");
    }

    public Integer updateGoodsDown(GoodsModel goodsModel) {
        return getSqlSession().update("BatchGoodsDown.updateGoodsDown",goodsModel);
    }
}
