package cn.com.cgbchina.batch.service;

import java.util.Map;

/**
 * Created by zjq on 2016/12/26.
 */
public interface ApplyPaymentExportService {
	/**
	 * 请款文件检索生成功能
	 * */
    public void applyPaymentExport(Map<String, Object> dataMap);
    
    /**
     * 删除请款临时文件
     * */
    public Boolean deleteApplyFileExcel(String userId);

}
