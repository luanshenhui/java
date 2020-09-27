package com.netctoss.util;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;

public class GenEntityOracle {
	
	//*必填
	// 指定实体生成所在包的路径 默认在src下
	private String packageOutPath = "com.netctoss";
	//数据库中的表名
	private String tablename = "service_heyanguang";
	//*选填
	//要创建的实体类的名字 不填 默认为表名
	private String entityName = "Service";
	//要创建的实体类注释中作者的名字 可以不填
	private String authorName = "hyg";
	
	
	private String[] colnames; // 列名数组
	private String[] colTypes; // 列名类型数组
	private int[] colSizes; // 列名大小数组
	private int[] colScale;// 精度
	private boolean f_sql = false; // 是否需要导入包java.sql.*

	public GenEntityOracle() {
		// 创建连接
		Connection con = DBUtil.getConnection();
		// 查要生成实体类的表
		String sql = "select * from " + tablename;
		Statement pStemt=null;
		try {
			pStemt = con.createStatement();
			ResultSet rs = pStemt.executeQuery(sql);
			ResultSetMetaData rsmd = rs.getMetaData();
			int size = rsmd.getColumnCount(); // 统计列
			colnames = new String[size];
			colTypes = new String[size];
			colSizes = new int[size];
			colScale = new int[size];
			for (int i = 0; i < size; i++) {
				colnames[i] = init(rsmd.getColumnName(i + 1).toLowerCase());
				colTypes[i] = init(rsmd.getColumnTypeName(i + 1).toLowerCase());
				colScale[i] = rsmd.getScale(i + 1);

				if (colTypes[i].equalsIgnoreCase("date")
						|| colTypes[i].equalsIgnoreCase("timestamp")) {
					f_sql = true;
				}
				if (colTypes[i].equalsIgnoreCase("blob")
						|| colTypes[i].equalsIgnoreCase("char")) {
					f_sql = true;
				}
				colSizes[i] = rsmd.getColumnDisplaySize(i + 1);
			}		
		} catch (SQLException e1) {
			e1.printStackTrace();
		}finally{
			DBUtil.closeConnection();
		}
		if(entityName == null|| entityName == ""){
			entityName = initcap(tablename);
		}
		String content = parse(colnames, colTypes, colSizes, colScale);

		try {
			File directory = new File("");
			String path = directory.getAbsolutePath() + "/src/"
					+ this.packageOutPath.replace(".", File.separator) + File.separator
					+this.entityName.toLowerCase()+"/entity";
			File file=new File(path);
			if(!file.exists()){
				file.mkdirs();
			}
			File createJava=new File(path+File.separator+ this.entityName + ".java");
			FileWriter fw = new FileWriter(createJava);
			PrintWriter pw = new PrintWriter(fw);
			pw.println(content);
			pw.flush();
			pw.close();
		} catch (final IOException e) {
			e.printStackTrace();
		}

	}

	/**
	 * 功能：生成实体类主体代码
	 * 
	 * @param colnames
	 * @param colTypes
	 * @param colSizes
	 * @return
	 */
	private String parse(String[] colnames, String[] colTypes, int[] colSizes,
			int[] colScale) {
		StringBuffer sb = new StringBuffer();

		sb.append("package " + this.packageOutPath+"."+this.entityName.toLowerCase()
				+".entity"+ ";\r\n");
		// 判断是否导入工具包
		if (f_sql) {
			sb.append("import java.sql.*;\r\n");
		}
		sb.append("\r\n");
		// 注释部分
		sb.append("   /**\r\n");
		sb.append("    * " + tablename + " 实体类\r\n");
		sb.append("    * " + new Date() + " " + this.authorName + "\r\n");
		sb.append("    */ \r\n");
		// 实体部分
		sb.append("\r\n\r\npublic class " + this.entityName + "{\r\n");
		processAllAttrs(sb);// 属性
		processAllMethod(sb);// get set方法
		sb.append("}\r\n");
		return sb.toString();
	}

	/**
	 * 功能：生成所有属性
	 * 
	 * @param sb
	 */
	private void processAllAttrs(StringBuffer sb) {

		for (int i = 0; i < colnames.length; i++) {
			sb.append("\tprivate "
					+ sqlTypeToJavaType(colTypes[i], colScale[i]) + " "
					+ colnames[i] + ";\r\n");
		}

	}

	/**
	 * 功能：生成所有方法
	 * 
	 * @param sb
	 */
	private void processAllMethod(StringBuffer sb) {

		for (int i = 0; i < colnames.length; i++) {
			sb.append("\tpublic void set" + initcap(colnames[i]) + "("
					+ sqlTypeToJavaType(colTypes[i], colScale[i]) + " "
					+ colnames[i] + "){\t\r\n");
			sb.append("\tthis." + colnames[i] + "=" + colnames[i] + ";\r\n");
			sb.append("\t}\r\n");
			sb.append("\tpublic " + sqlTypeToJavaType(colTypes[i], colScale[i])
					+ " get" + initcap(colnames[i]) + "(){\r\n");
			sb.append("\t\treturn " + colnames[i] + ";\r\n");
			sb.append("\t}\r\n");
		}

	}

	/**
	 * 功能：将输入字符串的首字母改成大写
	 * 
	 * @param str
	 * @return
	 */
	private String initcap(String str) {

		char[] ch = str.toCharArray();
		if (ch[0] >= 'a' && ch[0] <= 'z') {
			ch[0] = (char) (ch[0] - 32);
		}

		return new String(ch);
	}

	/**
	 * 功能：将输入字符串的_换成首字母大写
	 * 
	 * @param str
	 * @return
	 */
	private String init(String str) {
		String[] arry = str.split("_");
		String newStr = arry[0];
		for (int i = 1; i < arry.length; i++) {
			newStr += initcap(arry[i]);
		}
		return newStr;
	}

	/**
	 * 功能：获得列的数据类型
	 * 
	 * @param sqlType
	 * @return
	 */
	private String sqlTypeToJavaType(String sqlType, int colScale) {

		if (sqlType.equalsIgnoreCase("binary_double")) {
			return "Double";
		} else if (sqlType.equalsIgnoreCase("binary_float")) {
			return "Float";
		} else if (sqlType.equalsIgnoreCase("blob")) {
			return "byte[]";
		} else if (sqlType.equalsIgnoreCase("blob")) {
			return "byte[]";
		} else if (sqlType.equalsIgnoreCase("char")
				|| sqlType.equalsIgnoreCase("nvarchar2")
				|| sqlType.equalsIgnoreCase("varchar2")) {
			return "String";
		} else if (sqlType.equalsIgnoreCase("date")
				|| sqlType.equalsIgnoreCase("timestamp")
				|| sqlType.equalsIgnoreCase("timestamp with local time zone")
				|| sqlType.equalsIgnoreCase("timestamp with time zone")) {
			return "Date";
		} else if (sqlType.equalsIgnoreCase("number")) {
			if (colScale > 0) {
				return "Double";
			}
			return "Integer";
		}
		return "String";
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		new GenEntityOracle();
	}
}
