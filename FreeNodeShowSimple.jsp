<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="freeWorkflowSimple" class="weaver.workflow.workflow.FreeWorkflowSimple" scope="page"></jsp:useBean>

<%
	freeWorkflowSimple.setWorkflowid(workflowid);
	freeWorkflowSimple.setNodeid(nodeid);
	freeWorkflowSimple.setRequestid(requestid);
	freeWorkflowSimple.setUser(user);
	freeWorkflowSimple.setIsset(isset);
	Map<String,Object> nodesMap = freeWorkflowSimple.getNodes();
	//得到节点的配置信息，包括
	Map<String,Object> configInfo = freeWorkflowSimple.getConfigInfo();
	nodesMap.putAll(configInfo);
	
	String freenodeid = Util.null2String(configInfo.get("nodeid"));
	String freenodename = Util.null2String(configInfo.get("nodename"));
	String road = Util.null2String(configInfo.get("road"));   //路径编辑权限
	String frms = Util.null2String(configInfo.get("frms"));   //表单编辑权限
	String trust = Util.null2String(configInfo.get("trust"));   //表单签章权限
	String nodeDo = Util.null2String(configInfo.get("nodeDo"));   //转发，强制收回，强制归档权限
	
	String _iscreate = Util.null2String(configInfo.get("iscreate"));   //是否是创建节点
	
	if(isset != 1){   //不是设置页面，因为空间比较充足，不需要放大坐标
		nodesMap.put("coordinaterate",1.1);
	}
	
	nodesMap.put("languageid",user.getLanguage());
	
	JSONObject jsonObject = JSONObject.fromObject(nodesMap);
%>
<link href="/css/ecology8/request/freeWorkflowSimple_wev8.css" type="text/css" rel="STYLESHEET">
<div id="content">
	<%if("true".equals(_iscreate)){%>
	<table id="rolltab"  style="width: 100%;top: 10px;position: fixed;left:0px;">
		<tr>
			<td style="width: 100%;text-align: center;">
				<div class="switch" style="display:inline-block;">
					<div class="leftdiv"><%=SystemEnv.getHtmlLabelName(129276,user.getLanguage())%></div>
					<div class="rightdiv"><%=SystemEnv.getHtmlLabelName(129275,user.getLanguage())%></div>
					<div class="rolldiv" style="display: block;"></div>
				</div>
			</td>
		</tr>
	</table>
	<%}%>
	<div id="dialog-overlay" style="display: none;"></div> 
	<!-- 操作者信息展示 Start -->
	<div id="dialog-box" style="display: none;z-index: 1"> 
		<div id="msgTitle">
			<div id="msgtleblockleft"></div>
			<div id="msgtleblockright"></div>
			<div id="msgtleblockcenter">
                   <%=SystemEnv.getHtmlLabelName(99,user.getLanguage()) %>
			</div>
		</div>
		<div id="msgblock"> 
			<div id="dialog-message" style="margin-left:5px;margin-right:5px;"></div> 
		</div> 
	</div> 
	
	<%--存放自由流程信息 --%>
	<div id="workflowPictureInfo">
		<input type="hidden" name="rownum" id="rownum" value="1" >
		<input type="hidden" name="indexnum" id="indexnum" value="2" >
		<%-- 
		<input type="hidden" name="checkfield" id="checkfield" value="" >
		--%>
		<input type="hidden" name="freeNode" id="freeNode" value="1" >
		<input type="hidden" name="freeDuty" id="freeDuty" value="1" >
		<input type="hidden" name="floworder_1" id="floworder_1" value="1" >
		<input type="hidden" name="nodeid_1" id="nodeid_1" value="<%=freenodeid%>" >
		<input type="hidden" name="nodename_1" id="nodename_1" value="<%=freenodename%>" >
		<input type="hidden" name="nodetype_1" id="nodetype_1" value="1" >
		<input type="hidden" name="Signtype_1" id="Signtype_1" value="" >
		<input type="hidden" name="operators_1" id="operators_1" value="" >
		<input type="hidden" name="operatornames_1" id="operatornames_1" value="">
		<input type="hidden" name="road_1" id="road_1" value="<%=road%>" >
		<input type="hidden" name="frms_1" id="frms_1" value="<%=frms%>" >
		<input type="hidden" name="trust_1" id="trust_1" value="<%=trust%>" >
		<input type="hidden" name="nodeDo_1" id="nodeDo_1" value="<%=nodeDo%>" >
	</div>
	
	<%--流程图内容区域 --%>
	<div id="picturescroll" style="overflow:hidden;">
		<div id="picturecontent">
		</div>
	</div>
	
	<%--提示信息 --%>
	<%if("true".equals(_iscreate)){%>
	<div class="tips">
		<span><%=SystemEnv.getHtmlLabelName(129348,user.getLanguage())%></span>
		<span style="padding: 0 5px;"><img style="width:40px;height: 40px;" src="/workflow/design/bin-debug/assets/images/freeedit_wev8.png"/></span>
		<span><%=SystemEnv.getHtmlLabelName(129349,user.getLanguage())%></span>
	</div>
	<%}%>
</div>
<!--[if IE]>
    <script type="text/javascript" src="/workflow/design/js/html5.js"></script>
    <script type="text/javascript" src="/workflow/design/js/excanvas.compiled.js"></script>
<![endif]-->
<script type="text/javascript" language="javascript" src="/js/ecology8/request/freeWorkflowSimple_wev8.js"></script>

<script type="text/javascript" language="javascript" >
var options = <%=jsonObject%>;
var isset = <%=isset%>;
var isdialog = <%=isdialog%>;
var iscreate = <%=_iscreate%>;

document.oncontextmenu = function(){return false};   //屏蔽右键菜单
var $instance = null;
<%if("1".equals(isdialog)){%>
var parentWin = window.top.freewindow;
var parentDiv = jQuery(".freeNode", window.top.freewindow.document);   //父窗口，存放自由流程信息的div
<%}%>
jQuery(document).ready(function(){
	resizeContainer();

	jQuery(document.body).bind("click", function () {
		jQuery("#dialog-box, #dialog-overlay").css("display", "none");
	});

	//阻止事件冒泡，点击窗口中的人员信息时，窗口不会自动关闭
	jQuery("#dialog-box, #dialog-overlay").bind("click",function(evt){
		var evt = evt ? evt : event;
		if(evt.stopPropagation){
			evt.stopPropagation();
		}else{
			window.event.cancelBubble = true; 
		}
	});
	
	if(iscreate == "true" || iscreate){
		var $freeWorkflowOptions = parentWin.$freeWorkflowOptions;
		if(!!$freeWorkflowOptions){   //说明是设置过流程图，缓存在父页面
			$instance = new FreeWorkflowSimplePicture("#picturecontent",$freeWorkflowOptions);
		}else{        //没有设置过，初始化
			$instance = new FreeWorkflowSimplePicture("#picturecontent",options);
		}
	}else{
		$instance = new FreeWorkflowSimplePicture("#picturecontent",options);
	}
	$instance.draw();

	//窗口大小变动，重新绘制流程图
	jQuery(window).resize(function(){
		resizeContainer();
		$instance.redraw();
		jQuery("#dialog-box, #dialog-overlay").hide();
	});
	
	if(iscreate == "true" || iscreate){
		var $atype = $instance.getSigntype();
		changeButton($atype);
		
		//依次逐个处理、同时处理的开发切换
		jQuery(".switch").unbind("click").bind("click",function(){
			var signtype = $instance.getSigntype();
			if(signtype == 2 ){   //当前是会签
				jQuery(".rolldiv").animate({ 
					left: 69
				}, 2,null,function() {
					jQuery(".rightdiv").css("color","#ffffff");
				}); 
				jQuery(".leftdiv").css("color","#8a9fad");
				$instance.setSigntype(1);    //转为依次逐个处理
			}else{    //当前是依次逐个处理
				jQuery(".rolldiv").animate({ 
					left: 0
				}, 2,null,function() {
					jQuery(".leftdiv").css("color","#ffffff");
				}); 
				jQuery(".rightdiv").css("color","#8a9fad");
				$instance.setSigntype(2);    //转为会签
			}
			$instance.redraw();
		});
	}
	jQuery("#picturescroll").perfectScrollbar();
});

/**
 * 新建、归档节点点击时弹出框的内容
 */
var getShowMessage = function (nodebase) {
	var rhtml = "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"200px\">";
	if (nodebase.nodeOptType == 1) {
		rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
		rhtml += "<img src=\"/mobile/plugin/1/images/imgPersonHead_wev8.png\" title=\"<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>\">";
		rhtml += "&nbsp;" + nodebase.nodeNotOperatorNames;
		rhtml += "</td></tr>";

		if(nodebase.nodetype == 0 || nodebase.nodetype == 3){
			rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
			rhtml += "<img src=\"/mobile/plugin/1/images/icon_resource_wev8.png\" title=\"<%=SystemEnv.getHtmlLabelName(16355,user.getLanguage())%>\">";
			rhtml += "&nbsp;" + nodebase.nodeViewNames;
			rhtml += "</td></tr>";
			
			rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
			rhtml += "<img src=\"/mobile/plugin/1/images/iconemp_wev8.png\" title=\"<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>\">";
			rhtml += "&nbsp;" + nodebase.nodeOperatorNames;
			rhtml += "</td></tr>";
		} 
	} else if (nodebase.nodeOptType == 0) {
		rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
		rhtml += "<img src=\"/mobile/plugin/1/images/iconemp_wev8.png\" title=\"<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>\">";
		rhtml += "&nbsp;" + nodebase.nodeOperatorNames;
		rhtml += "</td></tr>";
	} else if (nodebase.nodeOptType == 2) {
		rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
		rhtml += "<img src=\"/mobile/plugin/1/images/imgPersonHead_wev8.png\" title=\"<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>\">";
		rhtml += "&nbsp;" + nodebase.nodeOperatorName;
		rhtml += "</td></tr>";
	}
	rhtml += "</table>";
	return rhtml;
}

function changeButton(atype){
	if(atype == 1){  //会签
		jQuery(".rolldiv").css({left:69});
		jQuery(".rightdiv").css("color","#ffffff");
		jQuery(".leftdiv").css("color","#8a9fad");
	}else{   //依次逐个处理
		jQuery(".rolldiv").css({left:0});
		jQuery(".leftdiv").css("color","#ffffff");
		jQuery(".rightdiv").css("color","#8a9fad");
	}
}

//设置包含画布的窗口的大小
function resizeContainer(){
	if(isset == 1){
		var containerHeight = jQuery(window).height() - 10;
		var containerWidth = jQuery(window).width();
		var containerTop = 0;
		if(iscreate == "true" || iscreate){
			//上方依次送达，同时送达的切换按钮
			var tabtop = jQuery("#rolltab").offset().top;
			var topheight = jQuery("#rolltab").height();
			containerTop = tabtop + topheight + 20;
			containerHeight = containerHeight - containerTop;

			//下方的窗口按钮
			if(isdialog == 1){
				containerHeight = containerHeight-jQuery("#zDialog_div_bottom").height();
			}

			containerHeight = containerHeight-jQuery(".tips").height() - 20;	   //提示信息的高度		
		}

		//处理滚动条的美化
		jQuery("#picturescroll").height(containerHeight).width(containerWidth).css({top:containerTop,position:"absolute"});
		var scrollObj = jQuery("#picturescroll").perfectScrollbar("getScrollObj");
		if(scrollObj.length > 0){
			jQuery("#picturescroll").perfectScrollbar("update");
		}else{
			jQuery("#picturescroll").perfectScrollbar();
		}

		jQuery("#picturescroll").perfectScrollbar("show");
	}
}

//保存操作
function saveWorkflowPicture(obj){
	obj.disabled = true;
	if($instance != null){
		try{
			$instance.saveWorkflowPicture(parentWin,parentDiv);
		}catch(e){
			console.log("save error>>" + e);
		}
	}

	//关闭对话框
	window.top.freedialog.close();
}

//提交流程
function submitWorkflow(obj){
	obj.disabled = true;

	//先保存自由流程的设置
	if($instance != null){
		try{
			$instance.saveWorkflowPicture(parentWin,parentDiv);
		}catch(e){
			console.log("save error>>" + e);
		}

		var _data = $instance.getData();
		var _nodes = _data.nodes;  //自由节点
		if(!_nodes || _nodes.length == 0){
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(129350,user.getLanguage())%>",
			function(){
				window.top.freewindow.doSubmit({});  //提交流程
				//关闭对话框
				window.top.freedialog.close();
			},function(){
				obj.disabled = false;
			},null,null,null,null,"<%=SystemEnv.getHtmlLabelName(129351,user.getLanguage())%>");			
		}else{
			window.top.freewindow.doSubmit({});  //提交流程
			//关闭对话框
			window.top.freedialog.close();
		}
	}else{
		window.top.freewindow.doSubmit({});  //提交流程
		//关闭对话框
		window.top.freedialog.close();
	}

}
</script>