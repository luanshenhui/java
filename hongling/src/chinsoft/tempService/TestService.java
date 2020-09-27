package chinsoft.tempService;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import chinsoft.core.ConfigHelper;

public class TestService {
	
	public String getImgName(byte[] fileByte,String fileName){
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
		String dateStr = format.format(new Date());
		StringBuffer strPath = new StringBuffer();
		String strResourcePath = Thread.currentThread().getContextClassLoader().getResource("").getPath();
		strResourcePath=strResourcePath.substring(0,strResourcePath.lastIndexOf("WEB-INF"));
		strResourcePath=strResourcePath+"pages/style_UI/images/ordenPhoto/thumbnails/";
		strPath.append(ConfigHelper.getContextParam().get("CfgPath"));// 获取资源文件的路径
		strPath.append("upload\\");
		File file = new File(strPath.toString());
		if(!file.exists()){
			file.mkdir();
		}
		System.out.println(file.getPath());
		strPath.append(dateStr);
		strPath.append("-");
		strPath.append(fileName);
		FileOutputStream out;
		try {
			out = new FileOutputStream(new File(strPath.toString()));
			out.write(fileByte);
			out.close();
		} catch (Exception e) {
			System.out.println("读取图片失败");
//			e.printStackTrace();
		}
		return dateStr+"-"+fileName;
	}
}
