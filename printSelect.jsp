<%@ page import="weaver.hrm.User" %>
<%@ page import="com.engine.workflow.entity.NodePrintInfoEntity" %>
<%@ page import="java.util.List" %>
<%@ page import="com.engine.workflow.cmd.workflowPath.node.form.print.GetPrintTableInfoCmd" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<html>


<head>
    <link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css"/>
    <script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>

    <script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
    <style type="text/css">
        .jNiceCheckbox_disabled {
            background-image: url(/js/ecology8/jNice/jNice/elements/checkbox_disabled_forprint_wev8.png) !important;
            margin-left: 2px;
        }

        .jNiceRadio_disabled {
            background-image: url(/js/ecology8/jNice/jNice/elements/radio_disabled_forprint_wev8.png) !important;
            margin-left: 2px;
        }
    </style>

    <style>
        body {
            margin: 0;
        }

        #selectDiv {
            position: absolute;
            left: 20px;
            top: 20px;
            width: 278px;
            height: 98%;
            background: inherit;
            background-color: rgba(255, 255, 255, 0);
            box-sizing: border-box;
            border-width: 1px;
            border-style: solid;
            border-color: rgba(204, 204, 204, 1);
            border-radius: 0px;
            -moz-box-shadow: none;
            -webkit-box-shadow: none;
            box-shadow: none;
            font-family: "Microsoft YaHei";
            font-size: 10px;
            list-style-type: circle;
            padding: 0;

        }

        #selectTitle {
            left: 0px;
            top: 0px;
            width: 259px;
            height: 45px;
            background: inherit;
            background-color: rgba(255, 255, 255, 1);
            box-sizing: border-box;
            border-width: 1px;
            border-style: solid;
            border-color: rgba(234, 234, 234, 1);
            border-left: 0px;
            border-top: 0px;
            border-right: 0px;
            border-radius: 0px;
            border-top-left-radius: 0px;
            border-top-right-radius: 0px;
            border-bottom-right-radius: 0px;
            border-bottom-left-radius: 0px;
            -moz-box-shadow: none;
            -webkit-box-shadow: none;
            box-shadow: none;
            font-size: 12px;
            line-height: 45px;

            padding-left: 24px;
            margin-left: 8px;
        }

        #printokbutton {

            width: 55px;
            height: 30px;
            background: inherit;
            background-color: rgba(48, 181, 255, 1);
            border: none;
            border-radius: 2px;
            -moz-box-shadow: none;
            -webkit-box-shadow: none;
            box-shadow: none;
            font-size: 12px;
            color: #FFFFFF;
            text-align: center;
            line-height: 30px;
            display: inline-block;
            margin-right: 23px;
        }

        #printcancelbutton {
            display: inline-block;
            width: 55px;
            height: 31px;
            background: inherit;
            background-color: rgba(255, 255, 255, 1);
            box-sizing: border-box;
            border-width: 1px;
            border-style: solid;
            border-color: rgba(217, 217, 217, 1);
            border-radius: 2px;
            -moz-box-shadow: none;
            -webkit-box-shadow: none;
            box-shadow: none;
            font-family: 'Microsoft YaHei Regular', 'Microsoft YaHei';
            font-weight: 400;
            font-style: normal;
            font-size: 12px;
            color: #666666;
            text-align: center;
            line-height: 30px;
        }

        .printbutton {
            margin-top: 25px;
            margin-left: 10px;
        }

        #printokbutton:hover {
            background-color: rgba(138, 204, 253, 1);
            cursor: pointer;
        }

        #printcancelbutton:hover {
            border-color: rgba(76, 177, 252, 1);
            cursor: pointer;
            color: rgba(76, 177, 252, 1);
        }

    </style>


    <SCRIPT>


        var oldsrc = "";

        jQuery(document).ready(function () {
            jQuery('body').jNice();
            jQuery('#printcancelbutton').click(function () {
                //alert('不知道做啥用的...');
            })

            jQuery('#printokbutton').click(function () {
                var modeid = Number(jQuery("input:radio:checked").val());
                var fromismode = 2;
                if (modeid < 0) {
                    if (!jQuery.browser.msie) {
                        alert("模板模式仅支持IE,请切换IE进行模板模式打印");
                        return;
                    }
                    modeid = -modeid;
                    fromismode = 1;

                }

                var src = location.href + "&fromSelect=1&fromismode=" + fromismode + "&fromModeid=" + modeid + "&needPrint=1"

                location.href = src;

            })


            oldsrc = location.href;

            var modeid = Number(jQuery("input:radio:checked").val());
            var fromismode = 2;
            if (modeid < 0) {
                if (!jQuery.browser.msie) {
                    alert("模板模式仅支持IE,请切换IE进行模板模式打印");
                    return;
                }
                modeid = -modeid;
                fromismode = 1;

            }

            var src = location.href + "&fromSelect=1&fromismode=" + fromismode + "&fromModeid=" + modeid;

            jQuery("#printframe").attr("src", src);


        });

        function changeCheckbox(obj) {

            var modeid = Number(obj.value);
            var fromismode = 2;
            if (modeid < 0) {
                if (!jQuery.browser.msie) {
                    alert("模板模式仅支持IE,请切换IE进行模板模式打印");
                    return;
                }
                modeid = -modeid;
                fromismode = 1;
            }

            jQuery("#printframe").attr("src", oldsrc + "&fromSelect=1&fromismode=" + fromismode + "&fromModeid=" + modeid);

        }

    </SCRIPT>
</head>
<body>

<!--zzw-->
<div id="selectDiv">

    <div id="selectTitle">请选择模板</div>

    <%
        User user = HrmUserVarify.getUser(request, response);
        int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
        int userid = user.getUID();                   //当前用户id
        String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
        int usertype = 0;
        if (logintype.equals("1")) usertype = 0;
        if (logintype.equals("2")) usertype = 1;
        int nodeid = WFLinkInfo.getCurrentNodeid(requestid, userid, Util.getIntValue(logintype, 1));               //节点id
        String nodetype = WFLinkInfo.getNodeType(nodeid);         //节点类型  0:创建 1:审批 2:实现 3:归档
        RecordSet rs = new RecordSet();
        rs.executeProc("workflow_Requestbase_SByID", requestid + "");
        int workflowid = 0;
        int currentnodeid = 0;
        if (rs.next()) {
            workflowid = Util.getIntValue(rs.getString("workflowid"), 0);
            currentnodeid = Util.getIntValue(rs.getString("currentnodeid"), 0);
            if (nodeid < 1) nodeid = currentnodeid;
        }
        String checked = "checked";
        //查询所有的模板
        List<NodePrintInfoEntity> printInfoEntityList = new GetPrintTableInfoCmd(new HashMap<String, Object>(), user).getDatas(workflowid, nodeid,user.getLanguage());

        if (printInfoEntityList.size() < 2) {
            System.out.println("没有选择模板.. 跳转回printrequest");
            response.sendRedirect("/workflow/request/PrintRequest.jsp?&fromSelect=1&needPrint=1&" + request.getQueryString());
        }

        for (NodePrintInfoEntity nodePrintInfoEntity : printInfoEntityList) {
            String mopdename = nodePrintInfoEntity.getModename();
            int printmodeid = nodePrintInfoEntity.getId();
    %>
    <div style="margin: 10px"><input onclick="changeCheckbox(this);" class="printcheckbox"
                                     id="checkbox_<%=printmodeid%>" type="radio" value="<%=printmodeid%>"
                                     name="printcheckbox" <%=checked%> >
        <%=mopdename%>
    </div>
    <%
            checked = "";
        }
    %>
    <div class="printbutton">

        <div id="printokbutton">确认</div>
        <div id="printcancelbutton">取消</div>
    </div>

</div>

<iframe id="printframe" frameborder="no" border="0" allowtransparency="yes" height="100%" width="100%"
        style="margin-left: 300px;" src="">


</iframe>
</body>
</html>