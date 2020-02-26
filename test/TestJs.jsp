<script type="text/javascript">
    var myLink = 'myLink';
    $(function () {
        setTimeout(function () {
            var myUrl = "http://www.baidu.com";
            var aName1 = '百度';
            $("#" + myLink).append("<a target='_blank' href=" + myUrl + ">" + aName1 + "</a>");
            $("#" + myLink).css("text-decoration", "underline");
            //$("#" + myLink).append("<input onclick='openXc()' class='e8_btn_top' type='button' value='携程连接' />");
        }, 200);

    });

    function openXc() {
        window.open('http://www.baidu.com');
    }
</script>

<input style="margin-left: -10px" type="button" value="携程连接" onclick="openXc()">

<script type="text/javascript">
    var fpId = 'field6336';
    $(function () {
        WfForm.registerCheckEvent(WfForm.OPER_SUBMIT, function (callback) {
            var mxh = WfForm.getDetailAllRowIndexStr('detail_1').split(',');
            var myNum = 1;
            var errMes = '';
            for (var i = 0; i < mxh.length; i++) {
                var fieldvalue = WfForm.getFieldValue(fpId + "_" + mxh[i]);
                if (fieldvalue >= 1) {
                    errMes += (myNum + ",");
                }
                myNum++;
            }
            if (errMes.length > 0) {
                errMes = errMes.substring(0, errMes.length - 1);
                window.top.Dialog.alert("第 " + errMes + " 行发票已经提交报销。");
            } else {
                callback();
            }
        });
    })
</script>

// 监控明细表新增 或 删除

<script type="text/javascript">
    jQuery(document).ready(function () {
        WfForm.registerCheckEvent(WfForm.OPER_ADDROW + "1" + "," + WfForm.OPER_ADDROW + "2", function (callback) {
            alert("添加明细1前执行逻辑，明细1则是OPER_ADDROW+1，依次类推");
            callback(); //允许继续添加行调用callback，不调用代表阻断添加 });
        })
    })
</script>


<script type="text/javascript">
    jQuery(document).ready(function () {
        WfForm.registerCheckEvent(WfForm.OPER_ADDROW + "1" + "," + WfForm.OPER_ADDROW + "2", function (callback) {
            let browserShowName = WfForm.getBrowserShowName("field6310");
            alert('获取显示值' + browserShowName)
            callback(); //允许继续添加行调用callback，不调用代表阻断添加 });
        })
    })
</script>

<script type="text/javascript">
    jQuery(document).ready(function () {
        jQuery("#icon10").append('<a href=" /formmode/view/AddFormMode.jsp?customTreeDataId=null&mainid=0&modeId=3&formId=-31&type=1" target="_blank"><img id="img1" src="/wui/common/page/images/加号.png" width="32" height="29"  /> </a>');
    })
</script>