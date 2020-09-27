package cn.com.cgbchina.batch.util;

import java.io.File;

/**
 * Created by zhangLin on 2016/12/29.
 */
public class ConstantlyExported {

    /**
     * 递归删除 文件、文件夹
     *
     * @param dir
     * @return
     */
    public static boolean deleteDir(File dir) {
        if (dir.isDirectory()) {
            File[] children = dir.listFiles();
            // 递归删除目录中的子目录下
            for (int i = 0; i < children.length; i++) {
                boolean success = deleteDir(children[i]);
                if (!success) {
                    return false;
                }
            }
        }
        // 目录此时为空，可以删除
        return dir.delete();
    }
}
