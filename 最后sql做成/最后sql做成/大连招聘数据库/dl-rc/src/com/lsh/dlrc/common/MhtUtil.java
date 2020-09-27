package com.lsh.dlrc.common;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.Writer;
import java.util.Enumeration;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
public class MhtUtil {



	/**
	 * 转换工具      ----------    �?��引入第三方依�? javaMail转换格式      �? jsoup解析HTML
	 * jsoup  文档地址 ：http://www.open-open.com/jsoup/parse-document-from-string.htm
	 * 将mht 转化�? HTML
	 * @author 隔壁老王
	 *
	 */
	    
	    public static void main(String[] args) throws IOException {
	        /**
	         *  转换
	         */
	        //mht2html("f:\\job_111.mht", "f:\\test.htm");   
	        

	        /**
	         *  获取姓名和�?�?
	         */
	        String nameAndSex = MhtUtil.findResultValue("C://Users/Administrator/Desktop/新建文件�?(15)/1b3-51job_陈晓�?71298945).mht", "li", "info_name");
	        
	        String tmpString = nameAndSex.replaceAll("(?i)[^a-zA-Z0-9\u4E00-\u9FA5]", "");// 去掉�?��中英文符�?
	        char[] carr = tmpString.toCharArray();
	        for (int i = 0; i < tmpString.length(); i++) {
	            if (carr[i] < 0xFF) {
	                carr[i] = ' ';// 过滤掉非汉字内容
	            }
	        }
	        System.out.println(tmpString.substring(0, tmpString.length()-1)); //姓名
	        System.out.println(tmpString.substring(tmpString.length()-1)); //性别
	        
	        /**
	         * 获取教育经历
	         */
	        File htmlf=new File("f:\\test.htm");
	        Document doc=Jsoup.parse(htmlf, "UTF-8"); 
	        String ss=doc.body().toString(); 
	       //class等于masthead的li标签
	        Object[] aa= doc.select("div.detaile_box").toArray();
	        for (int i = 0; i < aa.length; i++) {
	            if(i==3){
	                String strtext = aa[i].toString();
	                Document docs = Jsoup.parse(strtext);
	                Object[] bb= docs.select("b.edu_main_sch").toArray();
	                for (int j = 0; j < bb.length; j++) {
	                    String tt = bb[j].toString();
	                    Document doct = Jsoup.parse(tt);
	                    String result = doct.select("b.edu_main_sch").text();
	                    String a=result.substring(0, result.indexOf("|")).trim();
	                    String b=result.substring(result.lastIndexOf("|")+1, result.length()).trim();
	                    System.out.println(a+"    "+b);  //毕业院校加学�?
	                    
	                }
	            }
	            
	        }
	        
	    }
	    
	    
	    /**
	     * 解析标签  获取标签�?
	     * @param htmlFilePath          文件路径   
	     * @param lableName              标签名称
	     * @param onClassName            标签名称
	     * @return
	     * @throws IOException 
	     */
	    public static String findResultValue(String htmlFilePath , String lableName , String onClassName) throws IOException{
	        File htmlf=new File(htmlFilePath);
	        Document doc=Jsoup.parse(htmlf, "UTF-8");
	        String bodyText=doc.body().toString();  // 获取文件文本信息
	        //class等于onClassName的lableName标签
	        String  resultValue = doc.select(lableName+"."+onClassName).first().text();
	        
	        return resultValue;
	    }
	    
	    /**
	     * 解析标签结果返回多个�?
	     * @param htmlFilePath          文件路径   
	     * @param lableName              标签名称
	     * @param onClassName            标签名称
	     * @return
	     * @throws IOException 
	     */
	    public static Object[]  findResultValueToArray (String htmlFilePath , String lableName , String onClassName) throws IOException{
	        File htmlf=new File(htmlFilePath);
	        Document doc=Jsoup.parse(htmlf, "UTF-8");
	        String bodyText=doc.body().toString();  // 获取文件文本信息
	        return doc.select(lableName+"."+onClassName).toArray();
	    }
	    
	    /**
	     * �?mht文件转换�?html文件
	     * 
	     * @param s_SrcMht      // mht 文件的位�?
	     * @param s_DescHtml    // 转换后输出的HTML的位�?
	     */
	    public static void mht2html(String srcMht, String descHtml) {
	        try {
	            InputStream fis = new FileInputStream(srcMht);
	            Session mailSession = Session.getDefaultInstance(
	                    System.getProperties(), null);
	            MimeMessage msg = new MimeMessage(mailSession, fis);
	            Object content = msg.getContent();
	            if (content instanceof Multipart) {
	                MimeMultipart mp = (MimeMultipart) content;
	                MimeBodyPart bp1 = (MimeBodyPart) mp.getBodyPart(0);
	 
	                // 获取mht文件内容代码的编�?
	                String strEncodng = getEncoding(bp1);
	 
	                // 获取mht文件的内�?
	                String strText = getHtmlText(bp1, strEncodng);
	                if (strText == null)
	                    return;
	 
	                /**
	                 *  创建以mht文件名称的文件夹，主要用来保存资源文件�?  这里不需要所以注释掉�?
	                 */
	/*                File parent = null;
	                if (mp.getCount() > 1) {
	                    parent = new File(new File(descHtml).getAbsolutePath()
	                            + ".files");
	                    parent.mkdirs();
	                    if (!parent.exists()) { // 创建文件夹失败的话则�?��
	                        return;
	                    }
	                }*/
	 
	                /**
	                 *  FOR中代�?主要是保存资源文件及替换路径    这里不需要所以注释掉�?
	                 */
	/*                for (int i = 1; i < mp.getCount(); ++i) {
	                    MimeBodyPart bp = (MimeBodyPart) mp.getBodyPart(i);
	                    // 获取资源文件的路�?
	                    // 例（获取�?http://xxx.com/abc.jpg�?
	                    String strUrl = getResourcesUrl(bp);
	                    if (strUrl == null || strUrl.length() == 0)
	                        continue;
	 
	                    DataHandler dataHandler = bp.getDataHandler();
	                    MimePartDataSource source = (MimePartDataSource) dataHandler
	                            .getDataSource();
	 
	                    // 获取资源文件的绝对路�?
	                    String FilePath = parent.getAbsolutePath() + File.separator
	                            + getName(strUrl, i);
	                    File resources = new File(FilePath);
	 
	                    // 保存资源文件
	                    if (SaveResourcesFile(resources, bp.getInputStream())) {
	                        // 将远程地�?��换为本地地址 如图片�?JS、CSS样式等等
	                        strText = strText.replace(strUrl,
	                                resources.getAbsolutePath());
	                    }
	                }*/
	 
	                // �?��保存HTML文件
//	                SaveHtml(strText, descHtml, strEncodng);
	                SaveHtml(strText, descHtml, "UTF-8");
	                fis.close();
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }finally{
	        	
	        }
	    }
	 
	    /**
	     * 获取mht文件内容中资源文件的名称
	     * 
	     * @param strName
	     * @param ID
	     * @return
	     */
	    public static String getName(String strName, int ID) {
	        char separator1 = '/';
	        char separator2 = '\\';
	        // 将换行替�?
	        strName = strName.replaceAll("\r\n", "");
	 
	        // 获取文件名称
	        if (strName.lastIndexOf(separator1) >= 0) {
	            return strName.substring(strName.lastIndexOf(separator1) + 1);
	        }
	        if (strName.lastIndexOf(separator2) >= 0) {
	            return strName.substring(strName.lastIndexOf(separator2) + 1);
	        }
	        return "";
	    }
	 
	    /**
	     * 将提取出来的html内容写入保存的路径中�?
	     * 
	     * @param strText
	     * @param strHtml
	     * @param strEncodng
	     */
	    public static boolean SaveHtml(String s_HtmlTxt, String s_HtmlPath,
	            String s_Encode) {
	        try {
	            Writer out = null;
	            out = new OutputStreamWriter(
	                    new FileOutputStream(s_HtmlPath, false), s_Encode);
	            out.write(s_HtmlTxt);
	            out.close();
	        } catch (Exception e) {
	            return false;
	        }
	        return true;
	    }
	 
	    /**
	     * 保存网页中的JS、图片�?CSS样式等资源文�?
	     * 
	     * @param SrcFile
	     *            源文�?
	     * @param inputStream
	     *            输入�?
	     * @return
	     */
	    private static boolean SaveResourcesFile(File SrcFile,
	            InputStream inputStream) {
	        if (SrcFile == null || inputStream == null) {
	            return false;
	        }
	 
	        BufferedInputStream in = null;
	        FileOutputStream fio = null;
	        BufferedOutputStream osw = null;
	        try {
	            in = new BufferedInputStream(inputStream);
	            fio = new FileOutputStream(SrcFile);
	            osw = new BufferedOutputStream(new DataOutputStream(fio));
	            int index = 0;
	            byte[] a = new byte[1024];
	            while ((index = in.read(a)) != -1) {
	                osw.write(a, 0, index);
	            }
	            osw.flush();
	            return true;
	        } catch (Exception e) {
	            e.printStackTrace();
	            return false;
	        } finally {
	            try {
	                if (osw != null)
	                    osw.close();
	                if (fio != null)
	                    fio.close();
	                if (in != null)
	                    in.close();
	                if (inputStream != null)
	                    inputStream.close();
	            } catch (Exception e) {
	                e.printStackTrace();
	                return false;
	            }
	        }
	    }
	 
	    /**
	     * 获取mht文件里资源文件的URL路径
	     * 
	     * @param bp
	     * @return
	     */
	    private static String getResourcesUrl(MimeBodyPart bp) {
	        if (bp == null) {
	            return null;
	        }
	        try {
	            Enumeration list = bp.getAllHeaders();
	            while (list.hasMoreElements()) {
	                javax.mail.Header head = (javax.mail.Header) list.nextElement();
	                if (head.getName().compareTo("Content-Location") == 0) {
	                    return head.getValue();
	                }
	            }
	            return null;
	        } catch (MessagingException e) {
	            return null;
	        }
	    }
	 
	    /**
	     * 获取mht文件中的内容代码
	     * 
	     * @param bp
	     * @param strEncoding
	     *            该mht文件的编�?
	     * @return
	     */
	    private static String getHtmlText(MimeBodyPart bp, String strEncoding) {
	        InputStream textStream = null;
	        BufferedInputStream buff = null;
	        BufferedReader br = null;
	        Reader r = null;
	        try {
	            textStream = bp.getInputStream();
	            buff = new BufferedInputStream(textStream);
	            r = new InputStreamReader(buff, strEncoding);
	            br = new BufferedReader(r);
	            StringBuffer strHtml = new StringBuffer("");
	            String strLine = null;
	            while ((strLine = br.readLine()) != null) {
//	                System.out.println(strLine);
	                strHtml.append(strLine + "\r\n");
	            }
	            br.close();
	            r.close();
	            textStream.close();
	            return strHtml.toString();
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            try {
	                if (br != null)
	                    br.close();
	                if (buff != null)
	                    buff.close();
	                if (textStream != null)
	                    textStream.close();
	            } catch (Exception e) {
	            }
	        }
	        return null;
	    }
	 
	    /**
	     * 获取mht网页文件中内容代码的编码
	     * 
	     * @param bp
	     * @return
	     */
	    private static String getEncoding(MimeBodyPart bp) {
	        if (bp == null) {
	            return null;
	        }
	        try {
	            Enumeration list = bp.getAllHeaders();
	            while (list.hasMoreElements()) {
	                javax.mail.Header head = (javax.mail.Header) list.nextElement();
	                if (head.getName().equalsIgnoreCase("Content-Type")) {
	                    String strType = head.getValue();
	                    int pos = strType.indexOf("charset=");
	                    if (pos >= 0) {
	                        String strEncoding = strType.substring(pos + 8,
	                                strType.length());
	                        if (strEncoding.startsWith("\"")
	                                || strEncoding.startsWith("\'")) {
	                            strEncoding = strEncoding.substring(1,
	                                    strEncoding.length());
	                        }
	                        if (strEncoding.endsWith("\"")
	                                || strEncoding.endsWith("\'")) {
	                            strEncoding = strEncoding.substring(0,
	                                    strEncoding.length() - 1);
	                        }
	                        if (strEncoding.toLowerCase().compareTo("gb2312") == 0) {
	                            strEncoding = "gbk";
	                        }
	                        return strEncoding;
	                    }
	                }
	            }
	        } catch (MessagingException e) {
	            e.printStackTrace();
	        }
	        return null;
	    }
	    
	    /**
	     * 删除指定文件
	     * @param filePath  文件路径 
	     * @param fileName  文件名称
	     * @param layout    文件格式 
	     */
	    public static void deleteFileName(String filePath , String fileName , String layout){
	        
	        File folder = new File(filePath);
	        String fileNameOnLayout=fileName+"."+layout;
	        File[] files = folder.listFiles(); //获取该文件夹下的�?��文件
	        for(File file:files){              
	            if(file.getName().equals(fileNameOnLayout)){
	                file.delete();
	            }
	        }
	        
	    }

	}