package cn.com.cgbchina.rest.common.process;


import java.util.List;

/**
 * Comment:
 * Created by 11150321050126 on 2016/11/1.
 */
public interface ReflectPacking {
    <T> T processObjPacking(T element, String name, String value);
    <T> T processListPacking(T element,List list,Integer level,Integer index);
}
