package com.hepowdhc.dcapp.config;

import com.alibaba.druid.pool.DruidDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Created by fzxs on 16-12-13.
 */
@Configuration
public class EngineConfiguration {

    private final Logger logger = LoggerFactory.getLogger(getClass());


    @Bean
    @ConfigurationProperties(prefix = "spring.datasource.druid")
    public DruidConf druidConf() {
        return new DruidConf();
    }

    @Bean
    @ConfigurationProperties(prefix = "dcapp.engine")
    public EngineConf engineConf() {
        return new EngineConf();
    }


    @Bean
    @Primary
    public DataSource druidDataSource() throws IOException {

        DruidDataSource druidDataSource = new DruidDataSource();

        DruidConf conf = druidConf();

        try {

            druidDataSource.setValidationQuery(conf.getValidationQuery());
            druidDataSource.setMaxActive(conf.getMaxActive());
            druidDataSource.setMinIdle(conf.getMinIdle());
            druidDataSource.setMaxWait(conf.getMaxWait());

            druidDataSource.setTestOnBorrow(conf.getTestOnBorrow());
            druidDataSource.setTestOnReturn(conf.getTestOnReturn());
            druidDataSource.setTestWhileIdle(conf.getTestWhileIdle());

            druidDataSource.setPoolPreparedStatements(conf.getPoolPreparedStatements());
            druidDataSource.setMaxPoolPreparedStatementPerConnectionSize(conf.getMaxPoolPreparedStatementPerConnectionSize());

            druidDataSource.setDriverClassName(conf.getDriverClassName());
            druidDataSource.setUrl(conf.getUrl());
            druidDataSource.setUsername(conf.getUsername());
            druidDataSource.setPassword(conf.getPassword());

            druidDataSource.setConnectProperties(conf.getConnectionPropertiesConf());
            druidDataSource.setFilters(conf.getFilters());
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return druidDataSource;
    }

}
