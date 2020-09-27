package cn.com.cgbchina.batch.service;

import java.util.Map;

/**
 * Created by zhangLin on 2016/12/1.
 */
public interface OrderExportService {

    public void runOrderExport(Map<String, Object> assemMap);

    public Boolean deleteOrderExcel(String userId, String orderFileName);

}
