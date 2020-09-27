package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.ReportModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class BatchReportRegDao extends SqlSessionDaoSupport {

    public Integer update(ReportModel report) {
        return getSqlSession().update("ReportModelBatch.update", report);
    }

    public Integer insert(ReportModel report) {
        return getSqlSession().insert("ReportModelBatch.insert", report);
    }

    public List<ReportModel> findAll() {
        return getSqlSession().selectList("ReportModelBatch.findAll");
    }

    public ReportModel findById(Integer reportId) {
        return getSqlSession().selectOne("ReportModelBatch.findById", reportId);
    }

    public Pager<ReportModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("ReportModelBatch.count", params);
        if (total == 0) {
            return Pager.empty(ReportModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<ReportModel> data = getSqlSession().selectList("ReportModelBatch.pager", paramMap);
        return new Pager<ReportModel>(total, data);
    }

    public Integer delete(ReportModel report) {
        return getSqlSession().delete("ReportModelBatch.delete", report);
    }

    public List<ReportModel> findByCodeAndDate(ReportModel reportModel) {
        return getSqlSession().selectList("ReportModelBatch.findByCodeAndDate", reportModel);
    }

    /**
     * 报表管理页面
     *
     * @param param
     * @return
     */
    public Pager<ReportModel> findReportByPage(Map<String, Object> param) {
        Long total = getSqlSession().selectOne("ReportModelBatch.pageCount", param);
        if (total == 0) {
            return Pager.empty(ReportModel.class);
        }
        List<ReportModel> data = getSqlSession().selectList("ReportModelBatch.findReportAll", param);
        return new Pager<>(total, data);
    }
}