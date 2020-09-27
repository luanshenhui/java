package com.hepowdhc.dcapp.common.model.sql.test;

import com.alibaba.druid.pool.DruidDataSource;
import com.alibaba.druid.util.JdbcUtils;
import com.alibaba.druid.wall.WallConfig;
import com.alibaba.druid.wall.WallFilter;
import com.hepowdhc.dcapp.api.util.VerifySql;
import com.thinkgem.jeesite.common.utils.FileUtils;
import org.junit.Test;

import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;

/**
 * Created by fzxs on 16-11-19.
 */
public class SqlCheckTest {


    @Test
    public void test1() {

        WallFilter filter = new WallFilter();

//        filter.setThrowException(false);

        filter.setLogViolation(true);

        String sql = "select * from user;delete   from user";

        WallConfig config = new WallConfig();

        config.setDeleteAllow(false);

        filter.setDbType(JdbcUtils.ORACLE);

        filter.setConfig(config);

        DruidDataSource dataSource = new DruidDataSource();

//        dataSource.setName(JdbcUtils.ORACLE);

        filter.init(dataSource);


        String check = null;
        try {
            check = filter.check(sql);
        } catch (SQLException e) {

            e.printStackTrace();
        }

        System.out.println(check);


    }

    /**
     * 无删除操作
     */
    @Test
    public void test2() {
        VerifySql ver = new VerifySql() {
            @Override
            public void setConfig(WallConfig config) {
                // 禁止删除操作
                config.setDeleteAllow(false);
            }
        };

        String sql = "select * from user";

        Boolean verify = ver.verify(sql);

        //true
        System.out.println(verify);

    }

    /**
     * 有删除操作
     */
    @Test
    public void test3() {
        VerifySql ver = new VerifySql() {
            @Override
            public void setConfig(WallConfig config) {
                // 禁止删除操作
                config.setDeleteAllow(false);
            }
        };

        String sql = "select * from user;delete from user";

        Boolean verify = ver.verify(sql);

        //false
        System.out.println(verify);
    }

    /**
     * sql语法错误
     */
    @Test
    public void test4() {
        VerifySql ver = new VerifySql() {
            @Override
            public void setConfig(WallConfig config) {
                // 禁止删除操作
                config.setDeleteAllow(false);
            }
        };

        String sql = "select * delete";

        Boolean verify = ver.verify(sql);

        //false
        System.out.println(verify);
    }

    @Test
    public void test5() throws IOException {
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

        String sql = FileUtils.readFileToString(Paths.get
                ("/home/fzxs/workspace/dcapp-svn/Big_Data_Fusion/branches/dcapp-gzw/src/main",
                        "webapp/WEB-INF/sql"
                        , "gzw_index_box_bubble.sql").toFile());

        System.out.println(sql);
        boolean b = ver.verify(sql);

        System.out.println(b);
    }

}
