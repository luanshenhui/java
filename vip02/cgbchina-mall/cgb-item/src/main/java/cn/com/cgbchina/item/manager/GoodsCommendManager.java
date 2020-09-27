package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.GoodsCommendDao;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.GoodsCommendModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by txy on 2016/8/12.
 */
@Component
@Transactional
public class GoodsCommendManager {
    @Resource
    private GoodsCommendDao goodsCommendDao;

    public boolean delete(GoodsCommendModel model) {
        return goodsCommendDao.delete(model) == 1;
    }

    public boolean insert(GoodsCommendModel model) {
        return goodsCommendDao.insert(model) == 1;
    }
}
