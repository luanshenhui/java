package test;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;

import org.junit.Test;
public class TestD {
	/**
     * Predicate<T>：断言型接口
     *  java.util.function
     * Interface Predicate<T>
     * 参数类型
     *      T - T输入的类型
     * Functional Interface:
     *      这是一个FunctionInterface，因此可以用作lambda表达式或方法引用的赋值对象。
     */
    @Test
    public void testPredicate() {
        /**
         * boolean test(T t)
         * 在给定的参数上评估这个谓词。
         * 参数
         *      t - 输入参数
         * 结果
         *      true如果输入参数匹配谓词，否则为 false
         */
        Predicate<Integer> pre = (a) -> a > 0;
        boolean test = pre.test(10);
        System.out.println("10 > 0 : " + test);
    }
    
  //Predicate<T>:断言型接口
    @Test
    public void test4() {
        List<String> list = Arrays.asList("hello", "atguigu", "Lambda", "www", "ok");
        List<String> strList = filterStr(list, (s) -> s.length() > 3);
        for (String str :strList) {
            System.out.println(str);
        }
    }

    //需求：将满足条件的字符串，放入集合中
    public List<String> filterStr(List<String> list, Predicate<String> predicate) {
        List<String> strlist = new ArrayList<>();
        for (String str : list) {
            if (predicate.test(str)) {
                strlist.add(str);
            }
        }
        return strlist;
    }
}
