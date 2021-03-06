<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/inc/taglib.jsp" %>
<%@ include file="/inc/jsInclude.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增角色</title>
<script type="text/javascript">

function doSub(){
	var rights="";
	<c:forEach items="${listRightsType }" var="rightType" begin="0"> 
		$('input[name="rights_${rightType.typeCode}"]:checked').each(function() {
			rights+=$(this).val()+",";
        });
	</c:forEach>
	$("#rights").val(rights);
	$.ajax({
		cache: true,
		type: "POST",
		url:"${basePath}/admin/role/ifm/add",
		data:$('#roleAdd').serialize(),
		async: false,
	    error: function(request) {
	    	alert("系统错误,请刷新后重试");
	    },
	    success: function(data) {
	    	showMsgParent(data);
	    	window.parent.$('#openWin').window('close');
	    	window.parent.$('#dataTable').datagrid('reload');
	    }
	});
}

function checkRights(name){
	var flag=$("#flag_"+name).val();
	if(flag==1){
		$('input[name="rights_'+name+'"]').each(function() {
			$(this).prop("checked",true);
	    });
		$("#flag_"+name).val("2");
	}else{
		$('input[name="rights_'+name+'"]').each(function() {
			$(this).prop("checked",false);
    	});
		$("#flag_"+name).val("1");
	}
}

</script>
</head>
<body>
	<form id="roleAdd" action="" method="post">
	<input type="hidden" name="rights" id="rights" />
	<div id="tabs" class="easyui-tabs" style="height:400px;" fit=true border=false data-options="" >
		<div title="角色信息" style="padding:30px;height:400px;" fit=true>
			<table width="90%">
				<tr>
					<td height="45px" width="150px">角色名:</td>
					<td><input name="name" id="roleName" data-options="required:true"/></td>
				</tr>
				<tr>
					<td>角色描述:</td>
					<td><textarea name="des" id="roleDes" rows="5" style="width:280px" data-options="required:true"></textarea></td>
				</tr>
				<tr>
					<td height="45px">状态:</td>
					<td>
						<input type="radio" value="1" checked="checked" name="status" data-options="required:true"/>启用
						<input type="radio" value="2" name="status" data-options="required:true"/>停用
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button onclick="doSub()">提交</button>
						<button>重置</button>
					</td>
				</tr>
			</table>	
		</div>
		<div title="授予权限" style="padding:10px">
		<table> 
			<c:forEach items="${listRightsType }" var="rightType" begin="0"> 
			<c:set var="status" value="0"></c:set>
			<tr>
				<td width="50px" valign="top" style="padding-top:16px"><a onclick="checkRights('${rightType.typeCode }')" href="javascript:void(0);">${rightType.name }</a><input type="hidden" id="flag_${rightType.typeCode }" value="1"/></td>
				<td valign="top">
					<table cellpadding="0" cellspacing="0">  
						<tr>
						<c:forEach items="${listRights }" var="right">
							<c:if test="${right.type eq rightType.id }">
								<c:if test="${status!=4}">
									<td width="90px" height="40px"><input name="rights_${rightType.typeCode }" type="checkbox" value="${right.id }"/>${right.name }</td>
								</c:if>	
								<c:if test="${status==4}">
									</tr><tr>
									<td width="90px" height="40px"><input name="rights_${rightType.typeCode }" type="checkbox" value="${right.id }"/>${right.name }</td>
								</c:if> 
								<c:if test="${status==4}">
									<c:set var="status" value="0"></c:set>
								</c:if>
								<c:if test="${status!=4}">
									<c:set var="status" value="${status+1 }"></c:set>
								</c:if>
							</c:if>
						</c:forEach>
						</tr>
					</table>
				</td>
			</tr>
			</c:forEach>
		</table>
		</div>
	</div>
	</form>
</body>
</html>