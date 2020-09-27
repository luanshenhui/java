package cn.com.cgbchina.batch.tools;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.dom4j.Document;
import org.dom4j.Element;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import com.spirit.redis.JedisTemplate;

import redis.clients.jedis.Jedis;
import redis.clients.util.Pool;

import com.google.common.base.Joiner;
import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;


public class DataReset {
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String arg = args[0];
//		dabanyeceshi();
		// 更新商品名称乱码
		if ("1".equals(arg)) {
			System.out.println("###更新商品名称乱码请等待结果###");
			AbstractApplicationContext ctx = new ClassPathXmlApplicationContext(
					"spring/tools.xml");
			ctx.start();
			updateGoodsName(ctx);
		}	
		
		// 更新商品REDIS属性乱码
		if ("2".equals(arg)) {
			System.out.println("###更新商品属性乱码请等待结果###");
			AbstractApplicationContext ctx = new ClassPathXmlApplicationContext(
					"spring/tools.xml");
			ctx.start();
			checkRedis(ctx);
		}

		// 检查REDIS商品是否没有类目
		if ("checkSpu".equals(arg)) {
			System.out.println("###检查缺少类目的商品请等待结果###");
			AbstractApplicationContext ctx = new ClassPathXmlApplicationContext(
					"spring/tools.xml");
			ctx.start();
			checkCategory(ctx);
		}
		
		if("3".equals(arg)||"4".equals(arg)||"5".equals(arg)||"6".equals(arg)){
			System.out.println("###更新ITEM属性请等待结果###");
			AbstractApplicationContext ctx = new ClassPathXmlApplicationContext(
					"spring/tools.xml");
			ctx.start();
			updateItemAttr(ctx,Integer.valueOf(arg));
		}
		
		
		if("7".equals(arg)){
			AbstractApplicationContext ctx = new ClassPathXmlApplicationContext(
					"spring/tools2.xml");
			ctx.start();
			rebuildBackCategory(ctx);
		}
		
		if("8".equals(arg)){
			System.out.println("###重置积分&&广发商城一级类目###");
			AbstractApplicationContext ctx = new ClassPathXmlApplicationContext(
					"spring/tools.xml");
			ctx.start();
			backCategory0(ctx);
		}
		
	}
	
	private static void dabanyeceshi(){
		
		try {
			AbstractApplicationContext ctx = new ClassPathXmlApplicationContext(
					"spring/tools.xml");
			ctx.start();
			JedisTemplate jedisTemplate = (JedisTemplate) ctx
					.getBean(JedisTemplate.class);
			Pool<Jedis> pl = jedisTemplate.getJedisPool();
			Jedis jedis = pl.getResource();
			BufferedReader bfread=new BufferedReader(new InputStreamReader(new FileInputStream("E:\\test\\12412.txt")));
			 String data= null;
			 int i=0;//没问题的
			 int j=0;//总数
			 while((data=bfread.readLine())!=null){
				 j++;
				 Map<String,String> every=jedis.hgetAll("spu:"+data);
				 if( every.get("id")==null|| every.get("id").equals("")){
					 System.out.println("这个ID有问题："+data);
				 }else{
					 i++;
				 }
			 }
			 System.out.println("DB总共有:"+j+"个产品");
			 System.out.println("redis总共有:"+i+"个spu");
			 System.out.println("redis比DB少:"+(j-i)+"个");
		} catch (Exception e) {
		 System.out.println(e);
		}
		
	}

	static Joiner douhao = Joiner.on(",").skipNulls();
    static Joiner shuxian=Joiner.on("|").skipNulls();
	private static void rebuildBackCategory(AbstractApplicationContext ctx) {
		JedisTemplate jedisTemplate = (JedisTemplate) ctx
				.getBean(JedisTemplate.class);
		Pool<Jedis> pl = jedisTemplate.getJedisPool();
		Jedis jedis = pl.getResource();
		GoodsDao goodsDao = (GoodsDao) ctx.getBean(GoodsDao.class);
		System.out.println("插入分类表操作");
		//清空数据
		System.out.println("清空分类数据"+goodsDao.deleteCategoryRelation());
		List<Transfer> inserts = Lists.newArrayList();
		Set<String> ids = jedis.keys("back-category:*");
		final Pattern pattern = Pattern.compile("back-category:[0-9]+$");

		Collection<String> resultIds = Collections2.filter(ids,
				new Predicate<String>() {
					@Override
					public boolean apply(String input) {
						
					Matcher matcher=pattern.matcher(input);
						return matcher.find();
					}
				});
		System.out.println("应该插入："+resultIds.size()+"条 请耐心等待。。。。");
		Transfer transfer = null;
		
		int i=0;
		for (String id : resultIds) {
			transfer = new Transfer();
			Map<String, String> backcategory = jedis.hgetAll(id);
			String categoryId = (String) backcategory.get("id");
			transfer.setCategoryid(categoryId);
			transfer.setCategoryname((String) backcategory.get("name"));
			transfer.setParientid((String) backcategory.get("parentId"));
			List<String> childrenIds = jedis.lrange("back-category:"
					+ categoryId + ":children", 0L, -1L);

			if (childrenIds != null && childrenIds.size() > 0) {
				transfer.setChildrenids(douhao.join(childrenIds));
			}
			List<String> spuIds = jedis.lrange("back-category:" + categoryId
					+ ":spus", 0L, -1L);

			if (spuIds != null && spuIds.size() > 0) {
				transfer.setSpus(douhao.join(spuIds));
			}
			List<String> attributeIds = jedis.lrange("back-category:"
					+ categoryId + ":keys", 0L, -1L);

			if (attributeIds != null && attributeIds.size() > 0) {
				transfer.setAttributesKeys(douhao.join(attributeIds));
				List<String> tempValueList=Lists.newArrayList();
				for (String attributeId : attributeIds) {
					List<String> attributeValues = jedis.lrange(
							"back-category:" + categoryId + ":key:"
									+ attributeId + ":values", 0L, -1L);
					if(attributeValues==null || attributeValues.size()==0){
						tempValueList.add("~");
						}else{
						
					tempValueList.add(douhao.join(attributeValues));}
				}
				transfer.setAttributesValues(shuxian.join(tempValueList));
			}
			inserts.add(transfer);
			i=i+goodsDao.insertCategoryRelation(transfer);
		}
		System.out.println("加入了"+i+"个分类");
	}
	
	
	
	private static void backCategory0(AbstractApplicationContext ctx) {
		    //TODO
		JedisTemplate jedisTemplate = (JedisTemplate) ctx
				.getBean(JedisTemplate.class);
		Pool<Jedis> pl = jedisTemplate.getJedisPool();
		Jedis jedis = pl.getResource();
		//获取所有一级类目
		List<String> lists = jedis.lrange("back-category:0:children", 0L, -1L);
		for (String id:lists) {
			if("1".equals(id)||"2".equals(id)){
				continue;
			}
			try {
				Map<String, String> map = jedis.hgetAll("back-category:"+id);
				String channel = (String) map.get("channel");
				if(channel!=null&&channel.equals("YG")){
					jedis.rpush("back-category:YG:keys", id);
				}else if(channel!=null&&channel.equals("JF")){
					jedis.rpush("back-category:JF:keys", id);
				}
			} catch (Exception e) {
				System.out.println("该类目已删除"+id);
			}
		}
		System.out.println("初始化积分广发一级类目完毕");
	}

	public static void checkRedis(AbstractApplicationContext ctx) {
		JedisTemplate jedisTemplate= (JedisTemplate) ctx.getBean(JedisTemplate.class);
		Pool<Jedis> pl=jedisTemplate.getJedisPool();
		Jedis jedis =pl.getResource();
		Set<String> ids = jedis.keys("attribute-value:*");
		Map<String,String> DataMap=new HashMap<>();
		for (String key : ids) {
			try {
				Map<String,String> every=jedis.hgetAll(key);
				DataMap.put(every.get("id"), every.get("value"));
			} catch (Exception e) {
				System.out.println("过滤不需要处理的key："+key);
			}
		}
		System.out.println("总体数据量:"+DataMap.size());
		DataMap=makeData(DataMap);
		System.out.println("乱码数据量"+DataMap.size());
		int i=0;
		for(Entry<String,String> entry:DataMap.entrySet()){
		jedis.hset("attribute-value:"+entry.getKey(), "value", entry.getValue());
		i++;
		}
		System.out.println("处理数量:"+i);

	}

	private static void updateGoodsName(AbstractApplicationContext ctx) {
		GoodsDao goodsDao = (GoodsDao) ctx.getBean(GoodsDao.class);
		Map<String, String> map = goodsDao.findAllGoodsName();
		System.out.println("###总数据量###:" + map.size());
		map = makeData(map);
		System.out.println("###乱码数据###:" + map.size());
		int num = goodsDao.updateGoodsNameByMap(map);
		System.out.println("###更新成功###:" + num);
	}
	
	private static void updateItemAttr(AbstractApplicationContext ctx,int type) {
		ItemDao itemDao = (ItemDao) ctx.getBean(ItemDao.class);
		Map<String, String> map = itemDao.findItemAttr(type);
		if(type==3){
			System.out.println("更新itemAttrName1");
		}
		if(type==4){
			System.out.println("更新itemAttrName2");
		}
		if(type==5){
			System.out.println("更新itemAttrkey1");
		}
		if(type==6){
			System.out.println("更新itemAttrkey2");
		}
		System.out.println("###总数据量###:" + map.size());
		map = makeData(map);
		System.out.println("###乱码数据###:" + map.size());
		int num = itemDao.updateItemAttr(map, type);
		System.out.println("###更新成功###:" + num);
	}

	private static void checkCategory(AbstractApplicationContext ctx) {
		JedisTemplate jedisTemplate= (JedisTemplate) ctx.getBean(JedisTemplate.class);
		Pool<Jedis> pl=jedisTemplate.getJedisPool();
		Jedis jedis =pl.getResource();
		Set<String> ids = jedis.keys("spu:*");
		int i=0;//spu个数
		int s=0;//没有类目的spuId个数
		for (String key : ids) {
			try {
				Map<String,String> every=jedis.hgetAll(key);
				if(every.get("categoryId")==null||"".equals(every.get("categoryId"))){
					System.out.println("spuId="+every.get("id")+" | CategoryId="+every.get("categoryId")+" | name="+every.get("name")+" | brandId="+every.get("brandId")+" | status="+every.get("status"));
				s++;
				}
				i++;
			} catch (Exception e) {
				
			}
		}
		System.out.println("#####redis中Spu数量:"+i+"#######");
		System.out.println("#####没有类目的Spu数量:"+s+"#######");
	}

	private static Map<String, String> makeData(Map<String, String> data) {
		// 定义数据的id
		String id = "";
		// 定义数据text
		String text = "";
		// 定义需要更新的数据map
		HashMap<String, String> updateMap = new HashMap<>();
		int ss=0;
		for (Entry<String, String> entry : data.entrySet()) {
			id = "n" + entry.getKey();
			text = entry.getValue();
			Document document = org.dom4j.DocumentHelper.createDocument();
			Element soapenv = document.addElement(id);
			if(text!=null){
				soapenv.addText(text);
			}else{
				soapenv.addText("");
			}
			String xml = document.asXML();
			Pattern p = Pattern.compile("\\&\\#[0-9]+\\;");
			Matcher matcher = p.matcher(xml);
			String last = String.valueOf(xml);
			while (matcher.find()) {
				last = last.replaceAll(matcher.group(), "");
			}
			ss++;
			//判断是否有乱码
			if (last.length() != xml.length()) {
				StringReader sr = new StringReader(last);
				InputSource is = new InputSource(sr);
				DocumentBuilderFactory factory = DocumentBuilderFactory
						.newInstance();
				DocumentBuilder b;
				try {
					b = factory.newDocumentBuilder();
					org.w3c.dom.Document doc = b.parse(is);
					Node node = doc.getLastChild();
					String tx=	node.getTextContent();
					if(tx==null||tx.equals("")){
						tx="无";
						System.out.println("商品:"+node.getNodeName().substring(1)+" 属性只有乱码文");
					}
					updateMap.put(node.getNodeName().substring(1),
							tx);
				} catch (Exception e) {	
					System.out.println("第"+ss+"个失败");
					System.out.println("转化失败的"+entry.getKey()+" xml:"+last);
					System.out.println(e.toString());
				}
			}
		}
		return updateMap;
	}

}
class BackCategory{
	private long id;
	private String name;
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	@Override
	public String toString() {
		return "BackCategory [id=" + id + ", name=" + name + "]";
	}

    

}
