package com.hepowdhc.dcapp;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.SpringBootConfiguration;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportResource;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Created by fzxs on 16-11-25.
 */

@Configuration
@ComponentScan
@EnableAutoConfiguration
@SpringBootConfiguration
@EnableScheduling
@EnableConfigurationProperties
@ImportResource(locations = {"classpath:engine-config.xml"})
public class Application {

    private final static Logger logger = LoggerFactory.getLogger(Application.class);

    public static void main(String[] args) {

        logger.info("=================引擎正在执行=================");

        SpringApplication.run(Application.class);

    }

}


