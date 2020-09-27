package cn.com.cgbchina.batch.tools;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

@Repository
public class GoodsDao extends SqlSessionDaoSupport {


	public Map<String,String> findAllGoodsName(){
		List<GoodsModelTool> goodsList=getSqlSession().selectList("ToolsGoods.findAllGoodsName");
		Map<String,String> map=new HashMap<String, String>();
		for (GoodsModelTool goods:goodsList) {
			map.put(goods.getCode(), goods.getName());
		}
		return map;
	}

	
	public int updateGoodsNameByMap(Map<String,String>map){
		if(map.size()==0){
			return 0;
		}	
		//由于数据量较少这样做无所谓不消耗什么性能
		int i=0;
		for (Entry<String,String> entry:map.entrySet()) {
			GoodsModelTool goods=new GoodsModelTool();
			goods.setCode(entry.getKey());
			goods.setName(entry.getValue());
			getSqlSession().update("ToolsGoods.updateGoodsNameByMap",goods);
			i++;
		}
		return i;
	}
	
	public int insertCategoryRelation(Transfer transfer){
		return 	getSqlSession().insert("ToolsGoods.insertCategoryRelation",transfer);
	}
	
	public int deleteCategoryRelation(){
		return 	getSqlSession().insert("ToolsGoods.deleteCategoryRelation");
	}
}
