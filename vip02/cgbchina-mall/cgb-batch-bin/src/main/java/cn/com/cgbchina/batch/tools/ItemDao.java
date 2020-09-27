package cn.com.cgbchina.batch.tools;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

@Repository
public class ItemDao extends SqlSessionDaoSupport {


	public Map<String,String> findAllAttrKey1(){
		List<ItemModelTool> item=getSqlSession().selectList("ToolsItem.findAllAttrKey1");
		Map<String,String> map=new HashMap<String, String>();
		for (ItemModelTool it:item) {
			map.put(it.getCode(), it.getAttributeKey1());
		}
		return map;
	}
	
	public Map<String,String> findAllAttrKey2(){
		List<ItemModelTool> item=getSqlSession().selectList("ToolsItem.findAllAttrKey2");
		Map<String,String> map=new HashMap<String, String>();
		for (ItemModelTool it:item) {
			map.put(it.getCode(), it.getAttributeKey2());
		}
		return map;
	}
	
	public Map<String,String> findAllAttrName1(){
		List<ItemModelTool> item=getSqlSession().selectList("ToolsItem.findAllAttrName1");
		Map<String,String> map=new HashMap<String, String>();
		for (ItemModelTool it:item) {
			map.put(it.getCode(), it.getAttributeName1());
		}
		return map;
	}
	
	public Map<String,String> findAllAttrName2(){
		List<ItemModelTool> item=getSqlSession().selectList("ToolsItem.findAllAttrName2");
		Map<String,String> map=new HashMap<String, String>();
		for (ItemModelTool it:item) {
			map.put(it.getCode(), it.getAttributeName2());
		}
		return map;
	}
	
	public Map<String,String> findItemAttr(int type){
		if(type==3){
			return findAllAttrName1();
		}
		if(type==4){
			return findAllAttrName2();
		}
		if(type==5){
			return findAllAttrKey1();
		}
		if(type==6){
			return findAllAttrKey2();
		}
		return null;
	}

	public int updateItemAttr(Map<String,String>map,int type){
		if(map.size()==0){
			return 0;
		}
		String sql="";
		if(type==3){
			sql="ToolsItem.updateAttrName1";	
		}
		if(type==4){
			sql="ToolsItem.updateAttrName2";
		}
		if(type==5){
			sql="ToolsItem.updateAttrKey1";
		}
		if(type==6){
			sql="ToolsItem.updateAttrKey2";
		}
		
		//由于数据量较少这样做无所谓不消耗什么性能
		int i=0;
		for (Entry<String,String> entry:map.entrySet()) {
			ItemModelTool item=new ItemModelTool();
			item.setCode(entry.getKey());
			item.setAttributeKey1(entry.getValue());
			i=i+getSqlSession().update(sql,item);
		}
		return i;
	}
}
