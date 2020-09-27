package chinsoft.service.webservice;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import rcmtm.business.ImageHelper;
import chinsoft.business.CDict;
import chinsoft.core.ConfigHelper;
import chinsoft.service.core.Encryption;

public class ImageService {
	public String uploadImageWithByte(byte[] fileByte, int fileLength,
			String strFileName,String clotingID) {
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
		StringBuffer strPath = new StringBuffer();
		String strResourcePath = Thread.currentThread().getContextClassLoader().getResource("").getPath();
		strResourcePath=strResourcePath.substring(0,strResourcePath.lastIndexOf("WEB-INF"));
		strResourcePath=strResourcePath+"pages/style_UI/images/"+clotingID+"/thumbnails/";
		strPath.append(ConfigHelper.getContextParam().get("CfgPath"));// 获取资源文件的路径
		strPath.append("\\upload\\");
		strPath.append(format.format(new Date()));
		strPath.append("-");
		strPath.append(strFileName);
		FileOutputStream out;
		try {
			out = new FileOutputStream(strPath.toString());
			out.write(fileByte, 0, fileLength);
			out.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String likeStyle="ERROR";
		try {
			likeStyle= Encryption.encrypt(likeStyle, CDict.DES_KEY);
			likeStyle = Encryption.encrypt(getLikeImg(strResourcePath, strPath.toString()), CDict.DES_KEY);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return likeStyle;
	}

	private String getLikeImg(String strResourcePath, String strFilePath) {
		Map<String, String> hashCodes = new HashMap<String, String>();
		File root = new File(strResourcePath);
		File[] fs = root.listFiles();
		String hashCode = null;
		for (File file : fs) {
			try {
				hashCode = ImageHelper.produceFingerPrint(file.getPath());
			} catch (Exception e) {
				// TODO: handle exception
				continue;
			}
			hashCodes.put(file.getName(), hashCode);
		}

		String sourceHashCode = ImageHelper.produceFingerPrint(strFilePath);
		StringBuffer codes = new StringBuffer();
		for (String key : hashCodes.keySet()) {
			int difference = ImageHelper.hammingDistance(sourceHashCode,hashCodes.get(key));
			System.out.println(difference);
			if (difference <10) {
				String[] names=key.split("_");
				codes.append(names[0]).append(":").append(names[1]).append(",");
			} else {
				continue;
			}
		}
		System.out.println("扫描出的款式号："+codes);
		return codes.toString();
	}

}
