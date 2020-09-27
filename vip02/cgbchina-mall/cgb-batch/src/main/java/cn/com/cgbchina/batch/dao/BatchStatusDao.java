package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.BatchStatusModel;
import cn.com.cgbchina.batch.model.SftpInfoModel;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by 11150121040023 on 2016/8/15.
 */
@Repository
public class BatchStatusDao extends BaseDao<BatchStatusModel>{
    public BatchStatusDao() {
        super("BatchStatus");
    }
    
    public List<BatchStatusModel> getFaildReport(){
    	return getSqlSession().selectList("getFaildReport","N");
    }
}
