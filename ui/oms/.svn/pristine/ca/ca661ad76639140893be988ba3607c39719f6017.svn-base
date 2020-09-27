package cn.rkylin.apollo.spark;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cn.rkylin.core.controller.AbstractController;

/**
 * Created by wangjm on 2016-11-26.
 */
@Controller
@RequestMapping("/spark")
public class SparkController extends AbstractController  {
    private static final Log log = LogFactory.getLog(SparkController.class);



//    public static Map<String, Object> manager(){
//        Map<String, Object> retMap = new HashMap<String, Object>();
//        SparkConf conf = new SparkConf().setMaster("local").setAppName("My App");
//        JavaSparkContext sc = new JavaSparkContext(conf);
//        JavaRDD<String> input = sc.textFile("D://file.text");
//        JavaRDD<String> words = input.flatMap(
//                new FlatMapFunction<String, String>() {
//                    @Override
//                    public Iterable<String> call(String s) throws Exception {
//                        return Arrays.asList(s.split(" "));
//                    }
//                }
//        );
//        JavaPairRDD<String,Integer> counts = words.mapToPair(
//                new PairFunction<String, String, Integer>() {
//                    @Override
//                    public Tuple2<String, Integer> call(String s) throws Exception {
//                        return new Tuple2(s,1);
//                    }
//                }
//        ).reduceByKey(new Function2<Integer, Integer, Integer>() {
//            @Override
//            public Integer call(Integer integer, Integer integer2) throws Exception {
//                return integer+integer2;
//            }
//        });
//        retMap.put("count",counts);
//        return retMap;
//    }
//
//    public static void main(String [] args){
//        manager();
//    }

}
