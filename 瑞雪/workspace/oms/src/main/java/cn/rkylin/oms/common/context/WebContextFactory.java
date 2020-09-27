package cn.rkylin.oms.common.context;

import java.io.File;

import javax.servlet.ServletContext;

import org.springframework.stereotype.Component;
import org.springframework.web.context.ServletContextAware;

import cn.rkylin.oms.common.Global;

/**
 * 上下文工厂
 * @author wangxiaoyi
 * @version 1.0
 * @since 2017年2月15日
 */
@Component
public class WebContextFactory implements ServletContextAware {

    private static ServletContext servletContext;
    private static String localUploadPath;  //本地上传路径
    private static String webRealPath;      //本地web根路径

    /**
     * 私有构造函数，不允许new本类，只能静态使用
     */
    private WebContextFactory() {
    }

    private static ThreadLocal<IWebContext> ctxStore = new ThreadLocal<IWebContext>();

    private static void setWebContext(IWebContext ctx) {
        ctxStore.set(ctx);
    }

    public static IWebContext getWebContext() {
        IWebContext ctx = ctxStore.get();
        if (ctx == null) {
            ctx = new DefaultWebContext();
            setWebContext(ctx);
        }
        return ctxStore.get();
    }

    public void setServletContext(ServletContext servletContext) {
        setContext(servletContext);
    }

    public static synchronized void setContext(ServletContext servletContext) {
        WebContextFactory.servletContext = servletContext;
    }

    public static String getLocalUploadPath() {
        if (localUploadPath != null) {
            return localUploadPath;
        } else {
            localUploadPath = servletContext.getRealPath("/") + File.separatorChar + Global.UPLOAD_DIR + File.separatorChar;
            return localUploadPath;
        }
    }

    /**
     *
     * @return
     */
    public static String getWebRealPath() {
        if (webRealPath != null) {
            return webRealPath;
        } else {
            webRealPath = servletContext == null ? null : servletContext.getRealPath("/");
            return webRealPath;
        }
    }

    public static String getContentPath() {
        return servletContext.getContextPath();
    }

    public static synchronized void setWebRootPath(String webRootPath) {
        WebContextFactory.webRealPath = webRootPath;
    }
}
