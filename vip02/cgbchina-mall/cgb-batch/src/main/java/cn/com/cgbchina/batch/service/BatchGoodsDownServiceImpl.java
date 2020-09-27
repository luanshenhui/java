package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.BatchGoodsDownDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.BatchGoodsDownManager;
import cn.com.cgbchina.batch.model.GoodsModel;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by dhc on 2016/8/16.
 */
@Service
@Slf4j
public class BatchGoodsDownServiceImpl implements BatchGoodsDownService {
    @Resource
    private BatchGoodsDownManager batchGoodsDownManager;
    @Resource
    private BatchGoodsDownDao batchGoodsDownDao;
    @Override
    public Response<Boolean> goodsDown() {
        Response<Boolean> response = new Response<>();
        try{
            log.info("积分礼品自动下架批处理开始......");
            //查询积分礼品，查询JF业务类型的商品（未删除的商品并且状态都是已上架的，并且是在当前时间之前进行下架的）
            List<GoodsModel> goodsDownList = batchGoodsDownDao.findJFGoodsDownList();
            batchGoodsDownManager.goodsDown(goodsDownList);
            log.info("积分礼品自动下架批处理结束......");
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            log.error("积分礼品自动下架批处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }
}
