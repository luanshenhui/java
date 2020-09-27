package com.test;

import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.Setter;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.formula.functions.T;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Nullable;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context.xml")
//@ActiveProfiles("dev")
public class TestUser {
//	@Resource
//	private UserService iuUserService;
//	private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Test
	public void test() {
//		Object obj = iuUserService.login(new LoginInfo());
//		String str = jsonMapper.toJson(obj);
//
//			StringBuilder strPattern = new StringBuilder("");
//
//		strPattern.delete(0, StringUtils.length(strPattern));
//		strPattern.append(".*:");
//		strPattern.append("post");
//		strPattern.append("|.*");
//			Pattern pattern = Pattern.compile(strPattern.toString());
//
////		if (pattern.matcher("/api/admin/attribute").matches()) {
//     if (pattern.matcher("|新增-保存:attribute_add:post1|").matches()) {
//			System.out.println("a");
//		}
//		try {
//			unzip("C:\\Users\\11150321040174\\Desktop\\a.zip", "C:\\Users\\11150321040174\\Desktop\\2", true);
//		}
//		catch (Exception ex) {
//			System.out.println(ex.getMessage());
//		}
		List<AModel> list1 = Lists.newArrayList();
		AModel a1 =  new AModel();
		a1.setACode("a");
		list1.add(a1);
		AModel a2=  new AModel();
		a2.setACode("b");
		list1.add(a2);
		List<BModel> list2 = Lists.newArrayList();
		BModel b1 =  new BModel();
		b1.setBCode("c");
		list2.add(b1);
		BModel b2=  new BModel();
		b2.setBCode("a");
		list2.add(b2);


		final List<String> ids = Lists.transform(list2, new Function<BModel, String>() {
			@Nullable
			@Override
			public String apply(@Nullable BModel input) {
				return input.getBCode();
			}
		});
		System.out.println(list1.size());
		Collection<AModel> myEnables = Collections2.filter(list1, new Predicate<AModel>() {
			@Override
			public boolean apply(@Nullable AModel CouponInfModel) {
				return ids.contains(CouponInfModel.getACode());
			}
		});
		System.out.println(myEnables.size());
	}

	public class AModel implements Serializable {
		@Getter
		@Setter
		private String aCode;
		@Getter
		@Setter
		private Long buyCounta;
	}
	public class BModel implements Serializable {
		@Getter
		@Setter
		private String bCode;
		@Getter
		@Setter
		private Long buyCountb;
	}
	/**
	 * 解压缩zip包
	 * @param zipFilePath zip文件的全路径
	 * @param unzipFilePath 解压后的文件保存的路径
	 * @param includeZipFileName 解压后的文件保存的路径是否包含压缩文件的文件名。true-包含；false-不包含
	 */
	@SuppressWarnings("unchecked")
	public static void unzip(String zipFilePath, String unzipFilePath, boolean includeZipFileName) throws Exception
	{
		if (StringUtils.isEmpty(zipFilePath) || StringUtils.isEmpty(unzipFilePath))
		{
			throw new Exception("aaaaaa");
		}
		File zipFile = new File(zipFilePath);
		//如果解压后的文件保存路径包含压缩文件的文件名，则追加该文件名到解压路径
		if (includeZipFileName)
		{
			String fileName = zipFile.getName();
			if (StringUtils.isNotEmpty(fileName))
			{
				fileName = fileName.substring(0, fileName.lastIndexOf("."));
			}
			unzipFilePath = unzipFilePath + File.separator + fileName;
		}
		//创建解压缩文件保存的路径
		File unzipFileDir = new File(unzipFilePath);
		if (!unzipFileDir.exists() || !unzipFileDir.isDirectory())
		{
			unzipFileDir.mkdirs();
		}

		//开始解压
		ZipEntry entry = null;
		String entryFilePath = null, entryDirPath = null;
		File entryFile = null, entryDir = null;
		int index = 0, count = 0, bufferSize = 1024;
		byte[] buffer = new byte[bufferSize];
		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
		ZipFile zip = new ZipFile(zipFile);
		Enumeration<ZipEntry> entries = (Enumeration<ZipEntry>)zip.entries();
		//循环对压缩包里的每一个文件进行解压
		while(entries.hasMoreElements())
		{
			entry = entries.nextElement();
			entryFilePath = unzipFilePath + File.separator + entry.getName();

//			//构建解压后保存的文件夹路径
//			index = entryFilePath.lastIndexOf(File.separator);
//			if (index != -1) {
//				entryDirPath = entryFilePath.substring(0, index);
//			} else {
//				entryDirPath = "";
//			}
//			entryDir = new File(entryDirPath);
//			//如果文件夹路径不存在，则创建文件夹
//			if (!entryDir.exists() || !entryDir.isDirectory()) {
//				entryDir.mkdirs();
//			}
			//构建压缩包中一个文件解压后保存的文件全路径
			if (entry.isDirectory() || entry.getName().indexOf(".") < 0) {
				entryDir = new File(entryFilePath);
				if (!entryDir.exists() || !entryDir.isDirectory()) {
					entryDir.mkdirs();
				}
			}
			else if (entry.getName().indexOf(".") > 0){
//				entryDir = new File(entryFilePath);
				//创建解压文件
				entryFile = new File(entryFilePath);
				if (entryFile.exists()) {
					//检测文件是否允许删除，如果不允许删除，将会抛出SecurityException
					SecurityManager securityManager = new SecurityManager();
					securityManager.checkDelete(entryFilePath);
					//删除已存在的目标文件
					entryFile.delete();
				}

				//写入文件
				bos = new BufferedOutputStream(new FileOutputStream(entryFile));
				bis = new BufferedInputStream(zip.getInputStream(entry));
				while ((count = bis.read(buffer, 0, bufferSize)) != -1) {
					bos.write(buffer, 0, count);
				}
				bos.flush();
				bos.close();
			}
		}
	}

	private void getSameRecord(Map<String, List<T>> map, String[][] strKeyRelations) {
		List<Integer> a = new ArrayList<Integer>(3);
		a.add(1);
		a.add(2);
		a.add(3);
		List<Integer> b = new ArrayList<Integer>(3);
		b.add(2);
		b.add(3);
		b.add(4);
		List<Integer> c = new ArrayList<Integer>(3);
		c.add(3);
		c.add(4);
		c.add(5);
		int indexa;
		int indexb = 0;
		int indexc = 0;
		int indexMaxa = a.size();
		int indexMaxb = b.size();
		int indexMaxc = c.size();
		for(indexa = 0; indexa < indexMaxa;  indexa ++) {
			if(indexMaxb < 0 || indexc < 0) {
				if(indexMaxb < 0 ) {
					for(int i = indexa; i < indexMaxa;  i ++) {
						a.remove(i);
					}
					for(int i = indexc; i < indexMaxc;  i ++) {
						c.remove(i);
					}
				}
				if(indexMaxc < 0) {
					for(int i = indexa; i < indexMaxa;  i ++) {
						a.remove(i);
					}
					for(int i = indexb; i < indexMaxb;  i ++) {
						b.remove(i);
					}
				}
				break;
			}
			if (a.get(indexa) == b.get(indexb) && a.get(indexa) == c.get(indexc)) {
				indexb = indexb + 1;
				indexc = indexc + 1;
				continue;
			}
			else if (a.get(indexa) != b.get(indexb)) {
				while (a.get(indexa)  > b.get(indexb) && indexb < indexMaxb) {
					b.remove(indexb);
					indexMaxb--;
				}
			}
			else if (a.get(indexa) != c.get(indexb)) {
				while (a.get(indexa)  > c.get(indexc)) {
					c.remove(indexc);
					indexMaxc--;
				}
			}

		}
	}

	private void testReadWrite() {

		FileOutputStream out = null;

		FileOutputStream outSTr = null;

		BufferedOutputStream Buff=null;

		FileWriter fw = null;

		int count=1000;//写文件行数

		try {

//			FileInputStream xxxx = new FileInputStream(new File("C:/add.txt"));
//			InputStreamReader isr = new InputStreamReader(xxxx);
//
			out = new FileOutputStream(new File("C:/add.txt"));

			long begin = System.currentTimeMillis();

			for (int i = 0; i < count; i++) {

				out.write("测试java 文件操作\r\n".getBytes());


			}

			out.close();

			long end = System.currentTimeMillis();

			System.out.println("FileOutputStream执行耗时:" + (end - begin) + " 豪秒");

			outSTr = new FileOutputStream(new File("C:/add0.txt"));

			Buff=new BufferedOutputStream(outSTr);

			long begin0 = System.currentTimeMillis();

			for (int i = 0; i < count; i++) {

				Buff.write("测试java 文件操作\r\n".getBytes());

			}

			Buff.flush();

			Buff.close();

			long end0 = System.currentTimeMillis();

			System.out.println("BufferedOutputStream执行耗时:" + (end0 - begin0) + " 豪秒");

			fw = new FileWriter("C:/add2.txt");

			long begin3 = System.currentTimeMillis();

			for (int i = 0; i < count; i++) {

				fw.write("测试java 文件操作\r\n");

			}

			fw.close();

			long end3 = System.currentTimeMillis();

			System.out.println("FileWriter执行耗时:" + (end3 - begin3) + " 豪秒");

		} catch (Exception e) {

			e.printStackTrace();

		}

		finally {

			try {

				fw.close();

				Buff.close();

				outSTr.close();

				out.close();

			} catch (Exception e) {

				e.printStackTrace();

			}

		}

	}

	// end
}
