package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.GoodsRegionDao;
import cn.com.cgbchina.item.dao.ServicePromiseDao;
import cn.com.cgbchina.item.model.GoodsRegionModel;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by tongxueying on 16-6-23.
 */
@Component
@Transactional
public class GiftPartitionManager {
    @Resource
    private GoodsRegionDao goodsRegionDao;

    public boolean createPartition(GoodsRegionModel goodsRegionModel) {
        return goodsRegionDao.insert(goodsRegionModel) == 1;
    }
    public boolean update(GoodsRegionModel goodsRegionModel) {

        return goodsRegionDao.update(goodsRegionModel) == 1;
    }
    public boolean delete(GoodsRegionModel goodsRegionModel) {
        return goodsRegionDao.delete(goodsRegionModel) == 1;
    }
}
