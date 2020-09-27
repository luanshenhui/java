<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html xmlns:v= "urn:schemas-microsoft-com:vml">
<head>
<title>工作流流程设置</title>
<!--[if lt IE 9]>
<?import namespace="v" implementation="#default#VML" ?>
<![endif]-->
<meta name="decorator" content="default" />
<dca:resources/>
<link rel="stylesheet" type="text/css" href="${ctxStatic}/jquery-webflow/src/css/webflow.css"/>
<script type="text/javascript" src="${ctxStatic}/jquery-webflow/dist/jquery.modalFloat.js"></script>
<script type="text/javascript" src="${ctxStatic}/jquery-webflow/dist/jquery.webflow.js"></script>
<link rel="stylesheet" type="text/css"  href="/assets/dca/css/dcaWorkflowTaskEditPop.css"> 
<script src="/assets/dca/js/jquery.workflow.task.setting.js" type="text/javascript"></script>
<script src="/assets/dca/js/jquery.workflow.check.js" type="text/javascript"></script>
</head>
<body>
	<!-- 放置流程设置页面 -->
	<div id="workFlowContent" data-flowid="${wfId}">
			
	</div>

<script type="text/javascript">


    $(function () {
    	
    	$('#workFlowContent').webFlow({
    		
    		// 节点设置页面
          	infoUrl: '${ctx}/dca/dcaWorkflowTask/initForm',

            // 实时保存画面url
            saveUrl: "${ctx}/dca/dcaWorkflowTask/saveTask",

            // 初始化拖拽页面的json 
            dataUrl: "${ctx}/dca/dcaWorkflowTask/getContent"
            
    	});


        $('#workFlowContent').webFlow('loadDataAjax');
        //$('#workFlowContent').webFlow('loadData', jsondata);

        $('#submit').click(function () {

            $('#workFlowContent').webFlow('exportData', function (data) {

                $('#result').val(data)

            });

        });

        //改名
        $('#sure').click(function () {

            $('#workFlowContent').trigger('rename', {id: "demo_node_1", name: "yiyi"})

        });

        $('#workFlowContent').webFlow()
        
        	.on('save', function (e, data) {
        		var flag = false;

        		$('#taskConstraint').constraintValidate('checkTask', data, function (data) {

                    flag = data;

                });

                if (flag) {
                	// 保存节点信息
            		var url = '${ctx}/dca/dcaWorkflowTask/saveContent';
            		var param = $("#taskForm").serialize();
            		$.post(url, param, function(result){
            			if(result == "true"){

                			var taskId = $('#taskId').val();
                			var taskName = $('#taskName').val();
                			
                			$('#workFlowContent').trigger('rename', {id: taskId, name: taskName});
                			
                			alertx("保存成功！", function(){
                    			$(data.elm).modalFloat('hide');
                    		});
                			
            			}else{
            				alertx(result);
            			}
            		})
                }
        		
        	})
        	.on('modalshow',function(){
        		$('#taskConstraint').constraintValidate({});
        	});
        
        $('#test').click(function () {

        });
        

    })
	
</script>

</body>
</html>