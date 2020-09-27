package test;

import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;

import org.junit.Test;

public class TestA {

	//Consumer<T>:消费型接口
	@Test
	public void test1(){
	    happy(10000,(m)->System.out.println("你们哥喜欢大宝剑，每次消费："+m+"元"));
	}
	public void happy(double money, Consumer<Double> consumer){
	    consumer.accept(money);
	}
	
    @Test
    public void testConsumer() {
        /*
         * void accept(T t)
         *      对给定的参数执行此操作。
         * 参数
         *      t - 输入参数
         */
        Consumer<String> con = (str) -> System.out.println("你好，" + str);
        con.accept("消费型接口~");
    }
}
