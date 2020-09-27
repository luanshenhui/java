package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.common.utils.ExportUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by txy on 2016/8/30.
 */
@Controller
@RequestMapping("/api/vendor/report")
@Slf4j
public class Report {

    private String rootFilePath;
    public Report() {
        this.rootFilePath = this.getClass().getResource("/upload").getPath();
    }
    /**
     * 导出文件
     *
     * @param response
     * @author zhoupeng
     */
    @RequestMapping(value = "/excel", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public void downloadReport(String fileUrl, HttpServletResponse response, HttpServletRequest request) {
    	ExportUtils.downloadReport(fileUrl, response, request);
    }

}
