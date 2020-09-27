package rcmtm.business;

import java.io.File;
import java.util.UUID;

import javax.ws.rs.core.Response;

//import org.im4java.core.ConvertCmd;
//import org.im4java.core.IMOperation;

/**
* <p>Title: ImageMagick.java</p>
* <p>Description: </p>
* <p>Copyright: Copyright (c) 2013</p>
* <p>Company: RCOLLAR</p>
* @author <a href="mailto:fanjinhu@gmail.com">fjh</a>
* @date 2013-12-13
* @version 1.0
 */
public class ImageMagick {
	
//	public String composite(String basePath, String layers, String sessionId) {
//		try {
////			String destDir = request.getSession().getServletContext().getRealPath("") + File.separatorChar + "dest";
//			String destDir = new File(basePath).getPath() + File.separatorChar + "dest" + File.separatorChar + sessionId;
//			File f = new File(destDir);
//			if (!f.exists()) {
//				f.mkdir();
//			}
//			String uuid = UUID.randomUUID().toString().replace("-", "");
//			
//			String imageMagickPath = "D:/Program Files/ImageMagick-6.8.7-Q16";
//			
//			String[] imgs = layers.split(",");
//			
//			IMOperation op = new IMOperation();
//			op.addImage(imgs[0]);
//			for (int i = 1; i < imgs.length; i++) {
//				op.addImage(imgs[i]);
//				op.composite();
//			}
//			op.addImage(destDir + File.separatorChar + uuid + ".png");
//			
//			ConvertCmd convert = new ConvertCmd();
//			convert.setSearchPath(imageMagickPath);
//			convert.run(op);
//		} catch (Exception e) {
//			e.printStackTrace();
//			return null;
//		}
//		
//		return "../../dest/sessionid/uuid.png";
//	}
}
