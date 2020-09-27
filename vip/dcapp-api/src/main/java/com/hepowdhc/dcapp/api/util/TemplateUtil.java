package com.hepowdhc.dcapp.api.util;

import freemarker.cache.StringTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

import java.io.IOException;
import java.io.StringWriter;
import java.nio.file.Path;
import java.util.Map;

/**
 * @Filename: TemplateUtil.java
 * @Version: 1.0
 * @Author: changji.zhang
 * @Date: 2015年1月28日
 * @Email: changji.zhang@dhc.com.cn
 */
public class TemplateUtil {


    public static String process(Path path, Map<String, Object> dataMap) throws Exception {

        try (
            // 创建StringWriter对象
            StringWriter out = new StringWriter();
        ) {
            // 创建Configuration对象
            Configuration cfg = new Configuration();

            cfg.setDirectoryForTemplateLoading(path.getParent().toFile());

            cfg.setDefaultEncoding("UTF8");

            // 获取字符串模板

            Template template = cfg.getTemplate(path.getFileName().toString());
            // 对象值写入xml模板
            template.process(dataMap, out);

            return out.toString();

        } catch (IOException | TemplateException e) {
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * 将对象值写入XML模板中
     *
     * @param o               实体类对象
     * @param templateContent 模板xml字符串
     * @return 返回xml字符串
     * @throws IOException       异常
     * @throws TemplateException 异常
     */
    public static String writeXML(Object o, String templateContent) throws Exception {
        // 创建Configuration对象
        Configuration cfg = new Configuration();
        // 创建StringTemplateLoader对象
        StringTemplateLoader stringLoader = new StringTemplateLoader();
        // 传入的xml字符串
        stringLoader.putTemplate("template", templateContent);
        // 设定模板
        cfg.setTemplateLoader(stringLoader);
        // 创建StringWriter对象
        StringWriter out = new StringWriter();
        // 获取字符串模板
        try {
            Template template = cfg.getTemplate("template");
            // 对象值写入xml模板
            template.process(o, out);
        } catch (IOException e) {
            e.printStackTrace();
            throw e;
        } catch (TemplateException e) {
            e.printStackTrace();
            throw e;
        } finally {
            try {
                out.close();
            } catch (IOException e) {
                e.printStackTrace();
                throw e;
            }
        }
        return out.toString();
    }

    /**
     * 将对象转换成字符串结果
     *
     * @param templateName 以resources为根的相对路径的文件名
     * @param obj          要填充的对象
     * @return String 转换结果
     * @throws IOException
     */
    public static String parse(String templateName, Object obj)
            throws Exception {
        Configuration cfg = new Configuration();
        // 获取模板
        cfg.setClassForTemplateLoading(TemplateUtil.class, "/");
        Template template = cfg.getTemplate(templateName, "UTF-8");
        // 模板的xml
        String templateStr = template.toString();
        return writeXML(obj, templateStr);
    }

    /**
     * 将对象转换成字符串结果
     *
     * @param templateName 以resources为根的相对路径的文件名
     * @param obj          要填充的对象
     * @return String 转换结果
     * @throws IOException
     */
    public static String parse(String templateName, Object obj, String charset)
            throws Exception {
        Configuration cfg = new Configuration();
        // 获取模板
        cfg.setClassForTemplateLoading(TemplateUtil.class, "/");
        Template template = cfg.getTemplate(templateName, charset);
        // 模板的xml
        String templateStr = template.toString();
        return writeXML(obj, templateStr);
    }

    /**
     * 转换Template 成XML格式
     *
     * @return String 类型
     * @throws IOException 异常
     */
    public static String templateToString(String templateName)
            throws Exception {
        Configuration cfg = new Configuration();
        // 获取模板
        cfg.setClassForTemplateLoading(TemplateUtil.class, "/");
        Template template = cfg.getTemplate(templateName, "UTF-8");
        // 模板的xml
        String templateStr = template.toString();

        return templateStr;
    }
}
