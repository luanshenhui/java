package cn.com.cgbchina.batch.service;
import cn.com.cgbchina.batch.dao.IvrRankDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.IvrRankManager;
import cn.com.cgbchina.batch.model.IvrRankModel;
import cn.com.cgbchina.common.contants.Contants;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import com.spirit.common.model.Response;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;
import java.util.Map;


/**
 * Created by txy on 2016/7/22.
 */
@Service
@Slf4j
public class IvrRankServiceImpl implements IvrRankService {

    @Resource
    private IvrRankManager ivrRankManager;
    @Resource
    private IvrRankDao ivrRankDao;
    /**
     * 统计IVR渠道上架，购买数量前10的礼品排行
     * @return
     */
    @Override
    public Response<Boolean> rankListWithTxn() {
        Response<Boolean> response = new Response<>();
        try {
            ivrRankList();
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }


    /**
     * 统计IVR渠道上架，购买数量前10的礼品排行
     *
     * @return
     */
    private void ivrRankList() throws BatchException {
        try {
            List<String> pointsTypeList = ivrRankDao.findIntegraltypeList();//获取可用的积分类型
            if (!pointsTypeList.isEmpty()) {
                Map<String, Object> params = Maps.newHashMap();//把所有查询条件封成一个Map
                params.put("integraltypeId", pointsTypeList);// 积分类型ID
                List<String> paySuccessList =
                        Splitter.on(',').omitEmptyStrings().trimResults().splitToList(Contants.PAY_SUCCESS_STATUS);
                params.put("paySuccessStatus",paySuccessList);//支付成功状态
                //取得不同积分类型的单品code和单品销售数量和
                List<IvrRankModel> ivrRankModels = ivrRankDao.findItemSum(params);
                int i = 0;
                ivrRankManager.updateDelFlag(params);//更新所有积分类型下的删除标识
                for (IvrRankModel ivrRankModel : ivrRankModels) {
                    if(i > 9){
                        break;
                    }
                    String typeId = ivrRankModel.getIntegraltypeId();//积分类型ID
                    Map<String, Object> createParams = Maps.newHashMap();
                    createParams.put("goodsId", ivrRankModel.getItemCode());//单品Id
                    createParams.put("jfType", typeId);//积分类型ID
                    createParams.put("rank", i + 1);//排序
                    createParams.put("rankTime", new Date());//运行时间
                    createParams.put("saleNum", String.valueOf(ivrRankModel.getItemSum()));//单品销售数量和
                    ivrRankManager.createRank(createParams);
                    i++;
                }
            }
        } catch (Exception e) {
            log.error("ivrRankList Excpetion {}.", Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }
}
