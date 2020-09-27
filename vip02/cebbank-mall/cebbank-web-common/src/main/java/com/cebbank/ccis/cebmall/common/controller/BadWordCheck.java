package com.cebbank.ccis.cebmall.common.controller;

import com.google.common.base.Charsets;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Sets;
import com.google.common.io.Files;
import com.google.common.io.LineProcessor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import java.io.File;
import java.io.IOException;
import java.util.Set;
import java.util.concurrent.atomic.AtomicReference;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/30.
 */
@Component
@Slf4j
public class BadWordCheck {

    @Autowired
    private ServletContext servletContext;
    private AtomicReference<Set<String>> sensitiveWords;
    private File sensitiveWordsDictionary;
    private volatile long lastModified;

    @PostConstruct
    public void init() {
        this.sensitiveWords = new AtomicReference<Set<String>>();
        sensitiveWordsDictionary = new File(servletContext.getRealPath("/")+
                File.separator + "WEB-INF" + File.separator + "sensor_words.txt");
        reload();
        lastModified = sensitiveWordsDictionary.lastModified();
    }

    private void checkIfNeedReload() {
        if (sensitiveWordsDictionary.lastModified() > lastModified) {
            lastModified = sensitiveWordsDictionary.lastModified();
            reload();
        }
    }

    private void reload() {
        try {
            final Set<String> result = Files.readLines(sensitiveWordsDictionary, Charsets.UTF_8, new LineProcessor<Set<String>>() {
                private Set<String> sensitveWords = Sets.newHashSet();
                @Override
                public boolean processLine(String line) throws IOException {
                    sensitveWords.add(line.trim());
                    return true;
                }
                @Override
                public Set<String> getResult() {
                    return sensitveWords;
                }
            });
            this.sensitiveWords.set(result);
        } catch (IOException e) {
            log.error("failed to load sensitive words file ({}), cause:{}", sensitiveWordsDictionary.getAbsolutePath(),
                    Throwables.getStackTraceAsString(e));
        }
    }

    /**
     * 检查敏感字内容 , 并做替换
     *
     * @param content 输入的内容
     */
    public String check(String content) {
        if (!sensitiveWordsDictionary.exists()) {
            return content;
        }
        checkIfNeedReload();
        for (String word : this.sensitiveWords.get()) {
            String target = Strings.repeat("*", word.length());
            content = content.replaceAll(word, target);
        }
        return content;
    }

}
