package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.exception.BatchException;
import com.spirit.common.model.Response;

/**
 * Created by CuiZhengwei on 2016/7/15.
 */
public interface ClearQueryService {
    Response<Boolean> clearQuery();
}
