package test;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;

import org.junit.Test;
public class TestB {
	 /**
     * 2.生产型接口：Supplier
     * @FunctionalInterface 
     * public interface Supplier<T>
     * 代表结果供应商。
     * 没有要求每次调用供应商时都会返回新的或不同的结果。
     * 这是一个functional interface的功能方法是get() 。
     * 从以下版本开始：
     * 1.8
     */
    @Test
    public void testSupplier() {
        /*
         * T get()
         *      获得结果。
         */
        Supplier<String> sup = () -> "生产型接口~";
        String string = sup.get();
        System.out.println(string);
    }
    
  //Supplier<T>:供给型接口
    @Test
    public void test2(){
        List<Integer> numList = getNumList(10, () -> (int) (Math.random() * 100));
        for (Integer num:numList) {
            System.out.println(num);
        }
    }
    //需求：产生指定个数整数，并放入集合中
    public List<Integer> getNumList(int num, Supplier<Integer> supplier){
        List<Integer> list=new ArrayList<>();
        for (int i=0;i<num;i++){
            Integer n = supplier.get();
            list.add(n);
        }
        return list;
    }
}
