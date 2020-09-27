package chinsoft.service.receiving;

import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.ReceivingManager;
import chinsoft.core.EntityHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Receiving;
import chinsoft.service.core.BaseServlet;

public class SaveReceiving extends BaseServlet {

	private static final long serialVersionUID = 9066586997936220637L;
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		String strResult = Utility.RESULT_VALUE_OK;
		try {
			//super.service();
			String strFormData = getParameter("formData");
			Map<String, Object> maps = EntityHelper.jsonToMap(strFormData);
			Receiving receiving=new Receiving();
			receiving.setOwnedstore(maps.get("ownedStore").toString());
			receiving.setOrdenid(maps.get("ordenid").toString());
			receiving.setName(maps.get("name").toString());
			receiving.setSort(Utility.toSafeInt(maps.get("sortID")));
			receiving.setPhonenumber(maps.get("tel").toString());
			receiving.setMemo(maps.get("memo").toString());
			receiving.setCreatetime(Utility.dateToStr(new Date(),"yyyy-MM-dd HH:mm:ss"));
			new ReceivingManager().saveReceiving(receiving);
		} catch (Exception err) {
			output("error:" + err.getMessage());
			strResult="保存失败";
		}
		output(strResult);
	}
}
