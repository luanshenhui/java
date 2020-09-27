package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11150121040023 on 2016/7/14.
 */
@Slf4j
public abstract class BaseControl {
    private String[] args;
    private String batchName;
    private String logmsg;
    public void setArgs(String[] args) {
        this.args = args;
    }
    public String[] getArgs() {return args;}
    public void setBatchName(String name) {
        this.batchName = name;
    }
    public String getBatchName() {return batchName;}
    public void setLogmsg(String logmsg) { this.logmsg = logmsg;}
    public String getLogmsg() {return logmsg;}
    protected abstract Response execService() throws BatchException;

    protected void exec() {
        printLogStart();
        log.info(this.getClass().getSimpleName() + ":" + logmsg);
        try {
            Response response = execService();
            if (response.isSuccess()) {
                printLogEnd("0");
                log.info(this.getClass().getSimpleName() + ":" + logmsg);
            } else {
                printLogEnd("1");
                log.error(this.getClass().getSimpleName() + ":" + logmsg + "{}", response.getError());
            }
        } catch (Exception e) {
            printLogEnd("1");
            log.error(this.getClass().getSimpleName() + ":" + logmsg + "{}", Throwables.getStackTraceAsString(e));
            return;
        }
    }

    protected void printLogStart() {
        setLogmsg(batchName + "开始...");
//        printLog(logmsg);
    }

    protected void printLogEnd(String ret) {
        if (ret.equals("0")) {
            setLogmsg(batchName + "成功");

        } else {
            setLogmsg(batchName + "失败");
        }
        printLog(ret);
//        printLog(logmsg);
    }

    private void printLog(String msg) {
        System.out.println(msg);
    }

}
