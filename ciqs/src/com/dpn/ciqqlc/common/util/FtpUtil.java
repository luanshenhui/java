package com.dpn.ciqqlc.common.util;
import sun.net.ftp.FtpClient;
import sun.net.ftp.FtpProtocolException;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;   
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;

import com.dpn.ciqqlc.standard.model.EfpeApplyCommentFileDto;
 
 
public class FtpUtil {
	  FtpClient ftpClient;
	 
	
	    public static FtpClient connectFTP(String url, int port, String username, String password) {  
	        FtpClient ftp = null;  
	        try {  
	            SocketAddress addr = new InetSocketAddress(url, port);  
	            ftp = FtpClient.create();  
	            ftp.connect(addr);  
	            ftp.login(username, password.toCharArray());  
	            ftp.setBinaryType();  
	        } catch (FtpProtocolException e) {  
	            e.printStackTrace();  
	        } catch (IOException e) {  
	            e.printStackTrace();  
	        }  
	        return ftp;  
	    }  
	    
	    
	    
	    public static List<String> download(String ftpFile, FtpClient ftp) {  
	        List<String> list = new ArrayList<String>();
	        String str = "";
	        InputStream is = null; 
	        BufferedReader br = null;
	        try {
	            is = ftp.getFileStream(ftpFile);
	            br = new BufferedReader(new InputStreamReader(is));
	            while((str=br.readLine())!=null){
	                list.add(str);
	            }
	            br.close();
	        }catch (FtpProtocolException e) {
	            e.printStackTrace();
	        } catch (FileNotFoundException e) {
	            e.printStackTrace();
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	        return list;
	    }  
	    
	    public static boolean downloadFile(String hostname, int port, String username, String password, String pathname, String filename, String localpath, String newFileName, String year,String month) throws IOException{
	        boolean flag = false;
	        FTPClient ftpClient = new FTPClient();
	        String fileSaveMonth = Constants.UP_LOAD_P+"/"+year;//附件保存月目录
			if(!(new File(fileSaveMonth).isDirectory())){
				new File(fileSaveMonth).mkdir();
			}
			String fileSaveContents = Constants.UP_LOAD_P+"/"+year+"/"+month;//附件保存日目录
			if(!(new File(fileSaveContents).isDirectory())){
				new File(fileSaveContents).mkdir();
			}
	        try {
	          ftpClient.connect(hostname, port);
	          ftpClient.login(username, password);
	          int replyCode = ftpClient.getReplyCode();
	          if(!FTPReply.isPositiveCompletion(replyCode)){
	            return flag;
	          }
	          ftpClient.changeWorkingDirectory(pathname);
	          FTPFile[] ftpFiles = ftpClient.listFiles();
	          for(FTPFile file : ftpFiles){
//	        	System.out.println(file.getName());
	            if(filename.equalsIgnoreCase(file.getName())){
//	              File localFile = new File(localpath + "/" + file.getName());
	            	 File localFile = new File(localpath + "/" + newFileName);
	              OutputStream os = new FileOutputStream(localFile);
	              ftpClient.retrieveFile(file.getName(), os);
	              os.close();
	              flag = true;
	            }
	          }
	          ftpClient.logout();
	        } catch (Exception e) {
	          e.printStackTrace();
	        } finally{
	          if(ftpClient.isConnected()){
	            try {
	              ftpClient.logout();
	            } catch (IOException e) {
	              
	            }
	          }
	        }
	        return flag;
	      }
	    
}
