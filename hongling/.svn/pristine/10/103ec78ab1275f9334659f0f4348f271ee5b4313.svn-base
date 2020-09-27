package rcmtm.synchronousOrden;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import chinsoft.core.LogPrinter;
import chinsoft.service.core.Encryption;

public class SendOrden {
	@SuppressWarnings("static-access")
	public String readContentFromPost(String interfaceUrl, String para){
		try {
			// Post请求的url，与get不同的是不需要带参数
			URL postUrl = new URL(interfaceUrl);
			// 打开连接
			HttpURLConnection connection = (HttpURLConnection) postUrl
					.openConnection();
			// 设置是否向connection输出，因为这个是post请求，参数要放在
			// http正文内，因此需要设为true
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setRequestMethod("POST");
			// Post 请求不能使用缓存
			connection.setUseCaches(false);
			// URLConnection.setFollowRedirects是static函数，作用于所有的URLConnection对象。
			// connection.setFollowRedirects(true);
			// URLConnection.setInstanceFollowRedirects是成员函数，仅作用于当前函数
			connection.setInstanceFollowRedirects(true);
			// Set the content type to urlencoded,
			// because we will write
			// some URL-encoded content to the
			// connection. Settings above must be set before connect!
			// 配置本次连接的Content-type，配置为application/x-www-form-urlencoded的
			// 意思是正文是urlencoded编码过的form参数，下面我们可以看到我们对正文内容使用URLEncoder.encode
			// 进行编码
			connection.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			// 连接，从postUrl.openConnection()至此的配置必须要在connect之前完成，
			// 要注意的是connection.getOutputStream会隐含的进行connect。
			connection.connect();

			DataOutputStream out = new DataOutputStream(
					connection.getOutputStream());

			// The URL-encoded contend
			// 正文，正文内容其实跟get的URL中'?'后的参数字符串一致
			String mi = Encryption.encrypt(para, "RC000001");
			String content = "encryptionJsonStr=" + URLEncoder.encode(mi, "utf-8");
			// DataOutputStream.writeBytes将字符串中的16位的unicode字符以8位的字符形式写道流里面
			out.writeBytes(content);
			out.flush();
			out.close(); // flush and close

			BufferedReader reader = new BufferedReader(new InputStreamReader(
					connection.getInputStream()));
			StringBuffer backJsonBuffer = new StringBuffer();
			String inputLine;
			while ((inputLine = reader.readLine()) != null) {
				backJsonBuffer.append(inputLine);
			}
			reader.close();
			connection.disconnect();
			return backJsonBuffer.toString();
		} catch (Exception e) {
			LogPrinter.info("发送数据的网络异常");
			return "";
		}
	}
}
