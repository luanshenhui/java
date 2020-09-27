<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
		<script>
			var selectYear;
			var selectMonth=1;
			//初始化时间
			function init(){
				var year = document.getElementById("year");
				var month = document.getElementById("month");
				var day = document.getElementById("day");
				var hour = document.getElementById("hour");
				var minute = document.getElementById("minute");
				
				var y =new Date().getFullYear();
				for(var i = y+1;i >= 1970;i--){
					year.options[y+1-i] = new Option(i);
				}
				selectYear = year.options[0];
				year.onchange = function(){
					//选中项的索引值
					//alert(this.options.selectedIndex);
					var op = this.options[this.options.selectedIndex];
					selectYear = op.value;
					setDay();
				};
				
				for(var i = 0;i<12;i++){
					month.options[i] = new Option(i+1);
				}
				
				month.onchange = function(){
					var op = this.options[this.options.selectedIndex];
					selectMonth = op.value;
					setDay();
				};
				setDay();
				
				for(var i = 0;i < 24;i++){
					hour.options[i] = new Option(i+1);
				}
				for(var i = 0;i < 60;i++){
					minute.options[i] = new Option(i+1);
				}
			}
			//根据年月设置相应的每月天数
			function setDay(){
				var day = document.getElementById("day");
				var num = 31;
				if(selectMonth == 2){
					if(selectYear%4 == 0 && selectYear%100 !=0){
						num = 29;
					}else{
						num = 28;
					}
				}else if(selectMonth == 1 || selectMonth == 3 || selectMonth == 5 || selectMonth == 7 || selectMonth == 8 || selectMonth == 10 || selectMonth == 12){
					num = 31;
				}else{
					num = 30;
				}
				day.options.length = 0;
				for(var i = 0;i<num;i++){
					day.options[i] = new Option(i+1);
				}
			}
			window.onload = init;
		</script>
				<select id ="year" name="year" ></select>
				年
				<select id="month"  name="year" ></select>
				月
				<select id="day"  name="day" ></select>
				日
				&nbsp;&nbsp;&nbsp;
				<select id="hour"  name="hour" ></select>
				时
				<select id="minute"  name="minute" ></select>
				分
				