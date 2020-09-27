package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

import java.io.IOException;

/**
 * 计算最佳倍率
 *
 * @author tongxueying
 */
public interface DealBestRateService {

    /**
     * 最佳倍率
     * @throws IOException
     */
    Response<Boolean> executeDealBestRate();

}
