package com.yulin.exam;
import java.io.*;

public class ExamUtil {
	public static Question[] questionUtil(String path) throws IOException{	//TODO Question[]
		File file = new File(path);
		BufferedReader br = new BufferedReader(new FileReader(file));
		Question[] qs = new Question[10];
		int 题号 = 0;
		while(br.ready()){
			String str = br.readLine();
			if(str.startsWith("@1")){
				String[] ss = str.split("#");	//基本切分				//Integer.parseInt(ss[3])//把字符串变成整型
				FillingQuestion fq = new FillingQuestion(ss[1],ss[2],Integer.parseInt(ss[3]));//创建一个填空题的对象 ,
				fq.set题号(题号);
				qs[题号++] = fq;//提好对应数组的下标
			}else if(str.startsWith("@2")){
				String[] ss = str.split("#");	//基本切分
				String[] options = ss[2].split(",");	//选项切分
				SelectQuestion sq = new SelectQuestion(ss[1],options,ss[3],Integer.parseInt(ss[4]));//创建一个选择题对象
				sq.set题号(题号);
				qs[题号++] = sq;
			}
		}
		return qs;
	}
	public static void userWriter(String path){
		
	}
	public static void userReader(String path){		//TODO User

	}
	
	public static void main(String[] args){
		Question[] qs;
		try {
			qs = ExamUtil.questionUtil("src/com/yulin/exam/exam.txt");
			for(Question q : qs){
				q.显示();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
