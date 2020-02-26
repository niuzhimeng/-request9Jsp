<%@ page import="cn.hutool.core.io.FileUtil" %>
<%@ page import="cn.hutool.core.io.IoUtil" %>
<%@ page import="cn.hutool.core.util.ZipUtil" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<script src="https://cdn.staticfile.org/react/16.4.0/umd/react.development.js"></script>
<script src="https://cdn.staticfile.org/react-dom/16.4.0/umd/react-dom.development.js"></script>

<%
    BaseBean baseBean = new BaseBean();

    FileUtil.del("D:\\WEAVER\\ecology\\temp");

%>

<script type="text/javascript">
    function diyFun() {
        alert('催办')
    }
    function diyFun1() {
        alert('收回执行');
        WfForm.doRightBtnEvent("BTN_DORETRACT");
    }
</script>

<script type="text/javascript">

    function diyFun1() {
        WfForm.registerCheckEvent(WfForm.OPER_TAKEBACK, function (callback) {
            alert("back");
            callback();
        });
    }

    $(function () {
        var info = '这里是提示语！';
        window.weaJs.alert(info);

        var options = {
            title: '标题',
            moduleName: 'workflow',
            style: {width: 800, height: 600},
            callback: function () {
            },
            onCancel: function () {
            },
        };
        window.weaJs.showDialog('http://www.baidu.com', options);

    })

</script>







