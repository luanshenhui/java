package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

/**
 * Created by txy on 2016/7/20.
 */
public interface InitPointPoolService {
    /**
     * 初始化下个月积分池
     */
    Response<Boolean> executeInitPointPool();
}
