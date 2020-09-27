package cn.com.cgbchina.batch.service;


import com.spirit.common.model.Response;

/**
 * Created by DHC on 2016/12/5.
 */
public interface BatchSmspCustService {

    Response sendMessage(String[] msg) throws Exception;
}
