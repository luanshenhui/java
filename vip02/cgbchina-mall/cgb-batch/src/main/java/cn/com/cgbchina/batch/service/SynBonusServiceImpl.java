package cn.com.cgbchina.batch.service;
import cn.com.cgbchina.batch.dao.SynBonusDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.SynBonusManager;
import cn.com.cgbchina.batch.model.SynBonusModel;
import cn.com.cgbchina.rest.visit.model.point.PointTypeInfo;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQuery;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQueryResult;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by txy on 2016/7/21.
 */
@Service
@Slf4j
public class SynBonusServiceImpl implements SynBonusService {
    @Autowired
    private SynBonusManager synBonusManager;

    @Autowired
    private PointService pointService;
    @Resource
    private SynBonusDao synBonusDao;
    private static final Date date = new Date();

    /**
     * 积分类型同步
     */
    @Override
    public Response<Boolean> synBonusTypeByBPMSWithTxn() {
        log.info("【集中调度】积分类型同步任务开始...");
        Response<Boolean> response = new Response<>();
        try {
            synBonusTypeTxn();
            response.setResult(Boolean.TRUE);
            log.info("【集中调度】积分类型同步任务结束...");
            return response;
        } catch (BatchException e) {
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    /**
     * 积分类型同步
     *
     * @throws BatchException
     */
    private void synBonusTypeTxn() throws BatchException {
        // 传入接口所需参数
        PointTypeQuery pointTypeQuery = new PointTypeQuery();
        pointTypeQuery.setChannelID("MALL");
        int curPage = 0; // 调用接口中会把curPage+1
        // modify by cuizw for 查询分页数据有误
        int totalPage = 1;
        while (curPage < totalPage) {
            pointTypeQuery.setCurrentPage(Integer.toString(curPage));
            try {
                PointTypeQueryResult pointTypeQueryResult = pointService.queryPointType(pointTypeQuery);
                if ("00".equals(pointTypeQueryResult.getSuccessCode())) {
                    if (pointTypeQueryResult.getTotalPages() != null) {
                        totalPage = Integer.valueOf(pointTypeQueryResult.getTotalPages()).intValue();
                    } else {
                        totalPage = 0;
                    }
                    synBonusType(pointTypeQueryResult);
                } else {
                    log.error("同步第" + curPage + "页时接口处理过程发生错误");
                    throw new BatchException("同步第" + curPage + "页时接口处理过程发生错误");
                }
            } catch (Exception e) {
                throw new BatchException(e);
            }
            curPage++;
        }
    }

    private void synBonusType(PointTypeQueryResult pointTypeQueryResult) {
        List<PointTypeInfo> pointTypeInfos = pointTypeQueryResult.getPointTypeInfos();
        for (PointTypeInfo pointTypeInfo : pointTypeInfos) {
            SynBonusModel synBonusModel = synBonusDao.findById(pointTypeInfo.getJgId());
            if (synBonusModel != null) {
                Map<String, Object> params = Maps.newHashMap();
                params.put("integraltypeId", pointTypeInfo.getJgId());// 积分类型ID
                params.put("integraltypeNm", pointTypeInfo.getJgType());// 积分类型名称
                params.put("curStatus", Byte.toString(pointTypeInfo.getIsAdjective()));
                params.put("modifyOper", "积分系统");
                params.put("modifyTime", date);
                synBonusManager.update(params);
            } else {
                Map<String, Object> createParams = Maps.newHashMap();
                createParams.put("integraltypeId", pointTypeInfo.getJgId());
                createParams.put("integraltypeNm", pointTypeInfo.getJgType());
                createParams.put("curStatus", Byte.toString(pointTypeInfo.getIsAdjective()));
                createParams.put("createOper", "积分系统");
                createParams.put("createTime", date);
                createParams.put("modifyOper", "积分系统");
                createParams.put("modifyTime", date);
                synBonusManager.create(createParams);
            }
            log.info("更新积分类型:" + pointTypeInfo.getJgId() + "积分类型名称：" + pointTypeInfo.getJgType() + "状态："
                    + pointTypeInfo.getIsAdjective());
        }
    }
}
