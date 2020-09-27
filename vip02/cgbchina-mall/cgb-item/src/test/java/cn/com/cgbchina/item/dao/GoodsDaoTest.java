package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.BaseTestCase;
import cn.com.cgbchina.item.model.GoodsModel;
import org.junit.Before;
import org.junit.Test;

import javax.annotation.Resource;

/**
 * Created by 11140721050130 on 2016/8/3.
 */
public class GoodsDaoTest extends BaseTestCase {
    @Resource
    private GoodsDao goodsDao;

    @Before
    public void init() {
        GoodsModel goodsModel = new GoodsModel();
        goodsModel.setCode("test");
    }

    @Test
    public void test() {
    }

}
