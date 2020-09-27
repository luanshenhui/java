package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.ReportModel;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class ReportRegDao extends SqlSessionDaoSupport {

    /**
     * 报表管理页面
     *
     * @param param
     * @return
     */
    public Pager<ReportModel> findReportByPage(Map<String, Object> param) {
        Long total = getSqlSession().selectOne("ReportModel.pageCount", param);
        if (total == 0) {
            return Pager.empty(ReportModel.class);
        }
        List<ReportModel> data = getSqlSession().selectList("ReportModel.findReportAll", param);
        return new Pager<>(total, data);
    }
}