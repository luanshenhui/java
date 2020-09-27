package com.hepowdhc.dcapp.api.bean;

import com.alibaba.druid.pool.DruidDataSource;
import com.alibaba.druid.wall.WallConfig;
import com.hepowdhc.dcapp.api.util.TemplateUtil;
import com.hepowdhc.dcapp.api.util.VerifySql;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;

import java.nio.file.Path;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * Created by fzxs on 16-12-13.
 */
public final class MapperBean {

    private final Logger logger = LoggerFactory.getLogger(getClass());

    private String sql;

    private boolean file;

    private DruidDataSource ds;

    private boolean debug;

    public boolean isFile() {
        return file;
    }

    public void setFile(boolean file) {
        this.file = file;
    }

    public String getSql() {

        return sql;
    }

    /**
     * 读取ftl文件的内容作为sql
     *
     * @param paramMap
     * @return
     */
    private String getSql(Path path, Map<String, Object> paramMap) {
        String sql = "";
        try {
            // String sqlContent = FileUtils.readFileToString(path.toFile(), "UTF8");

            if (debug || StringUtils.isEmpty(this.sql)) {

                sql = TemplateUtil.process(path, paramMap);

                this.sql = sql;

            }

            return this.sql;
        } catch (Exception e) {
            e.printStackTrace();
            return sql;
        }
    }

    public void setSql(String sql) {
        this.sql = sql;
    }

    public DruidDataSource getDs() {
        return ds;
    }

    public void setDs(DruidDataSource ds) {
        this.ds = ds;
    }

    public boolean isDebug() {
        return debug;
    }

    public void setDebug(boolean debug) {
        this.debug = debug;
    }

    public Object execute(Path path, Map<String, Object> paramMap) {
        String sql = this.getSql();//查询语句

        if (this.isFile()) {
            // 加载sql文件中的内容
            sql = this.getSql(path, paramMap);

        }

        if (StringUtils.isEmpty(sql)) {

            return "{msg:'sql不能为空!'}";

        }
        final DruidDataSource dataSourceBean = this.getDs();//数据源

        //加载数据库配置
        if (dataSourceBean == null) {
            return "{msg:'数据源设置错误!'}";
        }

        final VerifySql ver = new VerifySql() {

            @Override
            public void setConfig(final WallConfig config) {
                config.setCallAllow(false);
                config.setCreateTableAllow(false);
                config.setDropTableAllow(false);
                config.setAlterTableAllow(false);
                config.setRenameTableAllow(false);
                config.setLockTableAllow(false);
                config.setStartTransactionAllow(false);
                config.setDeleteAllow(false);
                config.setUpdateAllow(false);
                config.setInsertAllow(false);
                config.setMergeAllow(false);
                config.setIntersectAllow(false);
                config.setReplaceAllow(false);
                config.setCommitAllow(false);
                config.setRollbackAllow(false);
                config.setUseAllow(false);
                config.setDescribeAllow(false);
                config.setShowAllow(false);
                config.setSchemaCheck(false);
                config.setTableCheck(false);
                config.setFunctionCheck(false);
                config.setObjectCheck(false);
                config.setVariantCheck(false);

            }
        };

        logger.debug("======sql=====>" + sql);

        try {
            if (!ver.verify(sql)) {
                throw new SQLException();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "{msg:'非法的查询sql!'}";
        }

        List<Map<String, Object>> list;
        if (paramMap.size() == 0) {
            //只有 _id一个参数，说明查询没有参数
            final JdbcTemplate template = new JdbcTemplate(ds);
            list = template.queryForList(sql);
        } else {
            NamedParameterJdbcTemplate namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(ds);
            list = namedParameterJdbcTemplate.queryForList(sql, paramMap);
        }
        return list;
    }
}
