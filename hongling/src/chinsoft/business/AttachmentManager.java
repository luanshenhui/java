package chinsoft.business;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.time.DateFormatUtils;

import chinsoft.core.DataAccessObject;
import chinsoft.core.HttpContext;
import chinsoft.core.Utility;
import chinsoft.entity.Attachment;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.FileRenamePolicy;


public class AttachmentManager{
	DataAccessObject dao = new DataAccessObject();
	private static String RootDir = "upload/";
	private static String VirtualDir = DateFormatUtils.format(new java.util.Date(), "yy"  + "MM" + "/" + "dd" + "/");
	private int fileSizeLimit = 500 * 1024 * 1024;
	private File oldFile;
	
	private String GetWebUrl(Attachment attachment)
    {
        return "../../" + RootDir + attachment.getFileNameInDisk();
    }
    
    private String GetRealPath(){
    	return ((HttpSession) HttpContext.CurrentSession.get()).getServletContext().getRealPath("/" + RootDir + VirtualDir);
    }
    
	public List<Attachment> getAttachmentByIDs(String strIDs)
    {
    	List<Attachment> attachments = new ArrayList<Attachment>();
    	String[] arrayIDs = Utility.getStrArray(strIDs);
    	for(String id :arrayIDs){
    		Attachment attachment = getAttachmentByID(id);
    		if(attachment != null){
    			attachments.add(attachment);
    		}
    	}
        return attachments;
    }

	public String GetAttachmentNames(String strIDs)
    {
		String strNames = "";
        try {
            if (strIDs != null && !"".equals(strIDs))
            {
                List<Attachment> attachments = this.getAttachmentByIDs(strIDs);
                for(Attachment attachment :attachments){
                    strNames += "<a target=_blank class=download href=" + this.GetWebUrl(attachment) + ">" + attachment.getFileName() + "</a> ";
                }
            }
        }
        catch (Exception e) {
        }
        return strNames;
    }

	class UploadRenamePolicy implements FileRenamePolicy {
		@Override
		public File rename(File file) {
			oldFile = file;
			String newFileName = UUID.randomUUID().toString() +  "." + FilenameUtils.getExtension(file.getName());
			return new File(file.getParentFile(), newFileName);
		}
	}

    @SuppressWarnings("null")
	public Attachment saveAttachment(HttpServletRequest request){
		File path = new File(GetRealPath());
		if (!path.exists()) {
			path.mkdirs();
		}
		MultipartRequest multi = null;
		File file = null;
		try {
			multi = new MultipartRequest(request, GetRealPath(), fileSizeLimit, "UTF-8", new UploadRenamePolicy());
			String strVirtualDirFile = "";
			String contentType = "";
			Enumeration<?> files = multi.getFileNames();
			while (files.hasMoreElements()) {
				String name = (String) files.nextElement();
				file = multi.getFile(name);
				contentType =  multi.getContentType(name);
				strVirtualDirFile = VirtualDir +  multi.getFilesystemName(name);
			}
			String oldFileName = oldFile.getName();
			Attachment attachment = new Attachment();
			attachment.setFileName(oldFileName);
			attachment.setMemberID("1");
			attachment.setContentType(contentType);
			attachment.setDescription(oldFile.getName());
			attachment.setFileLength(file.length());
			attachment.setFileNameInDisk(strVirtualDirFile);
			attachment.setNeedWaterMark(1);
			dao.saveOrUpdate(attachment);
	        return attachment;
		} catch (IOException e) {
			file.delete();
			return null;
		}
    }
 
    //根据ID查询附件
    public Attachment getAttachmentByID(String strAttachmentID)
    {
        return (Attachment)dao.getEntityByID(Attachment.class, strAttachmentID);
    }

    //删除
    public void removeAttachmentByID(String strAttachmentID, String filePath)
    {
        dao.remove(Attachment.class, strAttachmentID);
        File file = new File(((HttpSession) HttpContext.CurrentSession.get()).getServletContext().getRealPath("/" + RootDir + filePath));
		if(file.exists()){
			file.delete();
		}
    }
}