
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.dpn.dpows.common.util.HttpUitl;
import com.dpn.dpows.common.util.UUIDHexGenerator;
import com.dpn.dpows.standard.model.WorkDeclareGoodsDto;

public class TestRestful {
	public static void main(String[] args){
		JSONObject param = new JSONObject();
		TestRestful.getTest(param);
	}
	public static JSONObject getTest(JSONObject param) {
		JSONObject obj = null;
		JSONArray goods = new JSONArray();
		String url = "http://localhost:8080/dpows/work/approve";
		param.put("id","2c9086e75f053fbd015f054601830001");
		param.put("managerUserId",UUIDHexGenerator.getInstance().generate());
		param.put("currentUserId",UUIDHexGenerator.getInstance().generate());
		param.put("verifyStatus","2");
		param.put("verifyOpinion","同意");
		for(int i=0;i<3;i++){
			WorkDeclareGoodsDto workDeclareGoods = new WorkDeclareGoodsDto();
			//System.out.println("+++++++"+i);
			workDeclareGoods.setDeclareGoodsId("2c9086e75f053fbd015f05460183000"+i);
			workDeclareGoods.setStatus("2");
			workDeclareGoods.setVerifyOpinion("同意");
			workDeclareGoods.setVerifyUserId(UUIDHexGenerator.getInstance().generate());
			goods.add(workDeclareGoods);
		}
		System.out.println("jsonArray:"+goods);  
		param.put("goods", goods);
		System.out.println("param"+param);
		try{
			obj = HttpUitl.httpPost(url, param, false);
		}catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("+++++++++"+obj);
		return obj;
	}
}
