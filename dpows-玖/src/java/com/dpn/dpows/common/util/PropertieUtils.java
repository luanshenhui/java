package com.dpn.dpows.common.util;

import java.io.*;
import java.util.Properties;

/**
 * Created by zhaoqian on 15-5-15.
 *
 * PropertieUtils 是借鉴 JFinal 里中的方法实现的，但配置文件要求放在WEB-INF/class目录下
 */
public class PropertieUtils {

    public static Properties loadPropertyFile(String fullFile) {
        String webRootPath = null;
        if (null == fullFile || fullFile.equals(""))
            throw new IllegalArgumentException(
                    "Properties file path can not be null : " + fullFile);

        webRootPath = PropertieUtils.class.getClassLoader().getResource("").getPath();
        //设置配置文件的所搜路径为WEB-INF下
        //webRootPath = new File(webRootPath).getParent();
        InputStream inputStream = null;
        Properties p = null;

        try {
            inputStream = new FileInputStream(new File(webRootPath + File.separator + fullFile));
            p = new Properties();
            p.load(inputStream);
        } catch (FileNotFoundException e) {
            throw new IllegalArgumentException("Properties file not found: " + fullFile);
        } catch (IOException e) {
            throw new IllegalArgumentException(
                    "Properties file can not be loading: " + fullFile);
        } finally {
            try {
                if (inputStream != null)
                    inputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return p;
    }

}
