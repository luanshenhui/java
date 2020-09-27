package cn.com.cgbchina.batch.service;
import cn.com.cgbchina.batch.dao.InitPointPoolDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.InitPointPoolManager;
import cn.com.cgbchina.batch.model.InitPointPoolModel;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.Date;
import java.util.Map;


/**
 * Created by txy on 2016/7/20.
 */
@Service
@Slf4j
public class InitPointPoolServiceImpl implements InitPointPoolService {
    @Resource
    private InitPointPoolManager initPointPoolManager;
    @Resource
    private InitPointPoolDao initPointPoolDao;
    @Value("#{app.curConfigDay}")
    private int curConfigDay;
    @Override
    public Response<Boolean> executeInitPointPool() {
        Response<Boolean> response = new Response<>();
        try {
            initPointPool();
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }


    /**
     * 初始化下一个月积分池
     *
     * @throws BatchException
     */
//    @Transactional
    public void initPointPool() throws BatchException {

        try {
            int curDay = DateTime.now().getDayOfMonth();
            if (curDay > curConfigDay) {
                //取得当前月份积分池中的数据
                InitPointPoolModel currentPointPool =
                        initPointPoolDao.findCurMonthRecord(DateTime.now().toString(DateHelper.YYYYMM));
                String nextMonth = DateTime.now().plusMonths(1).toString(DateHelper.YYYYMM);
                Integer nextPointPool = initPointPoolDao.findNextMonthRecord(nextMonth);//取得下一个月积分池中的数据
                if (nextPointPool == null || nextPointPool == 0) {
                    if (currentPointPool != null) {
                        Map<String, Object> params = Maps.newHashMap();
                        params.put("maxPoint", currentPointPool.getMaxPoint());//将当月的最大积分数放到下个月里
                        params.put("singlePoint", currentPointPool.getSinglePoint());//将当月的单位积分放到下个月里
                        params.put("pointRate", currentPointPool.getPointRate());//将当月的最高倍率放到下个月里
                        params.put("createOper", "System");//创建者为System
                        params.put("createTime", new Date());
                        params.put("curMonth", nextMonth);// 当前月份赋值下个月值
                        params.put("usedPoint", 0);//已用积分
                        initPointPoolManager.createNextMonthRecord(params);
                    }
                } else {
                    log.info("下个月已存在数据，本次不再生成");
                }
            } else {
                log.error("只会在每个月27号以后判断是否需要插入数据");
            }
        } catch (Exception e) {
            throw new BatchException(e);
        }
    }
}
