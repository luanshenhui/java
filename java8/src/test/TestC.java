package test;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;

import org.junit.Test;
public class TestC {
	/**
     * Function<T,R>：函数型接口
     *  java.util.function
     * Interface Function<T,R>
     * 参数类型
     *      T - 函数输入的类型
     *      R - 函数的结果类型
     */
    @Test
    public void testFunction() {
        /**
         * R apply(T t)
         *      将此函数应用于给定的参数。
         * 参数
         *      t - 函数参数
         * 结果
         *      功能结果
         */
        Function<Integer,String> func = (str) -> str + "，函数性接口~";
        String apply = func.apply(5);
        System.out.println(apply);
    }

    
    //Function<T,R>:函数型接口
    @Test
    public void test3(){
        String newStr = strHandler("\t\t\t 我大北大荒威武  ", (str) -> str.trim());
        System.out.println(newStr);

        String subStr = strHandler("我大北大荒威武", (str) -> str.substring(2, 5));
        System.out.println(subStr);
    }
    //需求：用于处理字符串
    public String strHandler(String str, Function<String,String> function){
        return function.apply(str);
    }
}
