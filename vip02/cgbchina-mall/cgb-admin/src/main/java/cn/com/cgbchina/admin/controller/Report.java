package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.utils.ExportUtils;

import cn.com.cgbchina.trade.service.OrderIOService;
import com.google.common.base.Throwables;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Created by txy on 2016/8/26.
 */
@Controller
@RequestMapping("/api/admin/report") // 请求映
@Slf4j
public class Report {

    @Autowired
    private OrderIOService orderIOService;

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
        try {
            ExportUtils.downloadReport(fileUrl, response, request);
        } catch (Exception e) {
            log.error("fail to downloadReport error:", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, "文件导出失败");
        }
    }
}
