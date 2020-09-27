import org.junit.Test;
import sun.reflect.generics.tree.ArrayTypeSignature;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.MessageFormat;
import java.util.*;
import java.util.function.Consumer;

/**
 * Created by fzxs on 16-12-19.
 */
public class TestDemo {

    @Test
    public void test001() {

        for (int i = 0; i < 10; i++) {


            String uuid = UUID.randomUUID().toString();

            System.out.println(uuid);
        }

    }

    @Test
    public void test002() {

        List<Integer> list = new ArrayList<>();

        for (int i = 0; i < 10000; i++) {


            list.add(i);
        }

        list.parallelStream().forEach(i -> System.out.println("->" + i));

    }


    @Test
    public void testConsumer() {
        Consumer<String> consumer1 = (x) -> System.out.print(x);
        Consumer<String> consumer2 = (x) -> {
            System.out.println(" after consumer 1" + "=======>" + x);
        };
        consumer1.andThen(consumer2).accept("test consumer1");


    }


    @Test
    public void testDemo003() {

        String st = "你好:{0},{1}";

        System.out.println(MessageFormat.format(st, "中国", "大连"));

    }

    @Test
    public void testDemo004() throws Exception {

        Map<String, Object> map = new HashMap<>();

        class Demo1 {

            {
                map.put("111", this);

                try {
                    MessageDigest digest = MessageDigest.getInstance("MD5");

                    byte[] digest1 = digest.digest("fzxs".getBytes());



                    map.put("md5",new BigInteger(1, digest1).toString(16));
                } catch (NoSuchAlgorithmException e) {
                    e.printStackTrace();
                }

            }

            @Override
            public String toString() {
                return "Demo1{test}";
            }
        }

        new Demo1();

        System.out.println(map);
    }


    @Test

    public void test003(){

     boolean b=   Arrays.stream("s1;s2;s3;s4;".split(";"))
                .noneMatch(s ->{
                    System.out.println(s); return s.equals("s3");});

        System.out.println(b);

    }
}